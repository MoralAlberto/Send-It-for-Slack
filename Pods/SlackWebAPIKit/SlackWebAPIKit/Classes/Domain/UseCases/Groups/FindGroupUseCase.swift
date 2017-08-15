import Foundation
import RxSwift

public protocol FindGroupUseCaseProtocol: class {
    func execute(group: String) -> Observable<Group>
}

public class FindGroupUseCase: FindGroupUseCaseProtocol {
    private let repository: GroupRepositoryProtocol
    
    public init(repository: GroupRepositoryProtocol = GroupRepository()) {
        self.repository = repository
    }
    
    public func execute(group: String) -> Observable<Group> {
        return repository.find(group: group)
    }
}
