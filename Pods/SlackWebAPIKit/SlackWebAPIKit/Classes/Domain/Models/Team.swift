import Foundation

public class Team {
    public var id: String?
    public var name: String?
    public var domain: String?
    public var emailDomain: String?
    public var icon: String?
    
    init(id: String?,
         name: String?,
         domain: String?,
         emailDomain: String?,
         icon: String?) {
        
        self.id = id
        self.name = name
        self.domain = domain
        self.emailDomain = emailDomain
        self.icon = icon
    }
}
