import Foundation
import RxSwift

public protocol PostMessageUseCaseProtocol {
    func execute(text: String, channel: String) -> Observable<Bool>
}

public class PostMessageUseCase: PostMessageUseCaseProtocol {
    private let repository: ChatRepositoryProtocol
    
    public init(repository: ChatRepositoryProtocol = ChatRepository()) {
        self.repository = repository
    }

    public func execute(text: String, channel: String) -> Observable<Bool> {
        return repository.postMessage(text: text, channel: channel)
    }
}
