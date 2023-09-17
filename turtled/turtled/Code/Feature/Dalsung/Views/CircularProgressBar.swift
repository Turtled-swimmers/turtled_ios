import SwiftUI

//MARK: - 원 프로그레스바 : 달력 일자 위에
struct CircularProgressBar: View {
    var progress: Double
    var dateText: String
    var today : Bool
    var weekDates : String
    var isSelected: Bool = false // 선택된 날짜인지 나타내는 변수 추가
    var isDone: Bool = true


    var body: some View {
        ZStack {
               if dateText != "  " {
                   if isSelected {
                       Circle()
                           .fill(Color(red: 0.59, green: 0.8, blue: 0.7))
                           .frame(width: 34, height: 34)
                           .overlay(
                               Text("\(dateText)")
                                   .font(Font.custom("SUIT", size: 12).weight(.medium))
                                   .foregroundColor(Color.white)
                           )
                   } else {
                       if isDone{
                           VStack(spacing: 3){
                               Text(dateText)
                                   .foregroundColor(weekdayColor(for: weekDates))
                                   .font(Font.custom("SUIT", size: 12).weight(.bold))
                               Circle()
                                   .fill(Color(red: 0.59, green: 0.8, blue: 0.7))
                                   .frame(width: 8, height: 8)
                           }
                       }else{
                           Text(dateText)
                               .foregroundColor(weekdayColor(for: weekDates))
                               .font(Font.custom("SUIT", size: 12).weight(.bold))
                       }
                   }
               }
           }
           .frame(width: 32, height: 32)
    }
    
    // --------------- 토,일 색상 ---------------
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
}

struct CircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircularProgressBar(progress: 0.5, dateText: "15", today: true, weekDates: "금", isSelected: true)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Selected Date")

            CircularProgressBar(progress: 0.7, dateText: "16", today: false, weekDates: "토", isSelected: false)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Unselected Date")

            CircularProgressBar(progress: 0.3, dateText: "17", today: false, weekDates: "일", isSelected: false)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Sunday Date")
        }
    }
}
