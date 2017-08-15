import Foundation
import RxSwift

public protocol GroupsListUseCaseProtocol: class {
    func execute() -> Observable<[Group]>
}

public class GroupsListUseCase: GroupsListUseCaseProtocol {
    private let repository: GroupRepositoryProtocol
    
    public init(repository: GroupRepositoryProtocol = GroupRepository()) {
        self.repository = repository
    }
    
    public func execute() -> Observable<[Group]> {
        return repository.list()
    }
}
