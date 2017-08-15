public class API {
    
    public static let sharedInstance = API()
    public let baseUrl = "https://slack.com/api/"
    private var token: String?
    
    public func set(token: String) {
        self.token = token
    }
    
    public func getToken() -> String? {
        return self.token
    }
}
