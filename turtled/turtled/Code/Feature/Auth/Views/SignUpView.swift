import SwiftUI
import Foundation

// 포스트 요청
func signupUser(email: String, username: String, password: String, checkedPassword: String, completion: @escaping (Bool) -> Void) {
    print("호출")
    let url = URL(string: "http://ec2-15-164-95-242.ap-northeast-2.compute.amazonaws.com:8000/api/v1/users/signup")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let bodyData = [
        "username": username,
        "email": email,
        "password": password,
        "checked_password": checkedPassword
    ]
    print(bodyData)
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: bodyData, options: [])
    
    print(request)
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil else {
            print("Error: \(error!.localizedDescription)")
            completion(false)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            completion(true)
        } else {
            completion(false)
        }
    }.resume()
    
}

    
struct SignUpView: View {
    @State private var email = ""
    @State private var nickname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var shouldNavigate = false
    // 체커
    private var isFormComplete: Bool {
         !email.isEmpty && !nickname.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && passwordsMatch
     }
     
    
    
    // 패스워드 매칭 여부
    private var passwordsMatch: Bool {
          password == confirmPassword
      }
      
    
    var body: some View {
          NavigationView {
              VStack(alignment: .leading, spacing: 10) {
                  
                  Text("이메일")
                      .font(Font.custom("SuIT", size: 18))
                      .foregroundColor(Color(red: 0.59, green: 0.8, blue: 0.7))
                  
                  TextField("이메일을 입력해주세요.", text: $email)
                      .padding(.horizontal, 10)
                      .padding(.vertical, 20.0)
                      .background(
                          RoundedRectangle(cornerRadius: 10)
                              .stroke(Color(red: 0.59, green: 0.8, blue: 0.7), lineWidth: 1)
                      )
                  
                  Text("닉네임")
                      .font(Font.custom("SuIT", size: 18))
                      .foregroundColor(Color(red: 0.59, green: 0.8, blue: 0.7))
                  
                  TextField("닉네임을 입력해주세요.", text: $nickname)
                      .padding(.horizontal, 10)
                      .padding(.vertical, 20.0)
                      .background(
                          RoundedRectangle(cornerRadius: 10)
                              .stroke(Color(red: 0.59, green: 0.8, blue: 0.7), lineWidth: 1)
                      )
                  
//                  Text("비밀번호")
//                      .font(Font.custom("SuIT", size: 18))
//                      .foregroundColor(Color(red: 0.59, green: 0.8, blue: 0.7))
                  
                  SecureField("Password", text: $password)
                      .padding(.horizontal, 10)
                      .padding(.vertical, 20.0)
                      .background(
                          RoundedRectangle(cornerRadius: 10)
                              .stroke(Color(red: 0.59, green: 0.8, blue: 0.7), lineWidth: 1)
                      )
                  
//                  Text("비밀번호 확인")
//                      .font(Font.custom("SuIT", size: 18))
//                      .foregroundColor(Color(red: 0.59, green: 0.8, blue: 0.7))
                  
                  SecureField("Confirm Password", text: $confirmPassword)
                      .padding(.horizontal, 10)
                      .padding(.vertical, 20.0)
                      .background(
                          RoundedRectangle(cornerRadius: 10)
                              .stroke(passwordsMatch ? Color(red: 0.59, green: 0.8, blue: 0.7) : Color.red, lineWidth: 1) // Red border if passwords don't match
                      )
                  
                  
                  
                  // Display password match message conditionally
                  if !confirmPassword.isEmpty {
                      Text(passwordsMatch ? "확인 완료" : "동일하지 않은 비밀번호입니다 :(")
                          .foregroundColor(passwordsMatch ? Color.green : Color.red)
                  }
                  
                  if shouldNavigate {
                                      // This will be an empty view if `shouldNavigate` is false
                                      NavigationLink(destination: HomeView(), isActive: $shouldNavigate) {
                                          EmptyView()
                                      }
                  }
                  GreenHorizontalButtonView(text: "회원가입", action: {
                      signupUser(email: email, username: nickname, password: password, checkedPassword: confirmPassword) { success in
                          if success {
                              DispatchQueue.main.async {
                                  shouldNavigate = true
                              }
                          } 
                      }
                  }, isEnabled: isFormComplete)
                  
              }
              .padding(.top, 20)
              .padding(.horizontal, 20)
          }
          .navigationTitle("회원가입")
      }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
