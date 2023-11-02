import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var uViewModel: UserViewModel


//     UITabView 색상 초기화
    init() {
    UITabBar.appearance().backgroundColor = UIColor.white

    }

    
    private func updateUserViewModel() {
        // 여기서 UserStorageManager를 사용하여 저장된 유저 정보를 가져옵니다.
        if let nickname = UserStorageManager.shared.username, let email = UserStorageManager.shared.email {
            uViewModel.user.nickName = nickname
            uViewModel.user.email = email
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {

                HomeView()
                    .tabItem {
                        Image(selectedTab == 0 ? "home_fill" : "home")
                        Text("홈")
                            .foregroundColor(selectedTab == 0 ? Color(red: 0.59, green: 0.8, blue: 0.7) : Color(red: 0.44, green: 0.45, blue: 0.48))
                    }
                    .tag(0)
                    .onAppear {
                        if(UserStorageManager.shared.isLogin == true)
                        {
                            updateUserViewModel()
                        }
                    }


                MeasurementView()
                    .tabItem {
                        Image(selectedTab == 1 ? "film_fill" : "film")
                        Text("측정하기")
                            .foregroundColor(selectedTab == 2 ? Color(red: 0.59, green: 0.8, blue: 0.7) : Color(red: 0.44, green: 0.45, blue: 0.48))
                    }.tag(1)
            DalsungView()
                .tabItem {
                    Image(selectedTab == 2 ? "dalsung_fill" : "dalsung")
                    Text("달성")
                        .foregroundColor(selectedTab == 1 ? Color(red: 0.59, green: 0.8, blue: 0.7) : Color(red: 0.44, green: 0.45, blue: 0.48))
                }.tag(2)
                ProfileView()
                    .tabItem {
                        Image(selectedTab == 3 ? "profile_fill" : "profile")
                        Text("프로필")
                            .foregroundColor(selectedTab == 3 ? Color(red: 0.59, green: 0.8, blue: 0.7) : Color(red: 0.44, green: 0.45, blue: 0.48))
                    }.tag(3)
            
            }
        .environmentObject(uViewModel)
        }
}

struct ContentView_Previews: PreviewProvider {
    
    static var uViewModel = UserViewModel.shared
    static var previews: some View {
        ContentView()
            .environmentObject(uViewModel)
    }
}

