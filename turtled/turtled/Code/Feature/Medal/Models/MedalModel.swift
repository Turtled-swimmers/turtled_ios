import SwiftUI

struct Medal: Identifiable {
    var id = UUID()
    var image: String
    var title: String
    var content1: String
    var content2: String
    var requirement: String
    var isAchieved: Bool
}
