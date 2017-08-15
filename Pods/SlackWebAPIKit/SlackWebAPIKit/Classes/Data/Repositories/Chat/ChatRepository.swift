import Foundation
import RxSwift

public protocol ChatRepositoryProtocol {
    func postMessage(text: String, channel: String) -> Observable<Bool>
}

public class ChatRepository: ChatRepositoryProtocol {
    
    fileprivate let remoteDatasource: ChatDatasourceProtocol
    
    public init(remoteDatasource: ChatDatasourceProtocol = ChatDatasource()) {
        self.remoteDatasource = remoteDatasource
    }
    
    public func postMessage(text: String, channel: String) -> Observable<Bool> {
        return remoteDatasource.postMessage(text: text, channel: channel)
    }
}
