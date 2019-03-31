// Copyright Keefer Taylor, 2019.

/// An RPC which fetches received transactions for an account.
public class GetReceivedTransactionsRPC: ConseilQueryRPC<[Transaction]> {
  /// - Parameters:
  ///   - account: The account to query.
  ///   - limit: The number of items to return.
  ///   - apiKey: The API key to send in the request headers.
  ///   - platform: The platform to query.
  ///   - network: The network to query.
  public init?(account: String, limit: Int, apiKey: String, platform: ConseilPlatform, network: ConseilNetwork) {
    let predicates: [ConseilPredicate] = [
      ConseilQuery.Predicates.predicateWith(field: "kind", set: ["transaction"]),
      ConseilQuery.Predicates.predicateWith(field: "destination", set: [account])
    ]
    let orderBy: ConseilOrderBy = ConseilQuery.OrderBy.orderBy(field: "timestamp")
    let query: [String: Any] = ConseilQuery.query(predicates: predicates, orderBy: orderBy, limit: limit)

    super.init(
      query: query,
      entity: .operation,
      apiKey: apiKey,
      platform: platform,
      network: network,
      responseAdapterClass: TransactionsResponseAdapter.self
    )
  }
}
