import Foundation
import SwiftUI

class User: ObservableObject  {
    static let shared = User()

    // 닉네임
    @Published var nickName: String = ""
    // 닉네임
    @Published var email: String = ""
    
    public init() {}

}
