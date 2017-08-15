import Foundation
import RxSwift

public protocol FindChannelUseCaseProtocol {
    func execute(channel: String) -> Observable<Channel>
}

public class FindChannelUseCase: FindChannelUseCaseProtocol {
    private let repository: ChannelRepositoryProtocol
    
    public init(repository: ChannelRepositoryProtocol = ChannelRepository()) {
        self.repository = repository
    }
    
    public func execute(channel: String) -> Observable<Channel> {
        return repository.find(channel: channel)
    }
}
