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
            print("Error: Could not serialize JSON")

            completion(false)
            return
        }

        APIManager.shared.postRequest(endpoint: "/users/signup", parameters: parameters) { data, error in
            DispatchQueue.main.async {
                print("Load False")
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    print("Signup Error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                print("Load False222")
                if let data = data, let httpResponse = data as? HTTPURLResponse {
                    print(data)
                    switch httpResponse.statusCode {
                    case 204:
                        print("Signup Successful: HTTP status code 204")

                        completion(true)
                        
                    case 400:
                        self.errorMessage = "Bad Request: The server couldn't understand the request."
                        print("Signup Failed: \(self.errorMessage ?? "")")
                        completion(false)
                    default:
                        self.errorMessage = "Unknown error occurred. HTTP status code: \(httpResponse.statusCode)"
                        print("Signup Failed: \(self.errorMessage ?? "")")
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
    
        let parameters = ["username": email, "password": password]
         let requestBody = parameters.map { "\($0)=\($1.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")" }.joined(separator: "&")
        print(requestBody)
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]

        APIManager.shared.formPostRequest(endpoint: "/users/login/local", requestBody: requestBody, headers: headers) { data, error in
            
            if let error = error {
                print("네트워크 오류: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            
            if let data = data {
                       // 서버로부터의 응답을 문자열로 변환하여 출력합니다.
                       let responseString = String(data: data, encoding: .utf8) ?? "응답을 문자열로 변환할 수 없습니다."
                       print("서버 응답: \(responseString)")
                       
                       do {
                           
                           // JSON 응답을 LoginResponse 구조체로 파싱합니다.
                           let responseModel = try JSONDecoder().decode(LoginResponse.self, from: data)
                           print("서버 응답: \(responseModel)")
                           
                           // 파싱된 데이터를 저장합니다.
                           UserStorageManager.shared.username = responseModel.username
                           UserStorageManager.shared.accessToken = responseModel.access_token
                           UserStorageManager.shared.isLogin = true
                           completion(true)
                           print("로그인 진행 완료")
                       } catch {
                           print("로그인 요청 실패: \(error.localizedDescription)")
                           completion(false)
                       }
                   } else {
                       print("응답 데이터가 없습니다.")
                       completion(false)
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
