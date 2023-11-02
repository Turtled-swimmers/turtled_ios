import Foundation

class APIManager {
    static let shared = APIManager()
    let baseURL = "https://turtled-back.dcs-seochan99.com/api/v1"
    
    // 폼 POST 요청 -> 회원가입
    func formPostRequest(endpoint: String, requestBody: String, headers: [String: String], completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(nil, NSError(domain: "APIManagerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL."]))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set headers from the passed headers dictionary
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        request.httpBody = requestBody.data(using: .utf8)
        
        // URLSession data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, NSError(domain: "APIManagerError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Networking error: \(error.localizedDescription)"]))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    completion(nil, NSError(domain: "APIManagerError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server returned status code: \(httpResponse.statusCode)"]))
                    return
                }
                
                completion(data, nil)
            }
        }
        task.resume()
    }
    
    // 폼 POST 요청 -> 회원가입
    func videoPostRequest(endpoint: String, requestBody: String, headers: [String: String], completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(nil, NSError(domain: "APIManagerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL."]))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set headers from the passed headers dictionary
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        request.httpBody = requestBody.data(using: .utf8)
        
        // URLSession data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, NSError(domain: "APIManagerError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Networking error: \(error.localizedDescription)"]))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    completion(nil, NSError(domain: "APIManagerError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server returned status code: \(httpResponse.statusCode)"]))
                    return
                }
                
                completion(data, nil)
            }
        }
        task.resume()
    }
    
    
    
    


    // 포스트 요청 -> 로그인
    func postRequest(endpoint: String, parameters: [String: Any], completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            let urlError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL."])
            print("URL error: \(urlError.localizedDescription)")
            completion(nil, urlError)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            print(request.httpBody)
        } catch {
            print("JSON Serialization error: \(error.localizedDescription)")
            completion(nil, error)
            return
        }
        
        print("http통신 성공")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error.localizedDescription)")
            }
            
            completion(data, error)
            print("completion 진행")
            print(data)
            
        }.resume()
    }

    // GET
    func getRequest(endpoint: String, headers: [String: String], completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL."]))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, error)
        }.resume()
    }

}
