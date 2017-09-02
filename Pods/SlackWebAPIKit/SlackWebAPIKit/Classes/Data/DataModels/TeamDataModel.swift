import Foundation
import ObjectMapper

public class TeamDataModel: Mappable {
    var id: String?
    var name: String?
    var domain: String?
    var emailDomain: String?
    var icon: IconDataModel?
    
    required public init?(map: Map) { }
    
    // Mappable
    public func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        domain          <- map["domain"]
        emailDomain     <- map["email_domain"]
        icon            <- map["icon"]
    }
}
