
func arrayContains(array: [[String:String]], key: String, value: String) -> (hasKey: Bool, position: Int?) {
    var index = 0
    for dict in array {
        if dict[key] == value {
            return (true, index)
        }
        index += 1
    }
    return (false, nil)
}
