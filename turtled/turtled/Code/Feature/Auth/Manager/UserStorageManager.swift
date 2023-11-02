import Foundation

class UserStorageManager {
    static let shared = UserStorageManager()
    
    // 유저정보삭제
    func clearUserData() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "isLogin")
        UserDefaults.standard.removeObject(forKey: "deviceToken")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "email")
    }
    
    // Access token getter and setter
    var accessToken: String? {
        get { return UserDefaults.standard.string(forKey: "accessToken") }
        set { UserDefaults.standard.set(newValue, forKey: "accessToken") }
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
    
    // device Token Manager
    var email: String? {
        get { return UserDefaults.standard.string(forKey: "email") }
        set { UserDefaults.standard.set(newValue, forKey: "email") }
    }
    
}
