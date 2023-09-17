import SwiftUI

struct AlertSettingView: View {
    @State private var isToolbarHidden = true

    @State private var AlertOn: Bool = UserDefaults.standard.bool(forKey: "ateAlert")
    
    var body: some View {
        VStack{
            alertToggle(title: "알림 설정", subtitle: "등록한 주기별 알림", isOn: $AlertOn, key: "ateAlert")
            Spacer()
        }.padding(.horizontal,32)
//            .toolbar(.hidden, for: .tabBar)
        
    }
    
    // 알림토글
    func alertToggle(title: String, subtitle: String, isOn: Binding<Bool>, key: String) -> some View {
        Toggle(isOn: isOn) {
            VStack(alignment: .leading) {
                Text(title)
                    .font(Font.custom("SUIT", size: 16).weight(.medium))
                    .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.08))
                
                Text(subtitle)
                    .font(Font.custom("SUIT", size: 14).weight(.medium))
                    .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.62))
            }
        }
        .tint(Color(red: 0.59, green: 0.8, blue: 0.7))
        .onChange(of: isOn.wrappedValue) { newValue in
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertSettingView()
    }
}
