public class PostMessageEndpoint: Endpoint {
    private struct Parameters {
        static let text = "text"
        static let channel = "channel"
        static let asUser = "as_user"
    }
    
    private let text: String
    private let channel: String
    private let asUser: Bool
    public var endpointType: EndpointType = .postMessage
    
    init(text: String, channel: String, asUser: Bool = true) {
        self.text = text
        self.channel = channel
        self.asUser = asUser
    }
    
    public var parameters: [String: String]? {
        get {
            return [Parameters.channel: "\(channel)",
                    Parameters.text: "\(text)",
                    Parameters.asUser: "\(asUser)"]
        }
    }
}
