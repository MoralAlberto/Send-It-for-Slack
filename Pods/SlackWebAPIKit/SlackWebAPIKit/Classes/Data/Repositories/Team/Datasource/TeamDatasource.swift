import Foundation
import RxSwift
import ObjectMapper

enum TeamDatasourceError: Error {
    case invalidJSON
}

public protocol TeamDatasourceProtocol: class {
    func info() -> Observable<TeamDataModel>
}

public class TeamDatasource: TeamDatasourceProtocol {
    
    fileprivate let apiClient: APIClientProtocol
    fileprivate let endpoint: Endpoint
    
    public init(apiClient: APIClientProtocol = APIClient(), endpoint: Endpoint = TeamInfoEndpoint()) {
        self.apiClient = apiClient
        self.endpoint = endpoint
    }
    
    public func info() -> Observable<TeamDataModel> {
        return apiClient.execute(withURL: endpoint.url).flatMap { (json) -> Observable<TeamDataModel> in
            guard let JSONTeam = json["team"] as? [String: Any],
                let team = Mapper<TeamDataModel>().map(JSONObject: JSONTeam) else {
                    return Observable.error(TeamDatasourceError.invalidJSON)
            }
            return Observable.just(team)
        }
    }
}
