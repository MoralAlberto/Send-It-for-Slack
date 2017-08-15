import Foundation
import ObjectMapper

public class ChannelDataModel: Mappable {
    var created: Int?
    var creator: String?
    var id: String?
    var isArchived: Bool?
    var isChannel: Bool?
    var isGeneral: Bool?
    var isMember: Bool?
    var isMPIM: Bool?
    var isOrgShared: Bool?
    var isPrivate: Bool?
    var isShared: Bool?
    var members: [String]?
    var name: String?
    var nameNormalized: String?
    var numMembers: Int?
    var purpose: PurposeDataModel?
    var topic: TopicDataModel?
    
    required public init?(map: Map) { }
    
    // Mappable
    public func mapping(map: Map) {
        created     <- map["created"]
        creator     <- map["creator"]
        id          <- map["id"]
        isArchived  <- map["is_archived"]
        isChannel   <- map["is_channel"]
        isGeneral   <- map["is_general"]
        isMember    <- map["is_member"]
        isMPIM      <- map["is_mpim"]
        isOrgShared <- map["is_org_shared"]
        isPrivate   <- map["is_private"]
        isShared    <- map["is_shared"]
        name        <- map["name"]
        nameNormalized <- map["name_normalized"]
        numMembers     <- map["num_memebers"]
        purpose     <- map["purpose"]
        topic       <- map["topic"]
    }
}
