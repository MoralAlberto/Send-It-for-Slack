import Foundation

public class Topic {
    var value: String?
    var creator: String?
    var lastSet: Int?
    
    init(value: String?,
         creator: String?,
         lastSet: Int?) {
        self.value = value
        self.creator = creator
        self.lastSet = lastSet
    }
}
