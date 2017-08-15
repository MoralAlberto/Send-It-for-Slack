import Foundation

public class User {
    var id: String?
    var teamId: String?
    var name: String?
    var deleted: Bool?
    var color: String?
    var realName: String?
    var profileImage: String?
    
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
