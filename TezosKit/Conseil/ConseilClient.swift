// Copyright Keefer Taylor, 2019

/// Conseil Client is a WIP.
/// Remaining Work:
/// - Support for query parameters
/// - First class respoonse objects
/// - Promises Extension
/// - Integration Tests
/// - Updating documentation

/// A client for a Conseil Server.
public class ConseilClient: AbstractClient {
  /// The platfom that this client will query.
  private let platform: ConseilPlatform

  /// The network that this client will query.
  private let network: ConseilNetwork

  /// The API key for the remote Conseil service.
  private let apiKey: String

  /// Initialize a new client for a Conseil Service.
  /// - Parameters:
  ///   - remoteNodeURL: The path to the remote Conseil service.
  ///   - apiKey: The API key for the remote Conseil service.
  ///   - platform: The platform to query, defaults to tezos.
  ///   - network: The network to query, defaults to mainnet.
  ///   - urlSession: The URLSession that will manage network requests, defaults to the shared session.
  ///   - callbackQueue: A dispatch queue that callbacks will be made on, defaults to the main queue.
  public init(
    remoteNodeURL: URL,
    apiKey: String,
    platform: ConseilPlatform = .tezos,
    network: ConseilNetwork = .mainnet,
    urlSession: URLSession = URLSession.shared,
    callbackQueue: DispatchQueue = DispatchQueue.main
  ) {
    self.platform = platform
    self.network = network
    self.apiKey = apiKey

    super.init(
      remoteNodeURL: remoteNodeURL,
      urlSession: urlSession,
      callbackQueue: callbackQueue,
      responseHandler: RPCResponseHandler()
    )
  }

  /// Retrieve originated accounts.
  ///
  /// - Parameters:
  ///   - account: The account to query.
  ///   - limit: The number of transactions to return, defaults to 100.
  ///   - completion: A completion callback.
  public func originatedAccounts(
    from account: String,
    limit: Int = 100,
    completion: @escaping (Result<[[String: Any]], TezosKitError>) -> Void
  ) {
    guard let rpc = GetOriginatedAccounts(
      account: account,
      limit: limit,
      apiKey: apiKey,
      platform: platform,
      network: network
      ) else {
        self.callbackQueue.async {
          completion(.failure(TezosKitError(kind: .invalidURL, underlyingError: nil)))
        }
        return
    }
    send(rpc, completion: completion)
  }

  /// Retrieve transactions received from an account.
  /// - Parameters:
  ///   - account: The account to query.
  ///   - limit: The number of transactions to return, defaults to 100.
  ///   - completion: A completion callback.
  public func transactionsReceived(
    from account: String,
    limit: Int = 100,
    completion: @escaping (Result<[Transaction], TezosKitError>) -> Void
    ) {
    guard let rpc = GetReceivedTransactionsRPC(
      account: account,
      limit: limit,
      apiKey: apiKey,
      platform: platform,
      network: network
      ) else {
        self.callbackQueue.async {
          completion(.failure(TezosKitError(kind: .invalidURL, underlyingError: nil)))
        }
        return
    }
    send(rpc, completion: completion)
  }

  /// Retrieve transactions sent from an account.
  /// - Parameters:
  ///   - account: The account to query.
  ///   - limit: The number of transactions to return, defaults to 100.
  ///   - completion: A completion callback.
  public func transactionsSent(
    from account: String,
    limit: Int = 100,
    completion: @escaping (Result<[Transaction], TezosKitError>) -> Void
  ) {
    guard let rpc = GetSentTransactionsRPC(
      account: account,
      limit: limit,
      apiKey: apiKey,
      platform: platform,
      network: network
    ) else {
      self.callbackQueue.async {
        completion(.failure(TezosKitError(kind: .invalidURL, underlyingError: nil)))
      }
      return
    }
    send(rpc, completion: completion)
  }
}
