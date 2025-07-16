import Foundation

public struct QueryParameter: RequestModifier {
    public let key: String
    public let value: String?

    public init(key: String, value: CustomStringConvertible?) {
        self.key = key
        self.value = value?.description
    }

    func modify(_ urlRequest: inout URLRequest) throws {
        guard let value = value else { return }
        urlRequest.url = urlRequest.url?.appendingQueryParameter(key, with: value)
    }
}
