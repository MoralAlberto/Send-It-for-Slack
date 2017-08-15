import Foundation

public class Channel {
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
    var name: String?
    var nameNormalized: String?
    var numMembers: Int?
    var purpose: Purpose?
    var topic: Topic?
    
    init(created: Int?,
         creator: String?,
         id: String?,
         isArchived: Bool?,
         isChannel: Bool?,
         isGeneral: Bool?,
         isMember: Bool?,
         isMPIM: Bool?,
         isOrgShared: Bool?,
         isPrivate: Bool?,
         isShared: Bool?,
         name: String?,
         nameNormalized: String?,
         numMembers: Int?,
         purpose: Purpose?,
         topic: Topic?) {
        self.created = created
        self.creator = creator
        self.id = id
        self.isArchived = isArchived
        self.isChannel = isChannel
        self.isGeneral = isGeneral
        self.isMember = isMember
        self.isMPIM = isMPIM
        self.isOrgShared = isOrgShared
        self.isPrivate = isPrivate
        self.isShared = isShared
        self.name = name
        self.nameNormalized = name
        self.numMembers = numMembers
        self.purpose = purpose
        self.topic = topic
    }
}
