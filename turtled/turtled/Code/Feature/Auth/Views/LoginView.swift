import SwiftUI

struct LoginView: View {
    
    @State private var isLogin: Bool = UserDefaults.standard.bool(forKey: "isLogin")
    @State private var showMyPageView: Bool = false
    @State private var isEmailEditing: Bool = false
    @State private var isPasswordEditing: Bool = false
    
    @State private var email = ""
    @State private var password = ""
    
    @ObservedObject private var userViewModel = UserViewModel.shared // 뷰모델 불러오기
    @Environment(\.presentationMode) var presentationMode // presentationMode 추가
    
    
    private var isFormComplete: Bool {
            !email.isEmpty && !password.isEmpty
        }
    
    var body: some View {
            VStack(alignment: .leading,spacing: 10){
                Text("이메일")
                  .font(Font.custom("SUIT", size: 18))
                  .foregroundColor(Color(red: 0.59, green: 0.8, blue: 0.7))

                TextField("이메일을 입력해주세요.", text: $email)
                    .padding(.horizontal,10)
                    .padding(.vertical, 20.0)
                                    .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                    .inset(by: 0.5)
                                    .stroke(Color(red: 0.59, green: 0.8, blue: 0.7), lineWidth: 1)
                                    )
                
                Text("비밀번호")
                  .font(Font.custom("SUIT", size: 18))
                  .foregroundColor(Color(red: 0.59, green: 0.8, blue: 0.7))
                SecureField("Password", text: $password)
                    .padding(.horizontal,10)
                    .padding(.vertical, 20.0)
                                    .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                    .inset(by: 0.5)
                                    .stroke(Color(red: 0.59, green: 0.8, blue: 0.7), lineWidth: 1)
                                    )
                
                VStack(){
                    HStack(alignment: .center){
                        Button(action: {
                            // 비밀번호 찾기 WebView를 열기
                        }) {
                            Text("비밀번호 찾기")
                                .foregroundColor(Color(red: 0.77, green: 0.78, blue: 0.8))
                        }
                        NavigationLink(destination: SignUpView()) {
                            Text("회원가입")
                                .foregroundColor(Color(red: 0.77, green: 0.78, blue: 0.8))
                        }

                    }.padding(.top, 10)
                }
                        Spacer()
                GreenHorizontalButtonView(text: "로그인", action: {
                    userViewModel.login(email: email, password: password){ success in
                        DispatchQueue.main.async {
//                            isLoading = false // Stop loading
                            
                            if success {
                                // 로그인에 성공하면 현재 뷰를 pop하여 이전 화면으로 돌아감
                                presentationMode.wrappedValue.dismiss()
                            } else  {
                                // Handle the error
                                print("Registration failed")
                            }
                        }
                    }
                    
                    
                    
                }, isEnabled: isFormComplete)

            }.padding(.top,20)
            .navigationTitle("Login")
            .padding(.horizontal,20)
//            .toolbar(.hidden, for: .tabBar)
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
