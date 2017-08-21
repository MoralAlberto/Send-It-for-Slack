import Foundation

public class Channel {
    public var created: Int?
    public var creator: String?
    public var id: String?
    public var isArchived: Bool?
    public var isChannel: Bool?
    public var isGeneral: Bool?
    public var isMember: Bool?
    public var isMPIM: Bool?
    public var isOrgShared: Bool?
    public var isPrivate: Bool?
    public var isShared: Bool?
    public var name: String?
    public var nameNormalized: String?
    public var numMembers: Int?
    public var purpose: Purpose?
    public var topic: Topic?
    
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
