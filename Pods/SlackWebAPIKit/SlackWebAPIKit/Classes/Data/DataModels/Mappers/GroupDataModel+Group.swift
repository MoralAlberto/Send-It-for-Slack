import Foundation

extension GroupDataModel {
    func toModel() -> Group {
        return Group(created: created,
                       creator: creator,
                       id: id,
                       isArchived: isArchived,
                       isChannel: isChannel,
                       isGeneral: isGeneral,
                       isMember: isMember,
                       isMPIM: isMPIM,
                       isOrgShared: isOrgShared,
                       isPrivate: isPrivate,
                       isShared: isShared,
                       name: name,
                       nameNormalized: nameNormalized,
                       numMembers: numMembers,
                       purpose: purpose?.toModel(),
                       topic: topic?.toModel())
    }
}
