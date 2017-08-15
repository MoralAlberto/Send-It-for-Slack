import Foundation
import RxSwift
import ObjectMapper

enum GroupDatasourceError: Error {
    case groupNotFound
    case invalidJSON
    case listIsEmpty
}

public protocol GroupDatasourceProtocol: class {
    func list() -> Observable<[GroupDataModel]>
    func find(group: String) -> Observable<GroupDataModel>
}

public class GroupDatasource: GroupDatasourceProtocol {
    
    fileprivate let apiClient: APIClientProtocol
    fileprivate let endpoint: Endpoint
    
    public init(apiClient: APIClientProtocol = APIClient(), endpoint: Endpoint = GroupsListEndpoint()) {
        self.apiClient = apiClient
        self.endpoint = endpoint
    }
    
    public func find(group: String) -> Observable<GroupDataModel> {
        return apiClient.execute(withURL: endpoint.url).flatMap { (json) -> Observable<GroupDataModel> in
            guard let JSONGroups = json["groups"] as? [[String: Any]],
                let groups = Mapper<GroupDataModel>().mapArray(JSONObject: JSONGroups) else {
                    return Observable.error(GroupDatasourceError.invalidJSON)
            }
            guard let groupFound = groups.filter({ $0.name == group }).first else {
                return Observable.error(GroupDatasourceError.groupNotFound)
            }
            return Observable.just(groupFound)
        }
    }
    
    public func list() -> Observable<[GroupDataModel]> {
        return apiClient.execute(withURL: endpoint.url).flatMap { (json) -> Observable<[GroupDataModel]> in
            guard let JSONGroups = json["groups"] as? [[String: Any]],
                let groups = Mapper<GroupDataModel>().mapArray(JSONObject: JSONGroups) else {
                    return Observable.error(GroupDatasourceError.invalidJSON)
            }
            if groups.isEmpty { return Observable.error(GroupDatasourceError.listIsEmpty) }
            return Observable.from(optional: groups)
        }
    }
}
