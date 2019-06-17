// Copyright Keefer Taylor, 2019.

import Foundation

/// A policy to apply when deciding what gas limit to use.
public enum GasLimitPolicy {
  // TODO: Enable custom gas limits.
  // case custom(Int)
  case `default`
  // TODO: Enable gas limit estimation.
  //  case estimate
}

/// A policy to apply when deciding what fee to use.
public enum FeePolicy {
  // TODO: Enable custom gas limits.
  // case custom(Int)
  case `default`
  // TODO: Enable gas limit estimation.
  // case estimate
}

/// A policy to apply when deciding what storage limit to use.
public enum StorageLimitPolicy {
  case custom(Int)
  case `default`
}

/// Policies used to apply gas, storage and fees.
public struct OperationFeesPolicy {
  public let feePolicy: FeePolicy
  public let gasLimitPolicy: GasLimitPolicy
  public let storageLimitPolicy: StorageLimitPolicy

  public init(feePolicy: FeePolicy, gasLimitPolicy: GasLimitPolicy, storageLimitPolicy: StorageLimitPolicy) {
    self.feePolicy = feePolicy
    self.gasLimitPolicy = gasLimitPolicy
    self.storageLimitPolicy = storageLimitPolicy
  }
}
