import Foundation

extension PurposeDataModel {
    func toModel() -> Purpose {
        return Purpose(value: value,
                     creator: creator,
                     lastSet: lastSet)
    }
}
