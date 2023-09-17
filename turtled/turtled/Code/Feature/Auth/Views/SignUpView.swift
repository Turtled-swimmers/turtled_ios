import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var nickname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @State private var passwordsMatch = true // Check if passwords match
    
    private var isFormComplete: Bool {
        !email.isEmpty && !nickname.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && passwordsMatch
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
                
                Text("비밀번호")
                    .font(Font.custom("SuIT", size: 18))
                    .foregroundColor(Color(red: 0.59, green: 0.8, blue: 0.7))
                
                SecureField("Password", text: $password)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 20.0)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(red: 0.59, green: 0.8, blue: 0.7), lineWidth: 1)
                    )
                
                Text("비밀번호 확인")
                    .font(Font.custom("SuIT", size: 18))
                    .foregroundColor(Color(red: 0.59, green: 0.8, blue: 0.7))
                
                TextField("Confirm Password", text: $confirmPassword)
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
                
                Spacer()
                
//                GreenHorizontalButtonView(text: "회원가입", action: {}, isEnabled: isFormComplete)
//                GreenHorizontalButtonView(text: "a", action: {})


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
