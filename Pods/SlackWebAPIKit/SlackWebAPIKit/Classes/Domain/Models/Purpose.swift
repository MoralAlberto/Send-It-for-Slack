import Foundation

public class Purpose {
    public var value: String?
    public var creator: String?
    public var lastSet: Int?
    
    init(value: String?,
         creator: String?,
         lastSet: Int?) {
        self.value = value
        self.creator = creator
        self.lastSet = lastSet
    }
}
