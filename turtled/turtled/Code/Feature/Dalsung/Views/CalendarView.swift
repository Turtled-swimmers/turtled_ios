import SwiftUI

//MARK: - CalendarView : 달력 뷰
struct CalendarView: View {
    
    let stretchingSessions: [StretchingSessionModel] = [
        StretchingSessionModel(sessionNumber: 1, startTime: "10:00", endTime: "11:00", timerInterval: "15분", stretchingCount: 5),
        StretchingSessionModel(sessionNumber: 2, startTime: "11:30", endTime: "12:30", timerInterval: "20분", stretchingCount: 4),
        StretchingSessionModel(sessionNumber: 3, startTime: "14:00", endTime: "15:00", timerInterval: "10분", stretchingCount: 6),
        StretchingSessionModel(sessionNumber: 4, startTime: "16:00", endTime: "17:00", timerInterval: "15분", stretchingCount: 5),
        StretchingSessionModel(sessionNumber: 5, startTime: "18:00", endTime: "19:00", timerInterval: "20분", stretchingCount: 3)
    ]
    
    /* --------------- State --------------- */
    //currentDate 현재 일자를 불러온다.
    @State private var currentDate = Date()
    //isExpanded 확장 여부
    @State private var isExpanded = false
    // currentWeekIndex 현재 주
    @State private var currentWeekIndex: Int = 0
    // 선택한 날짜를 저장할 상태 변수 추가
    @State private var selectedDate: DayModel? = DayModel(currentDate: Date())
    /* --------------- dateFormatter 년 월 포멧  --------------- */
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        return formatter
    }
     
    /* --------------- 현재 주 찾기 --------------- */
    func findCurrentWeekIndex() -> Int {
        let today = Date()
        for (index, week) in sampleWeekDates.enumerated() {
            for day in week {
                if Calendar.current.isDate(day.date, inSameDayAs: today) {
                    return index // 오늘 날짜가 있는 주의 인덱스를 반환
                }
            }
        }
        return 0
    }
    /* --------------- 한줄 캘린더 데이터--------------- */
    var sampleWeekDates: [[DayModel]] {
        var allWeekDates: [[DayModel]] = []
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        
        // 시작하는 달 가져오기
        guard let startOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .weekOfMonth, in: .month, for: startOfMonth) else {
            return allWeekDates // // 시작 달의 데이터를 가져올 수 없는 경우 빈 배열을 반환
        }
        if let firstWeekday = calendar.dateComponents([.weekday], from: startOfMonth).weekday {
            var currentDay = startOfMonth
            
            for _ in range {
                var weekDates: [DayModel] = []
                for dayIndex in 0..<7 {
                    // 달의 첫 번째 날을 지나거나 첫 번째 주가 아닌 경우
                    if dayIndex >= firstWeekday - 1 || allWeekDates.count > 0 {
                        let dayModel = DayModel(date: currentDay, isDone: true)
                        weekDates.append(dayModel)
                        currentDay = calendar.date(byAdding: .day, value: 1, to: currentDay)!
                    }
                    // 그외
                    else {
                        weekDates.append(DayModel(date: Date(timeIntervalSince1970: 0), isDone: true)) // Empty day
                    }
                }
                // 해당 주 allWeekData에 붙이기
                allWeekDates.append(weekDates)
            }
        }
        // 모든 주의 데이터
        return allWeekDates
    }
    
    /* --------------- 토,일 색상 ---------------*/
    func weekdayColor(for weekdayText: String) -> Color {
        switch weekdayText {
            case "일":
                return Color(red: 0.88, green: 0.06, blue: 0.16) // 일요일 색상
            case "토":
                return Color(red: 0.33, green: 0.53, blue: 0.99) // 토요일 색상
            default:
                return Color.black // 기본 색상
        }
    }
    
//MARK: - View Body
    var body: some View {
            
        /* --------------- 달력 뷰 --------------- */
        VStack(spacing: 16) {
            /* --------------- 달 이동 View --------------- */
            CalendarHeaderChangeMonthSwiftUIView(currentDate: $currentDate)
        
            /* --------------- 요일 불러오는 Header View --------------- */
            WeekdayHeaderSwiftUIView()
            
            /* --------------- 펼쳐졌을 경우의 View, 달 전체를 보여줌 --------------- */
            if isExpanded {
                ForEach(sampleWeekDates, id: \.self) {
                    weekDates in
                    CalendarWeekSwiftUIView(weekDates: weekDates, selectedDate: $selectedDate) // 선택한 날짜를 하위 뷰에 전달
                }
            } else {
                // 해당 주차
                CalendarWeekSwiftUIView(weekDates: sampleWeekDates[currentWeekIndex], selectedDate: $selectedDate) // 선택한 날짜를 하위 뷰에 전달
            }
            /* --------------- 스와이핑 아이콘 --------------- */
            VStack {
                Button(action: {
                    withAnimation {
                        self.isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .colorMultiply(Color(red: 0.56, green: 0.56, blue: 0.62, opacity: 1))
                }
            }
            .padding(.top, 20)
            
            ScrollView(showsIndicators: false) {
                // 선택한 날짜
                CalendarTodoHeaderSwiftUIView(selectedDate: $selectedDate)
                
                ForEach(stretchingSessions, id: \.sessionNumber) { session in
                    
                        HStack{
                            VStack(alignment: .leading,spacing: 10) {
                                Text("#\(session.sessionNumber) ")
                                    .font(Font.custom("SUIT", size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.12, green: 0.13, blue: 0.14))

                                Text("시작 시간: \(session.startTime)")
                                    .font(Font.custom("SUIT", size: 14))
                                    .foregroundColor(Color(red: 0.44, green: 0.45, blue: 0.48))


                                Text("종료 시간: \(session.endTime)")
                                    .font(Font.custom("SUIT", size: 14))
                                    .foregroundColor(Color(red: 0.44, green: 0.45, blue: 0.48))


                                Text("타이머 주기: \(session.timerInterval)")
                                    .font(Font.custom("SUIT", size: 14))
                                    .foregroundColor(Color(red: 0.44, green: 0.45, blue: 0.48))


                                Text("스트레칭 횟수: \(session.stretchingCount) 번")
                                    .font(Font.custom("SUIT", size: 14))
                                    .foregroundColor(Color(red: 0.44, green: 0.45, blue: 0.48))


                            }.padding(.horizontal,10)
                            Spacer()
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.97, green: 0.98, blue: 1))
                    .cornerRadius(8)
                    .padding(.bottom, 10)
                }
            }
            .padding(.top, 10)
            .padding(.horizontal,30)
        }.onAppear {
            currentWeekIndex = findCurrentWeekIndex()
        }
        .navigationTitle("달성")
    }
}

//MARK: -CalendarView_Previews
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
