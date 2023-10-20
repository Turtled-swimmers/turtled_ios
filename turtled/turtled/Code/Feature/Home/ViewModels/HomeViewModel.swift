import Foundation

class HomeViewModel: ObservableObject {
    let userStorageManager = UserStorageManager.shared
    @Published var errorMessage: String? // 에러 메시지를 관찰 가능한 속성으로 추가

    // 알림 시작
    func StartNotify(
        startTime: Date,
        completion: @escaping (Bool) -> Void // completion 클로저 추가
    ) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // 원하는 형식에 따라 변경하세요
        
        // UserDefaults에서 deviceToken 가져오기
        guard let deviceToken = userStorageManager.deviceToken else {
            // deviceToken이 없을 경우에 대한 처리
            completion(false)
            return
        }
        
        print(deviceToken)

        let parameters: [String: Any] = [
            "device_token": deviceToken,
            "repeat_cycle": 0,
            "start_time": dateFormatter.string(from: startTime)
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            completion(false)
            return
        }

        APIManager.shared.postRequest(endpoint: "/timers/alarm", parameters: parameters) { data, error in
            DispatchQueue.main.async {
                if let data = data, let httpResponse = data as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 204:
                        completion(true)
                    case 400:
                        self.errorMessage = "Bad Request: The server couldn't understand the request."
                        completion(false)
                    default:
                        self.errorMessage = "Unknown error occurred. HTTP status code: \(httpResponse.statusCode)"
                        completion(false)
                    }
                } else {
                    self.errorMessage = "Unexpected error occurred."
                    completion(false)
                }
            }
        }
    }

    // 알림 보내기
    func sendNotify(
        completion: @escaping (Bool) -> Void // completion 클로저 추가
    ) {
        
        // UserDefaults에서 deviceToken 가져오기
        guard let deviceToken = userStorageManager.deviceToken else {
            // deviceToken이 없을 경우에 대한 처리
            completion(false)
            return
        }
        
        let parameters: [String: Any] = [
            "device_token": deviceToken,
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            completion(false)
            return
        }

        APIManager.shared.postRequest(endpoint: "/timers/message", parameters: parameters) { data, error in
            DispatchQueue.main.async {
                if let data = data, let httpResponse = data as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        completion(true)
                    case 204:
                        completion(true)
                    case 400:
                        self.errorMessage = "Bad Request: The server couldn't understand the request."
                        completion(false)
                    default:
                        self.errorMessage = "Unknown error occurred. HTTP status code: \(httpResponse.statusCode)"
                        completion(false)
                    }
                } else {
                    self.errorMessage = "Unexpected error occurred."
                    completion(false)
                }
            }
        }
    }
    
    
    
    // done
    func DoneNotify(
        endTime: Date,
        count: Int,
        completion: @escaping (Bool) -> Void // completion 클로저 추가
    ) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // 원하는 형식에 따라 변경하세요
        
        // UserDefaults에서 deviceToken 가져오기
        guard let deviceToken = userStorageManager.deviceToken else {
            // deviceToken이 없을 경우에 대한 처리
            completion(false)
            return
        }
        
        print(deviceToken)

        let parameters: [String: Any] = [
            "device_token": deviceToken,
            "count": count,
            "end_time": dateFormatter.string(from: endTime)
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            completion(false)
            return
        }

        APIManager.shared.postRequest(endpoint: "/timers/done", parameters: parameters) { data, error in
            DispatchQueue.main.async {
                if let data = data, let httpResponse = data as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 204:
                        completion(true)
                    case 400:
                        self.errorMessage = "Bad Request: The server couldn't understand the request."
                        completion(false)
                    default:
                        self.errorMessage = "Unknown error occurred. HTTP status code: \(httpResponse.statusCode)"
                        completion(false)
                    }
                } else {
                    self.errorMessage = "Unexpected error occurred."
                    completion(false)
                }
            }
        }
    }
}
