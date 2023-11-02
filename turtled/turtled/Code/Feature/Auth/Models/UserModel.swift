import Foundation

class User: ObservableObject, Codable {
    var nickName: String = ""
    var email: String = ""
    var version: String?
    var supportEmail: String?
}

struct LoginResponse: Codable {
    let username: String
    let token_type: String
    let access_token: String
}


struct LoginData: Codable {
    let username : String
    let jwt: JWT
}

struct JWT: Codable {
    let token_type : String
    let access_token: String
}

