import SwiftUI

struct GreenHorizontalButtonView: View {
    var text: String
        var action: () -> Void
    var isEnabled: Bool = true
    var body: some View {
        Button(action: action) {
            Text(text)
               .font(Font.custom("SUIT", size: 20).weight(.semibold))
               .frame(maxWidth: .infinity)  // Fill the horizontal direction
               .foregroundColor(isEnabled ? Color.white : Color(red: 0.78, green: 0.78, blue: 0.81))
               .frame(height: 56)
               .background(isEnabled ? Color(red: 0.59, green: 0.8, blue: 0.7) : Color(UIColor(red: 0.91, green: 0.91, blue: 0.93, alpha: 1)))
               .cornerRadius(8)
        }
        .disabled(!isEnabled)
    }
}

struct GreenHorizontalButtonView_Previews: PreviewProvider {
    static var previews: some View {
        GreenHorizontalButtonView(text:"완료",action: {},isEnabled:false)
    }
}

