// Copyright Keefer Taylor, 2018

import Foundation

/// An object encapsulating the payment for an operation on the blockchain.
public struct OperationFees {
  // Note: these cannot be nil, because otherwise we'd be able to return nil default fees in operations.
  public let fee: Tez
  public let gasLimit: Tez
  public let storageLimit: Tez
}
