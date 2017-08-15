import Foundation

//func ==(lhs: APIClientError, rhs: APIClientError) -> Bool {
//    return lhs == rhs
//}

enum APIClientError: Error {
    enum ErrorCode: String {
        case channelNotFound = "channel_not_found"
        case notInChannel = "not_in_channel"
        case isArchived = "is_archived"
        case msgToLong = "msg_too_long"
        case noText = "no_text"
        case rateLimited = "rate_limited"
        case notAuthed = "not_authed"
        case notAuthenticated = "invalid_auth"
        case accountInactive = "account_inactive"
        case invalidArgName = "invalid_arg_name"
        case invalidArrayArg = "invalid_array_arg"
        case invalidCharset = "invalid_charset"
        case invalidFormData = "invalid_form_data"
        case invalidPostType = "invalid_post_type"
        case missingPostType = "missing_post_type"
        case teamAddedToOrg = "team_added_to_org"
        case requestTimeout = "request_timeout"
    }
    
    case channelNotFound
    case notInChannel
    case isArchived
    case msgToLong
    case noText
    case rateLimited
    case notAuthed
    case notAuthenticated
    case accountInactive
    case invalidArgName
    case invalidArrayArg
    case invalidCharset
    case invalidFormData
    case invalidPostType
    case missingPostType
    case teamAddedToOrg
    case requestTimeout
    case unhandled(localizedDescription: String)
        
    init(type: String) {
        if let error = ErrorCode(rawValue: type) {
            switch error {
            case .channelNotFound:
                self = .channelNotFound
            case .notInChannel:
                self = .notInChannel
            case .isArchived:
                self = .isArchived
            case .msgToLong:
                self = .msgToLong
            case .noText:
                self = .noText
            case .rateLimited:
                self = .rateLimited
            case .notAuthed:
                self = .notAuthed
            case .notAuthenticated:
                self = .notAuthenticated
            case .accountInactive:
                self = .accountInactive
            case .invalidArgName:
                self = .invalidArgName
            case .invalidArrayArg:
                self = .invalidArrayArg
            case .invalidCharset:
                self = .invalidCharset
            case .invalidFormData:
                self = .invalidFormData
            case .invalidPostType:
                self = .invalidPostType
            case .missingPostType:
                self = .missingPostType
            case .teamAddedToOrg:
                self = .teamAddedToOrg
            case .requestTimeout:
                self = .requestTimeout
            }
        } else {
            self = .unhandled(localizedDescription: type)
        }
    }
}
