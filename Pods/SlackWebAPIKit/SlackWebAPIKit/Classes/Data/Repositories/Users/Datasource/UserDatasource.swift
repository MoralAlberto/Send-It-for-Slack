import Foundation
import RxSwift
import ObjectMapper

enum UserDatasourceError: Error {
    case userNotFound
    case invalidJSON
    case listIsEmpty
}

public protocol UserDatasourceProtocol: class {
    func list() -> Observable<[UserDataModel]>
    func find(user: String) -> Observable<UserDataModel>
}

public class UserDatasource: UserDatasourceProtocol {
    
    fileprivate let apiClient: APIClientProtocol
    fileprivate let endpoint: Endpoint
    
    public init(apiClient: APIClientProtocol = APIClient(), endpoint: Endpoint = UsersListEndpoint()) {
        self.apiClient = apiClient
        self.endpoint = endpoint
    }
    
    public func find(user: String) -> Observable<UserDataModel> {
        return apiClient.execute(withURL: endpoint.url).flatMap { (json) -> Observable<UserDataModel> in
            guard let JSONUsers = json["members"] as? [[String: Any]],
                let users = Mapper<UserDataModel>().mapArray(JSONObject: JSONUsers) else {
                    return Observable.error(UserDatasourceError.invalidJSON)
            }
            guard let userFound = users.filter({ $0.name == user }).first else {
                return Observable.error(UserDatasourceError.userNotFound)
            }
            return Observable.just(userFound)
        }
    }
    
    public func list() -> Observable<[UserDataModel]> {
        return apiClient.execute(withURL: endpoint.url).flatMap { (json) -> Observable<[UserDataModel]> in
            guard let JSONUsers = json["members"] as? [[String: Any]],
                let users = Mapper<UserDataModel>().mapArray(JSONObject: JSONUsers) else {
                    return Observable.error(UserDatasourceError.invalidJSON)
            }
            if users.isEmpty { return Observable.error(UserDatasourceError.listIsEmpty) }
            return Observable.from(optional: users)
        }
    }
}
