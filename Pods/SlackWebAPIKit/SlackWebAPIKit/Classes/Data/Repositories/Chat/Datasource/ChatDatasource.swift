import Foundation
import RxSwift

public protocol ChatDatasourceProtocol: class {
    func postMessage(text: String, channel: String) -> Observable<Bool>
}

public class ChatDatasource: ChatDatasourceProtocol {
    
    fileprivate let apiClient: APIClientProtocol
    
    public init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    public func postMessage(text: String, channel: String) -> Observable<Bool> {
        let postMessage = PostMessageEndpoint(text: text, channel: channel)
        return apiClient.execute(withURL: postMessage.url).flatMap { _ -> Observable<Bool> in
            return Observable.just(true)
        }
    }
}
