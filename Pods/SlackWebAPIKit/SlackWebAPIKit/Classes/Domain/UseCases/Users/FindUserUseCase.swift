import Foundation
import RxSwift

public protocol FindUserUseCaseProtocol: class {
    func execute(user: String) -> Observable<User>
}

public class FindUserUseCase: FindUserUseCaseProtocol {
    private let repository: UserRepositoryProtocol
    
    public init(repository: UserRepositoryProtocol = UserRepository()) {
        self.repository = repository
    }
    
    public func execute(user: String) -> Observable<User> {
        return repository.find(user: user)
    }
}
