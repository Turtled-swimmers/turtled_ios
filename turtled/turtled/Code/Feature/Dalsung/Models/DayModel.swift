import SwiftUI

//MARK: - Day Model
struct DayModel: Identifiable, Hashable{ // Equatable 추가
    let id = UUID()
    let date: Date
    let isDone: Bool
    var sessions: [StretchingSessionModel] = []

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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(date)
    }
}


extension DayModel {
    init(currentDate: Date, isDone: Bool = false) {
        self.date = currentDate
        self.isDone = isDone
    }
}
