import Foundation

extension TeamDataModel {
    func toModel() -> Team {
        return Team(id: id,
                    name: name,
                    domain: domain,
                    emailDomain: emailDomain,
                    icon: icon?.image68)
    }
}
