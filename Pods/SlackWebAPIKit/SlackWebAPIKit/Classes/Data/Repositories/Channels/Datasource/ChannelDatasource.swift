import Foundation
import RxSwift
import ObjectMapper

enum ChannelDatasourceError: Error {
    case channelNotFound
    case invalidJSON
    case listIsEmpty
}

public protocol ChannelDatasourceProtocol: class {
    func list() -> Observable<[ChannelDataModel]>
    func find(channel: String) -> Observable<ChannelDataModel>
}

public class ChannelDatasource: ChannelDatasourceProtocol {
    
    fileprivate let apiClient: APIClientProtocol
    fileprivate let endpoint: Endpoint
    
    public init(apiClient: APIClientProtocol = APIClient(), endpoint: Endpoint = ChannelsListEndpoint()) {
        self.apiClient = apiClient
        self.endpoint = endpoint
    }
    
    public func find(channel: String) -> Observable<ChannelDataModel> {
        return apiClient.execute(withURL: endpoint.url).flatMap { (json) -> Observable<ChannelDataModel> in
            guard let JSONChannels = json["channels"] as? [[String: Any]],
                let channels = Mapper<ChannelDataModel>().mapArray(JSONObject: JSONChannels) else {
                return Observable.error(ChannelDatasourceError.invalidJSON)
            }
            guard let channelFound = channels.filter({ $0.name == channel }).first else {
                return Observable.error(ChannelDatasourceError.channelNotFound)
            }
            return Observable.just(channelFound)
        }
    }
    
    public func list() -> Observable<[ChannelDataModel]> {
        return apiClient.execute(withURL: endpoint.url).flatMap { (json) -> Observable<[ChannelDataModel]> in
            guard let JSONChannels = json["channels"] as? [[String: Any]],
                let channels = Mapper<ChannelDataModel>().mapArray(JSONObject: JSONChannels) else {
                return Observable.error(ChannelDatasourceError.invalidJSON)
            }
            if channels.isEmpty { return Observable.error(ChannelDatasourceError.listIsEmpty) }
            return Observable.from(optional: channels)
        }
    }
}
