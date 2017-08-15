import Foundation
import Alamofire
import ObjectMapper
import RxSwift

public protocol APIClientProtocol: class {
    func execute(withURL url: URL?) -> Observable<[String: Any]>
}

public class APIClient: APIClientProtocol {
    fileprivate let sessionManager = SessionManager()
    
    public init() {
        self.sessionManager.adapter = AccessTokenAdapter(accessToken: API.sharedInstance.getToken()!)
    }
    
    public func execute(withURL url: URL?) -> Observable<[String: Any]> {
        return Observable.create { [weak self] observable in
            guard let strongSelf = self else {
                return Disposables.create()
            }
            strongSelf.sessionManager.request(url!).responseJSON(queue: .global()) { (json) in
                guard let json = json.result.value as? [String : AnyObject] else {
                    observable.onError(APIClientError.unhandled(localizedDescription: "invalidJSON"))
                    return
                }
                
                guard let status = json["ok"] as? Bool, status == true else {
                    let error = APIClientError(type: json["error"] as! String)
                    observable.onError(error)
                    return
                }
                observable.onNext(json)
                observable.onCompleted()
            }
            return Disposables.create()
        }
    }
}
