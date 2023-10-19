import Foundation

class UserStorageManager {
    static let shared = UserStorageManager()
    
    // Access token getter and setter
    var accessToken: String? {
        get { return UserDefaults.standard.string(forKey: "accessToken") }
        set { UserDefaults.standard.set(newValue, forKey: "accessToken") }
    }
    
    // Refresh token getter and setter
    var refreshToken: String? {
        get { return UserDefaults.standard.string(forKey: "refreshToken") }
        set { UserDefaults.standard.set(newValue, forKey: "refreshToken") }
    }
    
    // Login status getter and setter
    var isLogin: Bool {
        get { return UserDefaults.standard.bool(forKey: "isLogin") }
        set { UserDefaults.standard.set(newValue, forKey: "isLogin") }
    }
}
