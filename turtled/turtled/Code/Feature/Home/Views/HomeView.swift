import SwiftUI

struct HomeView: View {
    
    /* ------------ STATE ------------ */
    @State private var timeInterval: Int = 10
    @State private var timer: Timer?
    @State private var cycles: Int = 0
    @State private var isTimerRunning = false
    @State private var showAlert = false
    @State private var progress: Double = 0.0
    @State private var secondsElapsed: Int = 0

    
    @State private var isTurtle1 = true  // 이미지를 전환하기 위한 새로운 @State 변수
    @State private var animationTimer: Timer?
    
    @State private var isAlertBellViewActive: Bool = false

    // 인용문
    @State private var quoteIndex: Int = Int.random(in: 0..<QuotesData.QuotesList.count)
    
    @State private var quoteChangeTimer: Timer?

    

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                if isTimerRunning {
                    Text(QuotesData.QuotesList[quoteIndex])
                        .font(Font.custom("SUIT", size: 18).weight(.bold))
                        .kerning(0.08)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .onAppear {
                            setupQuoteChangeTimer()
                        }
                        .onDisappear {
                            stopQuoteChangeTimer()
                        }
                    Text("\(timeInterval)분씩, \(cycles)번 하셨습니다!")
                        .font(Font.custom("SUIT", size: 18).weight(.bold))
                        .kerning(0.08)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.vertical,30)
                } else {
                    Text("몇 분 주기로 알림 받으실래요?")
                        .font(Font.custom("SUIT", size: 18).weight(.bold))
                        .kerning(0.08)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
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
                }
                

                
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
                    
                    if isTurtle1 {
                             Image("turtle")
                                 .resizable()
                                 .frame(width: 250, height: 250)
                         } else {
                             Image("turtle2")
                                 .resizable()
                                 .frame(width: 250, height: 200)
                         }
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
                .onDisappear {
                    stopAnimationTimer()
                }
                Spacer()
//MARK: - 스트레칭 시작 그만 Button
                Button(action: {
                    if isTimerRunning {
                            stopAnimationTimer()
                            timer?.invalidate()
                            secondsElapsed = 0  // Reset the seconds elapsed
                            progress = 0.0  // Reset the progress
                            showAlert = true
                        
                        let endBody: [String: Any] = [
                            "device_token": "DEVICE_TOKEN",
                            "end_time": "\(Date())", // or any appropriate format
                            "count": cycles
                        ]

                        makePOSTRequest(to: "http://ec2-15-164-95-242.ap-northeast-2.compute.amazonaws.com:8000/api/v1/timers/done", with: endBody) { success in
                            if success {
                                print("Timer stop data sent successfully!")
                            } else {
                                print("Failed to send timer stop data.")
                            }
                        }
                        
                        } else {
                            startAnimationTimer()
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
                    Alert(title: Text("Notification"), message: Text("\(timeInterval)분씩, \(cycles)번 하셨습니다!"),  dismissButton: .default(Text("확인")) {
                        cycles = 0
                    })
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
                }
                )
        }
    }
    
    func makePOSTRequest(to url: String, with body: [String: Any], completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: url) else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }

    
//MARK: - 시간 설정
    func timeString(from totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
//MARK: - 타이머 시작
    func startTimer() {
        
        let body: [String: Any] = [
            "device_token": "DEVICE_TOKEN",
            "repeat_cycle": 0,
            "start_time": "\(Date())"
        ]
        
        // 타이머 시작할때 보내기
        if(cycles == 0){
            makePOSTRequest(to:"http://ec2-15-164-95-242.ap-northeast-2.compute.amazonaws.com:8000/api/v1/timers/alarm", with: body) { success in
                if success {
                    print("Timer start data sent successfully!")
                } else {
                    print("Failed to send timer start data.")
                }
            }
        }

        
        
        timer?.invalidate()
        secondsElapsed = 0
        progress = 0.0
        startAnimationTimer()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            secondsElapsed += 1
            let totalSeconds = timeInterval * 60
            progress = Double(secondsElapsed) / Double(totalSeconds)

            if secondsElapsed >= totalSeconds {
                
                secondsElapsed = 0
                cycles += 1
                progress = 0.0
                
                let messageBody: [String: Any] = [
                    "message": "",
                    "notify": [
                        "title": "",
                        "body": ""
                    ],
                    "device_token": "DEVICE_TOKEN"
                ]

                makePOSTRequest(to: "http://ec2-15-164-95-242.ap-northeast-2.compute.amazonaws.com:8000/api/v1/timers/message", with: messageBody) { success in
                    if success {
                        print("Timer interval completion data sent successfully!")
                    } else {
                        print("Failed to send timer interval completion data.")
                    }
                }
                
            }
        }
    }
    
    //MARK: - 애니메이션 타이머
    // 에니메이션 시작 타이머
    func startAnimationTimer() {
        animationTimer?.invalidate()
        animationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            withAnimation(.linear(duration: 0.8)) {
                isTurtle1.toggle()
            }
        }
    }
    
    // 에니메이션 멈추기 타이머
    func stopAnimationTimer() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    //MARK: - 인용문 타이머
    // 인용 시작
    private func setupQuoteChangeTimer() {
         quoteChangeTimer?.invalidate()
         quoteChangeTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
             quoteIndex = Int.random(in: 0..<QuotesData.QuotesList.count)
         }
     }
    // 인용 종료 타이머
    private func stopQuoteChangeTimer() {
        quoteChangeTimer?.invalidate()
        quoteChangeTimer = nil
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


