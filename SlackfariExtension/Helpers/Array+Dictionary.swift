
func arrayContains(teams: [TeamModel], value: String) -> (hasKey: Bool, position: Int?) {
    var index = 0
    for team in teams {
        if team.name == value {
            return (true, index)
        }
        index += 1
    }
    return (false, nil)
}
