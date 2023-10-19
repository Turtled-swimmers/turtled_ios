import SwiftUI
import Foundation

// 포스트 요청
func signupUser(email: String, username: String, password: String, checkedPassword: String, bodyData: Data, completion: @escaping (Bool) -> Void) {
    print("호출")
    let url = URL(string: "https://turtled-back.dcs-seochan99.com/api/v1/users/signup")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = bodyData
    
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
    
    
    @Environment(\.presentationMode) var presentationMode // presentationMode 추가

    
    
    // 체커
    private var isFormComplete: Bool {
         !email.isEmpty && !nickname.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && passwordsMatch
     }
     
    
    
    // 패스워드 매칭 여부
    private var passwordsMatch: Bool {
          password == confirmPassword
      }
      
    
    var body: some View {

              VStack(alignment: .leading, spacing: 10) {
                  
                  Text("이메일")
                      .foregroundColor(Color("main"))
                  
                  TextField("이메일을 입력해주세요.", text: $email)
                      .padding(.horizontal, 10)
                      .padding(.vertical, 20.0)
                      .background(
                          RoundedRectangle(cornerRadius: 10)
                              .stroke(Color(red: 0.59, green: 0.8, blue: 0.7), lineWidth: 1)
                      )
                  Group{
                      Text("닉네임")
                          .foregroundColor(Color("main"))
                      
                      TextField("닉네임을 입력해주세요.", text: $nickname)
                          .padding(.horizontal, 10)
                          .padding(.vertical, 20.0)
                          .background(
                              RoundedRectangle(cornerRadius: 10)
                                  .stroke(Color(red: 0.59, green: 0.8, blue: 0.7), lineWidth: 1)
                          )
                  }
                  
                  
                  
                  SecureField("Password", text: $password)
                      .padding(.horizontal, 10)
                      .padding(.vertical, 20.0)
                      .background(
                          RoundedRectangle(cornerRadius: 10)
                              .stroke(Color(red: 0.59, green: 0.8, blue: 0.7), lineWidth: 1)
                      )
                
                  
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
                  
                  GreenHorizontalButtonView(text: "회원가입", action: {
                  
                      let bodyData: [String: Any] = [
                                  "username": nickname,
                                  "email": email,
                                  "password": password,
                                  "checked_password": confirmPassword
                              ]

                              if let jsonData = try? JSONSerialization.data(withJSONObject: bodyData) {
                                  signupUser(email: email, username: nickname, password: password, checkedPassword: confirmPassword, bodyData: jsonData) { success in
                                      if success {
                                          // 회원가입에 성공하면 현재 뷰를 pop하여 이전 화면으로 돌아감
                                          presentationMode.wrappedValue.dismiss()
                                      }
                                  }
                              } else {
                                  print("JSON 데이터 생성 실패")
                              }
                          
                  }, isEnabled: isFormComplete)
                  
              }
              .padding(.horizontal, 20)
              .navigationTitle("회원가입")
              .toolbar(.hidden, for: .tabBar)



          
      }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
