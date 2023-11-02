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
    // username
    var username: String? {
          get { return UserDefaults.standard.string(forKey: "username") }
          set { UserDefaults.standard.set(newValue, forKey: "username") }
      }
    
    // Login status getter and setter
    var isLogin: Bool {
        get { return UserDefaults.standard.bool(forKey: "isLogin") }
        set { UserDefaults.standard.set(newValue, forKey: "isLogin") }
    }
    
    // device Token Manager
    var deviceToken: String? {
        get { return UserDefaults.standard.string(forKey: "deviceToken") }
        set { UserDefaults.standard.set(newValue, forKey: "deviceToken") }
    }
}
