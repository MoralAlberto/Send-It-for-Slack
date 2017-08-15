import Foundation
import Alamofire

protocol AccessTokenAdapterProtocol: class {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest
}

class AccessTokenAdapter: RequestAdapter, AccessTokenAdapterProtocol {
    private struct Parameters {
        static let token = "token"
    }
    
    private let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        guard let urlString = urlRequest.url?.absoluteString,
            urlString.hasPrefix(API.sharedInstance.baseUrl),
            let url = urlRequest.url,
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                return urlRequest
        }
        
        let queryToken = [URLQueryItem(name: Parameters.token, value: accessToken)]
        
        guard urlComponents.queryItems != nil else {
            urlComponents.queryItems = queryToken
            urlRequest.url = urlComponents.url
            return urlRequest
        }
        urlComponents.queryItems?.append(contentsOf: queryToken)
        urlRequest.url = urlComponents.url
        return urlRequest
    }
}
