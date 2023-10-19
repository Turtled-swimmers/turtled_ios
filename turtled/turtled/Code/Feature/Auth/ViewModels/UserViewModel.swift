import Foundation

class UserViewModel: ObservableObject {
    @Published var user: User = User()
    @Published var accessToken: String? // 엑세스 토큰을 저장할 프로퍼티 추가
    
    // 공유하기
    static let shared = UserViewModel()
    
    // 로그인 메서드
    func login(email: String, password: String) {
        // 로그인 요청을 생성
        let url = URL(string: "https://turtled-back.dcs-seochan99.com/api/v1/users/login/local")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // 로그인 요청에 필요한 데이터를 생성
        let requestBody = "email=\(email)&password=\(password)"
        request.httpBody = requestBody.data(using: .utf8)
        
        // 로그인 요청을 서버로 보냄
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    // 서버 응답을 디코딩하여 엑세스 토큰을 추출
                    let decoder = JSONDecoder()
                    let responseModel = try decoder.decode(LoginResponse.self, from: data)
                    let accessToken = responseModel.data.jwt.access_token
                    let refreshToken = responseModel.data.jwt.refresh_token
                    
                    // 엑세스 토큰을 UserDefaults에 저장
                    UserDefaults.standard.set(accessToken, forKey: "accessToken")
                    UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                    
                    // 로그인 상태를 true로 설정
                    UserDefaults.standard.set(true, forKey: "isLogin")
                    
                    // 뷰모델의 엑세스 토큰 업데이트
                    self.accessToken = accessToken
                    
                } catch {
                    // 디코딩 실패 또는 다른 에러 처리
                    print("로그인 요청 실패: \(error.localizedDescription)")
                }
            } else if let error = error {
                // 네트워크 오류 처리
                print("네트워크 오류: \(error.localizedDescription)")
            }
        }.resume()
    }

    // 서버에서 User 정보 가져오기
    func fetchUserData() {
        guard let accessToken = self.accessToken else {
            print("No access token available")
            return
        }
        
        guard let url = URL(string: "https://turtled-back.dcs-seochan99.com/api/v1/users/profile") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Authorization 헤더에 Bearer 토큰 추가
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let userData = try JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async {
                    self.user = userData // 받아온 데이터를 User 모델에 저장
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // 로그아웃 초기화
    func logout() {
        user.nickName = ""
        user.email = ""
        accessToken = nil // 엑세스 토큰 초기화
    }
}
