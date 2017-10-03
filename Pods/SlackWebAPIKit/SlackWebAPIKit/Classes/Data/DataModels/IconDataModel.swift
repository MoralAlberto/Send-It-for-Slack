import Foundation
import ObjectMapper

public class IconDataModel: Mappable {
    var image34: String?
    var image44: String?
    var image68: String?
    var image88: String?
    var image102: String?
    var image132: String?
    var image230: String?
    
    required public init?(map: Map) { }
    
    // Mappable
    public func mapping(map: Map) {
        image34     <- map["image_34"]
        image44     <- map["image_44"]
        image68     <- map["image_68"]
        image88     <- map["image_88"]
        image102    <- map["image_102"]
        image132    <- map["image_132"]
        image230    <- map["image_230"]
    }
}
