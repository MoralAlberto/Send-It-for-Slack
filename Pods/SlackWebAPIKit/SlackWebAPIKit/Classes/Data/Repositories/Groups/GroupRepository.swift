import Foundation
import RxSwift

public protocol GroupRepositoryProtocol {
    func list() -> Observable<[Group]>
    func find(group: String) -> Observable<Group>
}

public class GroupRepository: GroupRepositoryProtocol {
    
    fileprivate let remoteDatasource: GroupDatasourceProtocol
    
    public init(remoteDatasource: GroupDatasourceProtocol = GroupDatasource()) {
        self.remoteDatasource = remoteDatasource
    }
    
    public func list() -> Observable<[Group]> {
        return remoteDatasource.list().map { $0.map { $0.toModel() } }
    }
    
    public func find(group: String) -> Observable<Group> {
        return remoteDatasource.find(group: group).map { $0.toModel() }
    }
}
