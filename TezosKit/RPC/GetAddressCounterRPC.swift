// Copyright Keefer Taylor, 2018

import Foundation

/**
 * A RPC which will retrieve the counter for an address.
 */
public class GetAddressCounterRPC: TezosRPC<Int> {
  /**
   * - Parameter address: The address to retrieve info about.
   * - Parameter completion: A block to be called at completion of the operation.
   */
  public init(address: String, completion: @escaping (Int?, Error?) -> Void) {
    let endpoint = "/chains/main/blocks/head/context/contracts/" + address + "/counter"
    super.init(endpoint: endpoint, responseAdapterClass: IntegerResponseAdapter.self, completion: completion)
  }
}