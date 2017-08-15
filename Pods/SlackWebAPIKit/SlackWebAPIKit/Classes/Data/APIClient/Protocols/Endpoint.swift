import Foundation

public protocol Endpoint: class {
    var path: String { get }
    var url: URL? { get }
    var endpointType: EndpointType { get }
    var parameters: [String: String]? { get }
}

extension Endpoint {
    public var path: String {
        return endpointType.rawValue
    }
    
    public var endpoint: String {
        return "\(API.sharedInstance.baseUrl)\(path)"
    }
    
    public var url: URL? {
        get {
            guard let finalURL = URL(string: endpoint) else { return nil }
            guard var urlComponents = URLComponents(url: finalURL, resolvingAgainstBaseURL: false),
                let params = parameters else {
                    return finalURL
            }
            urlComponents.queryItems = queryItems(params)
            return urlComponents.url
        }
    }
    
    func queryItems(_ dictionary: [String: String]) -> [URLQueryItem] {
        return dictionary.map {
            URLQueryItem(name: $0, value: $1)
        }
    }
}
