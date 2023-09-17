import SwiftUI

struct HomeView: View {
    @State private var timeInterval: Int = 10
    @State private var timer: Timer?
    @State private var cycles: Int = 0
    @State private var isTimerRunning = false
    @State private var showAlert = false
    @State private var progress: Double = 0.0
    
    var body: some View {
        NavigationView {
            VStack {
                
                /*  ---------------- title  ---------------- */
                Text("몇 분 주기로 알림 받으실래요?")
                    .font(
                        Font.custom("SUIT", size: 16)
                            .weight(.bold)
                    )
                    .kerning(0.08)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .frame(width: 343, height: 22, alignment: .top)
                /*  ---------------- setting time  ---------------- */
                HStack {
                    Text("\(timeInterval):00")
                        .font(
                        Font.custom("SUIT", size: 20)
                        .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.59, green: 0.8, blue: 0.7))
                        .frame(width: 103, height: 44.14286)
                        .background(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .inset(by: 1.5)
                                .stroke(Color(red: 0.59, green: 0.8, blue: 0.7), lineWidth: 3)
                        )
                    
                    VStack {
                        Button(action: {
                            if !isTimerRunning {
                                timeInterval = min(timeInterval + 1, 30)
                            }
                        }) {
                            Image(systemName: "arrowtriangle.up.fill")
                        }
                        .disabled(isTimerRunning)
                        
                        Button(action: {
                            if !isTimerRunning {
                                timeInterval = max(timeInterval - 1, 5)
                            }
                        }) {
                            Image(systemName: "arrowtriangle.down.fill")
                        }
                        .disabled(isTimerRunning)
                    }
                }
                
                /*  ---------------- Circle  ---------------- */
                Text("Alert cycles: \(cycles)")
                
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.5), lineWidth: 10)
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(progress))
                        .stroke(Color.green, lineWidth: 10)
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-90))
                    
                    // Your image here, replace "imageName" with your actual image name
                    Image("turtle")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                
                Button(action: {
                    if isTimerRunning {
                        timer?.invalidate()
                        showAlert = true
                    } else {
                        startTimer()
                    }
                    
                    isTimerRunning.toggle()
                }) {
                    Text(isTimerRunning ? "End" : "Start")
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Notification"), message: Text("You stretched \(cycles) times!"), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarItems(
                leading: Text("Turtled")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 90.0),
                
                trailing:
                    Button(action: {
                        // Action for the right-side button
                    }) {
                        Image("Combined-Shape")
                            .resizable()
                            .frame(width: 20, height: 23)
                            .padding(.top, 90.0)
                    }
            )
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeInterval * 60), repeats: true) { timer in
            cycles += 1
            progress = (progress + 1.0 / Double(timeInterval)) .truncatingRemainder(dividingBy: 1.0)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
