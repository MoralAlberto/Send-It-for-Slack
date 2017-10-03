import Foundation
import RxSwift

public protocol TeamInfoUseCaseProtocol: class {
    func execute() -> Observable<Team>
}

public class TeamInfoUseCase: TeamInfoUseCaseProtocol {
    private let repository: TeamRepositoryProtocol
    
    public init(repository: TeamRepositoryProtocol = TeamRepository()) {
        self.repository = repository
    }
    
    public func execute() -> Observable<Team> {
        return repository.info()
    }
}
