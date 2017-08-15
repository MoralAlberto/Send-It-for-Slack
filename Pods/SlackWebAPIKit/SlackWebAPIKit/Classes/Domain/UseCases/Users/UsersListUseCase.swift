import Foundation
import RxSwift

public protocol UsersListUseCaseProtocol: class {
    func execute() -> Observable<[User]>
}

public class UsersListUseCase: UsersListUseCaseProtocol {
    private let repository: UserRepositoryProtocol
    
    public init(repository: UserRepositoryProtocol = UserRepository()) {
        self.repository = repository
    }
    
    public func execute() -> Observable<[User]> {
        return repository.list()
    }
}
