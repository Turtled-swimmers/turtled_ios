import SwiftUI
import Foundation

struct SignUpView: View {
    @State private var email = ""
    @State private var nickname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var shouldNavigate = false
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    
    @ObservedObject private var userViewModel = UserViewModel.shared // 뷰모델 불러오기
    
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
                  if isLoading {
                       Spacer() // Adds space above the loader
                       ProgressView() // This is the activity indicator in SwiftUI
                           .scaleEffect(1.5, anchor: .center)
                           .progressViewStyle(CircularProgressViewStyle(tint: Color("main")))
                       Spacer() // Adds space below the loader
                   }
                  Text("이메일")
                      .foregroundColor(Color("main"))
                  
                  TextField("이메일을 입력해주세요.", text: $email)
                      .padding(.horizontal, 10)
                      .padding(.vertical, 20.0)
                      .background(
                          RoundedRectangle(cornerRadius: 10)
                              .stroke(Color("main"))
                      )
                  Group{
                      Text("닉네임")
                          .foregroundColor(Color("main"))
                      
                      TextField("닉네임을 입력해주세요.", text: $nickname)
                          .padding(.horizontal, 10)
                          .padding(.vertical, 20.0)
                          .background(
                              RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("main"))
                          )
                  }
                  
                  
                  
                  SecureField("Password", text: $password)
                      .padding(.horizontal, 10)
                      .padding(.vertical, 20.0)
                      .background(
                          RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("main"))
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
                  // chfhr qjxms
                  GreenHorizontalButtonView(text: "회원가입", action: {
                      userViewModel.signupUser(email: email, username: nickname, password: password, checkedPassword: confirmPassword) { success in
                          DispatchQueue.main.async {
                              isLoading = false // Stop loading
                              
                              if success {
                                  self.alertMessage = "회원가입완료!"
                                   self.showAlert = true
                                   // Optionally delay the dismissal to let the user read the message
                                  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                      self.presentationMode.wrappedValue.dismiss()
                                  }
                              } else  {
                                  print("Registration failed")
                              }
                          }
                      }
                  }, isEnabled: isFormComplete)
                  .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("알림"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("확인"))
                        )
                    }


                  
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
