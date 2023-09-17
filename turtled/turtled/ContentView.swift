import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(selectedTab == 0 ? "home_fill" : "home")
                    Text("홈")
                        .foregroundColor(selectedTab == 0 ? Color(red: 0.59, green: 0.8, blue: 0.7) : Color(red: 0.44, green: 0.45, blue: 0.48))
                }.tag(0)
            DalsungView()
                .tabItem {
                    Image(selectedTab == 1 ? "dalsung_fill" : "dalsung")
                    Text("달성")
                        .foregroundColor(selectedTab == 1 ? Color(red: 0.59, green: 0.8, blue: 0.7) : Color(red: 0.44, green: 0.45, blue: 0.48))
                }.tag(1)
            MedalView()
                .tabItem {
                    Image(selectedTab == 2 ? "medal_fill" : "medal")
                    Text("메달")
                        .foregroundColor(selectedTab == 2 ? Color(red: 0.59, green: 0.8, blue: 0.7) : Color(red: 0.44, green: 0.45, blue: 0.48))
                }.tag(2)
            ProfileView()
                .tabItem {
                    Image(selectedTab == 3 ? "profile_fill" : "profile")
                    Text("프로필")
                        .foregroundColor(selectedTab == 3 ? Color(red: 0.59, green: 0.8, blue: 0.7) : Color(red: 0.44, green: 0.45, blue: 0.48))
                }.tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
