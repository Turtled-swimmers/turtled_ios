import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Your content here
            }
            
            .navigationBarItems(
                leading: Text("Turtled")
                    .font(.largeTitle) // Apply a custom font size (you can adjust this as needed)
                    .fontWeight(.bold)
                    .padding(.top, 90.0),
                
                trailing:
                    Button(action: {
                        // Action for the right-side button (e.g., for showing a notification)
                    }) {
                        Image("Combined-Shape")
                            .resizable()
                            .frame(width: 20, height: 23)
                            .padding(.top, 90.0)
                    }
            )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
