import SwiftUI

struct ProfileView: View {
    @State private var isLoggedOut = false
    
    var body: some View {
        NavigationView{
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading){
                    // 메일
                    Text("email@naver.com")
                        .font(
                            Font.custom("SUIT", size: 20)
                                .weight(.bold)
                        )
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding(.bottom,30)
                    
                    // 알림 허용, NavigationLink, AlertSettingView로 이동
                    NavigationLink(destination: AlertSettingView()) {
                        Text("알림 설정")
                            .font(.system(size: 18))
                            .foregroundColor(Color.black)
                    }
                    Divider()
                        .padding(.vertical, 10)
                    
                    // 버전 정보, 0.0.1 표시
                    VStack(alignment: .leading, spacing: 5){
                        Text("버전 정보")
                            .font(.system(size: 18))
                        // Body/Body S
                        Text("0.0.1")
                            .font(Font.custom("SUIT", size: 12))
                            .kerning(0.12)
                            .foregroundColor(Color(red: 0.44, green: 0.45, blue: 0.48))
                    }
                    Divider()
                        .padding(.vertical, 10)
                    
                    // 문의 하기, turtled@gmail.com 적혀있음
                    VStack(alignment: .leading, spacing: 5){
                        Text("문의 하기")
                            .font(.system(size: 18))
                        // Body/Body S
                        Text("turtled@gmail.com")
                            .font(Font.custom("SUIT", size: 12))
                            .kerning(0.12)
                            .foregroundColor(Color(red: 0.44, green: 0.45, blue: 0.48))
                        
                    }
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    // 로그아웃 버튼, 누르면 로그아웃 처리하고 HomeView로 이동
                    Button(action: {
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
                .padding(.top,20)
                .padding(.horizontal,32)
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
