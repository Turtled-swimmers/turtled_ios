import SwiftUI

struct HomeView: View {
    @State private var timeInterval: Int = 10
    @State private var timer: Timer?
    @State private var cycles: Int = 0
    @State private var isTimerRunning = false
    @State private var showAlert = false
    @State private var progress: Double = 0.0
    @State private var secondsElapsed: Int = 0

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                /*  ---------------- title  ---------------- */
                Text("몇 분 주기로 알림 받으실래요?")
                    .font(
                        Font.custom("SUIT", size: 18)
                            .weight(.bold)
                    )
                    .kerning(0.08)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .frame(width: 343, height: 22, alignment: .top)
                /*  ---------------- setting time  ---------------- */
                HStack {
                    Button(action: {
                        if !isTimerRunning {
                            timeInterval = max(timeInterval - 1, 1)
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                    .disabled(isTimerRunning)
                    Text("\(timeInterval):00")
                        .font(
                        Font.custom("SUIT", size: 20)
                        .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.59, green: 0.8, blue: 0.7))
                        .padding(.horizontal, 25.0)
                        .padding(.vertical, 10.0)
                        .background(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .inset(by: 1.5)
                                .stroke(Color(red: 0.59, green: 0.8, blue: 0.7), lineWidth: 3)
                        )
                    
                    
                    Button(action: {
                        if !isTimerRunning {
                            timeInterval = min(timeInterval + 1, 30)
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                    .disabled(isTimerRunning)

                }.padding(.vertical,20)
                
                /*  ---------------- Circle  ---------------- */
//                Text("Alert cycles: \(cycles)")
                
//MARK: - Circle
                ZStack{
                    
                    Circle()
                        .stroke(Color.gray.opacity(0.5), lineWidth: 5)
                        .padding(.horizontal,40)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(progress))
                        .stroke(Color(red: 0.59, green: 0.8, blue: 0.7), lineWidth: 5)
                        .rotationEffect(.degrees(-90))
                        .padding(.horizontal,40)
                    Image("turtle")
                        .resizable()
                        .frame(width: 250, height: 250)
                    // timer
                    Text(timeString(from: secondsElapsed))
                        .font(
                        Font.custom("SUIT", size: 20)
                        .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.horizontal, 25.0)
                        .padding(.vertical, 10.0)
                        .background(Color(red: 0.59, green: 0.8, blue: 0.7))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .inset(by: 1.5)
                                .stroke(Color(.white), lineWidth: 3)
                        )
                        .padding(.bottom, 270) // 여기에 톱 패딩을 추가하여 텍스트를 상단으로 더 올립니다.

                }
                Spacer()
                
                
                
//MARK: - Button
                Button(action: {
                    if isTimerRunning {
                            timer?.invalidate()
                            secondsElapsed = 0  // Reset the seconds elapsed
                            progress = 0.0  // Reset the progress
                            showAlert = true
                        } else {
                            startTimer()
                        }
                        
                        isTimerRunning.toggle()
                }) {
                    Text(isTimerRunning ? "스트레칭 그만하기" : "스트레칭 시작하기")
                        .font(Font.custom("SUIT", size: 20).weight(.semibold))
                        .padding(.vertical, 12.0)
                        .frame(maxWidth: .infinity)  // Fill the horizontal direction
                        .foregroundColor(isTimerRunning ? Color(red: 0.59, green: 0.8, blue: 0.7) : Color.white)
                        .background(
                            isTimerRunning ? Color.white : Color(red: 0.59, green: 0.8, blue: 0.7)
                        )
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(red: 0.59, green: 0.8, blue: 0.7), lineWidth: isTimerRunning ? 1.5 : 0)
                        )
                }
                .padding(.horizontal, 20)  // Add 20 margin on both
                .padding(.bottom,50)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Notification"), message: Text("You stretched \(cycles) times!"), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarItems(
                leading: HStack(spacing: 0) {
                    Text("T")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.59, green: 0.8, blue: 0.7))
                        .padding(.top, 90.0)
                    
                    Text("urtled")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 90.0)
                },

                
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
    
//MARK: - 시간 설정
    func timeString(from totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
//MARK: - 타이머 시작
    func startTimer() {
        timer?.invalidate()
        secondsElapsed = 0
        progress = 0.0

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            secondsElapsed += 1
            let totalSeconds = timeInterval * 60
            progress = Double(secondsElapsed) / Double(totalSeconds)

            if secondsElapsed >= totalSeconds {
                secondsElapsed = 0
                cycles += 1
                progress = 0.0
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


