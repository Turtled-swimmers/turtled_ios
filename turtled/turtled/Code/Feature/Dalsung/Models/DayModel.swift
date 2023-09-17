import SwiftUI

//MARK: - Day Model
struct DayModel: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let isDone: Bool
    
    // 일자로 변경
    var dayText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    // 한국어 요일 변환
    var weekdayText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일 설정
        return formatter.string(from: date)
    }
}

extension DayModel {
    init(currentDate: Date, isDone: Bool = false) {
        self.date = currentDate
        self.isDone = isDone
    }
}
