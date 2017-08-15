import Foundation

extension TopicDataModel {
    func toModel() -> Topic {
        return Topic(value: value,
                     creator: creator,
                     lastSet: lastSet)
    }
}
