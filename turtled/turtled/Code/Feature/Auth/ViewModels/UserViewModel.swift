import Foundation

class UserViewModel: ObservableObject {
    @Published var user: User = User()
    @Published var accessToken: String? {
        didSet {
            UserStorageManager.shared.accessToken = accessToken
        }
    }
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    static let shared = UserViewModel()
    
    func signupUser(email: String, username: String, password: String, checkedPassword: String, completion: @escaping (Bool) -> Void) {
        isLoading = true

        let parameters: [String: Any] = [
            "username": username,
            "email": email,
            "password": password,
            "checked_password": checkedPassword
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            completion(false)
            return
        }

        APIManager.shared.postRequest(endpoint: "/users/signup", parameters: parameters) { data, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    completion(false)
                    return
                }

                if let data = data, let httpResponse = data as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 204:
                        completion(true)
                    case 400:
                        self.errorMessage = "Bad Request: The server couldn't understand the request."
                        completion(false)
                    default:
                        self.errorMessage = "Unknown error occurred. HTTP status code: \(httpResponse.statusCode)"
                        completion(false)
                    }
                } else {
                    self.errorMessage = "Unexpected error occurred."
                    completion(false)
                }
            }
        }
    }


    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
    
        let requestBody = "username=\(email)&password=\(password)"
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        print(requestBody)
        // Use the specialized formPostRequest for this login function
        APIManager.shared.formPostRequest(endpoint: "/users/login/local", requestBody: requestBody, headers: headers) { data, error in
            
            if let data = data {
                do {
                    
                    let responseModel = try JSONDecoder().decode(LoginResponse.self, from: data)
                    self.accessToken = responseModel.data.jwt.access_token
                    UserStorageManager.shared.refreshToken = responseModel.data.jwt.refresh_token
                    UserStorageManager.shared.isLogin = true
                    completion(true)
                    
                    // 홈으로 이동
                    
                    
                    
                } catch {
                    print("로그인 요청 실패: \(error.localizedDescription)")
                    completion(false)
                }
            } else if let error = error {
                print("네트워크 오류: \(error.localizedDescription)")
            }
        }
    }



    func fetchUserData() {
        guard let accessToken = self.accessToken else {
            print("No access token available")
            return
        }

        // 엑세스토큰 보내기
        let headers = ["Authorization": "Bearer \(accessToken)"]
        
        APIManager.shared.getRequest(endpoint: "/users/profile", headers: headers) { data, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let data = data {
                do {
                    let userData = try JSONDecoder().decode(User.self, from: data)
                    DispatchQueue.main.async {
                        self.user = userData
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func logout() {
        user.nickName = ""
        user.email = ""
        accessToken = nil
        UserStorageManager.shared.isLogin = false
    }
}
