import Foundation
import RxSwift

public protocol ChannelsListUseCaseProtocol: class {
    func execute() -> Observable<[Channel]>
}

public class ChannelsListUseCase: ChannelsListUseCaseProtocol {
    private let repository: ChannelRepositoryProtocol
    
    public init(repository: ChannelRepositoryProtocol = ChannelRepository()) {
        self.repository = repository
    }
    
    public func execute() -> Observable<[Channel]> {
        return repository.list()
    }
}
