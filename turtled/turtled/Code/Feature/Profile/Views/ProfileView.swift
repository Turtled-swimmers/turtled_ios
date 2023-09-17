import SwiftUI

struct ProfileView: View {
    @ObservedObject private var user = User.shared
    @State private var isLoggedOut = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text(user.isLoggedIn ? user.email : "로그인 하러 가기")
                        .font(
                            Font.custom("SUIT", size: 20)
                                .weight(.bold)
                        )
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding(.bottom, 30)
                        .onTapGesture {
                            if !user.isLoggedIn {
                                // Navigate to the LoginView when tapped
                                isLoggedOut = true
                            }
                        }
                    
                    NavigationLink(destination: AlertSettingView()) {
                        Text("알림 설정")
                            .font(.system(size: 18))
                            .foregroundColor(Color.black)
                    }
                    Divider()
                        .padding(.vertical, 10)
                    
                    // ... (other sections)

                    Button(action: {
                        // Log out the user
                        user.isLoggedIn = false
                        UserDefaults.standard.set(false, forKey: "isLogin")
                        isLoggedOut = true
                    }) {
                        Text("로그아웃")
                            .font(.system(size: 18))
                            .foregroundColor(.red)
                    }
                    .fullScreenCover(isPresented: $isLoggedOut, content: {
                        HomeView()
                    })
                    
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.horizontal, 32)
                .accentColor(Color(red: 0.12, green: 0.13, blue: 0.14))
            }
            .navigationTitle("프로필")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
