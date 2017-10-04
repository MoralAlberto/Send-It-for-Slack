/**
 *  Slackfari
 *  Copyright (c) 2017 Alberto Moral
 *  Licensed under the MIT license, see LICENSE file
 */

func arrayContains(teamName: String, in teams: [TeamModel]) -> (hasKey: Bool, position: Int?) {
    var index = 0
    for team in teams {
        if team.name == teamName {
            return (true, index)
        }
        index += 1
    }
    return (false, nil)
}
