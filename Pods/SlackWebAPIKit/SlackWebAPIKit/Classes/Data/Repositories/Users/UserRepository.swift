import Foundation
import RxSwift

public protocol UserRepositoryProtocol {
    func list() -> Observable<[User]>
    func find(user: String) -> Observable<User>
}

public class UserRepository: UserRepositoryProtocol {
    
    fileprivate let remoteDatasource: UserDatasourceProtocol
    
    public init(remoteDatasource: UserDatasourceProtocol = UserDatasource()) {
        self.remoteDatasource = remoteDatasource
    }
    
    public func list() -> Observable<[User]> {
        return remoteDatasource.list().map { $0.map { $0.toModel() } }
    }
    
    public func find(user: String) -> Observable<User> {
        return remoteDatasource.find(user: user).map { $0.toModel() }
    }
}
