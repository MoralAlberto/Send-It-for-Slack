import Foundation

extension UserDataModel {
    func toModel() -> User {
        return User(id: id,
                    teamId: teamId,
                    name: name,
                    deleted: deleted,
                    color: color,
                    realName: realName,
                    profileImage: profileImage)
    }
}
