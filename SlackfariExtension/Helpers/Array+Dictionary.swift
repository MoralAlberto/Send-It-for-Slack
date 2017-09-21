
func arrayContains(array: [[String:String]], key: String, value: String) -> Bool {
    for dict in array {
        if dict[key] == value {
            return true
        }
    }
    return false
}
