import Foundation

public class User {
    public var id: String?
    public var teamId: String?
    public var name: String?
    public var deleted: Bool?
    public var color: String?
    public var realName: String?
    public var profileImage: String?
    
    init(id: String?,
         teamId: String?,
         name: String?,
         deleted: Bool?,
         color: String?,
         realName: String?,
         profileImage: String?) {
        
        self.id = id
        self.teamId = teamId
        self.name = name
        self.deleted = deleted
        self.color = color
        self.realName = realName
        self.profileImage = profileImage
    }
}
