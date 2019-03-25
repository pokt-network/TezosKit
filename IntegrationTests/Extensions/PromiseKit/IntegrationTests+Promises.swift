// Copyright Keefer Taylor, 2019.

import PromiseKit
@testable import TezosKit
import XCTest

/// Integration tests for the Promises Extension.
/// Please see instructions in header of `IntegrationTests.swift`.
extension TezosNodeIntegrationTests {
  public func testGetAccountBalance_promises() {
    let expectation = XCTestExpectation(description: "completion called")

    nodeClient.getBalance(wallet: .testWallet).done { result in
      XCTAssertNotNil(result)
      let balance = Double(result.humanReadableRepresentation)!
      XCTAssertGreaterThan(balance, 0.0, "Balance in account was not greater than 0")
      expectation.fulfill()
    } .catch { _ in
        XCTFail()
    }

    wait(for: [expectation], timeout: .expectationTimeout)
  }

  public func testOrigination_promises() {
    let expectation = XCTestExpectation(description: "completion called")

    self.nodeClient.originateAccount(
      managerAddress: Wallet.testWallet.address,
      keys: Wallet.testWallet.keys
    ).done { hash in
      XCTAssertNotNil(hash)
      expectation.fulfill()
    } .catch { _ in
      XCTFail()
    }

    wait(for: [expectation], timeout: .expectationTimeout)
  }

  public func testSend_promises() {
    let expectation = XCTestExpectation(description: "completion called")

    nodeClient.send(
      amount: Tez("1")!,
      to: "tz3WXYtyDUNL91qfiCJtVUX746QpNv5i5ve5",
      from: Wallet.testWallet.address,
      keys: Wallet.testWallet.keys
    ) .done { hash in
      XCTAssertNotNil(hash)
      expectation.fulfill()
    } .catch { _ in
      XCTFail()
    }

    wait(for: [expectation], timeout: .expectationTimeout)
  }

  public func testRunOperation_promises() {
    let expectation = XCTestExpectation(description: "completion called")

    let operation = OriginateAccountOperation(wallet: .testWallet)
    nodeClient.runOperation(operation, from: .testWallet) .done { result in
      guard let contents = result["contents"] as? [[String: Any]],
            let metadata = contents[0]["metadata"] as? [String: Any],
            let operationResult = metadata["operation_result"] as? [String: Any],
            let consumedGas = operationResult["consumed_gas"] as? String else {
          XCTFail()
          return
      }
      XCTAssertEqual(consumedGas, "10000")
      expectation.fulfill()
    } .catch { _ in
      XCTFail()
    }

    wait(for: [expectation], timeout: .expectationTimeout)
  }

  /// Preapplication should failure because of insufficient balance.
  public func testPreapplyFailure_promises() {
    let expectation = XCTestExpectation(description: "completion called")

    nodeClient.send(
      amount: Tez("10000000000000")!,
      to: "tz3WXYtyDUNL91qfiCJtVUX746QpNv5i5ve5",
      from: Wallet.testWallet.address,
      keys: Wallet.testWallet.keys
    ).done { _ in
      XCTFail()
    } .catch { error in
      guard let tezosKitError = error as? TezosKitError else {
        XCTFail()
        return
      }
      XCTAssertEqual(tezosKitError.kind, .preapplicationError)
      XCTAssert(tezosKitError.underlyingError!.contains("balance_too_low"))
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: .expectationTimeout)
  }

  public func testMultipleOperations_promises() {
    let expectation = XCTestExpectation(description: "completion called")

    let ops: [TezosKit.Operation] = [
      TransactionOperation(
        amount: Tez("1")!,
        source: .testWallet,
        destination: "tz3WXYtyDUNL91qfiCJtVUX746QpNv5i5ve5"
      ),
      TransactionOperation(
        amount: Tez("2")!,
        source: .testWallet,
        destination: "tz3WXYtyDUNL91qfiCJtVUX746QpNv5i5ve5"
      )
    ]

    nodeClient.forgeSignPreapplyAndInject(
      operations: ops,
      source: Wallet.testWallet.address,
      keys: Wallet.testWallet.keys
    ) .done { _ in
      expectation.fulfill()
    } .catch { _ in
      XCTFail()
    }
    wait(for: [expectation], timeout: .expectationTimeout)
  }
}
