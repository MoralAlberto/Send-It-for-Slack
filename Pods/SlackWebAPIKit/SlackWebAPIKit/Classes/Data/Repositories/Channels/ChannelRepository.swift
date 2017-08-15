import Foundation
import RxSwift

public protocol ChannelRepositoryProtocol {
    func list() -> Observable<[Channel]>
    func find(channel: String) -> Observable<Channel>
}

public class ChannelRepository: ChannelRepositoryProtocol {
    
    fileprivate let remoteDatasource: ChannelDatasourceProtocol
    
    public init(remoteDatasource: ChannelDatasourceProtocol = ChannelDatasource()) {
        self.remoteDatasource = remoteDatasource
    }
    
    public func list() -> Observable<[Channel]> {
        return remoteDatasource.list().map { $0.map { $0.toModel() } }
    }
    
    public func find(channel: String) -> Observable<Channel> {
        return remoteDatasource.find(channel: channel).map { $0.toModel() }
    }
}
