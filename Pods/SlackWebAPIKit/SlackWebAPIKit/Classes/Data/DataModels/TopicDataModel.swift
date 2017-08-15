import Foundation
import ObjectMapper

public class TopicDataModel: Mappable {
    var value: String?
    var creator: String?
    var lastSet: Int?
    
    required public init?(map: Map) { }
    
    // Mappable
    public func mapping(map: Map) {
        value     <- map["value"]
        creator     <- map["creator"]
        lastSet     <- map["lastSet"]
    }
}
