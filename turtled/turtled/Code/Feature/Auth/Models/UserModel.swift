import Foundation

class User: ObservableObject, Codable {
    var nickName: String = ""
    var email: String = ""
    var version: String?
    var supportEmail: String?
}

struct LoginResponse: Codable {
    let success: Bool
    let data: LoginData
    let error: String?
}

struct LoginData: Codable {
    let jwt: JWT
}

struct JWT: Codable {
    let access_token: String
    let refresh_token: String
}

