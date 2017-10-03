import Foundation
import RxSwift

public protocol TeamRepositoryProtocol {
    func info() -> Observable<Team>
}

public class TeamRepository: TeamRepositoryProtocol {
    
    fileprivate let remoteDatasource: TeamDatasourceProtocol
    
    public init(remoteDatasource: TeamDatasourceProtocol = TeamDatasource()) {
        self.remoteDatasource = remoteDatasource
    }
    
    public func info() -> Observable<Team> {
        return remoteDatasource.info().map { $0.toModel() }
    }
}
