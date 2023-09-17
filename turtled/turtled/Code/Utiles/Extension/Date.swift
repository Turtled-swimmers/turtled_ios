import Foundation
//MARK: - Date Extension
extension Date {
    var day: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var SingleDay: Int {
        return Calendar.current.component(.day, from: self)
    }
}
