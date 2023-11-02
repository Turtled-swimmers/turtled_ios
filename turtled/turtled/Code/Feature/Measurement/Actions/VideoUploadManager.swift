import Foundation

class VideoUploadManager {
    static let shared = VideoUploadManager()

    func uploadVideo(videoUrl: URL, completion: @escaping (Result<ServerResponse, Error>) -> Void) {
        // Create the URL for the upload endpoint
        let uploadURL = URL(string: "https://turtled-back.dcs-seochan99.com/api/v1/predicts/upload")!
        
        // Generate a boundary string using a UUID
        let boundary = "Boundary-\(UUID().uuidString)"
        
        // Create the URLRequest to POST
        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"
        
        // Set the Content-Type Header to multipart/form-data
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Set the Authorization header from a cookie, assuming `getCookie` is a function you have defined to retrieve cookies.
        // Replace `getCookie` with your actual method of retrieving the stored access token.
        if let accessToken = UserStorageManager.shared.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(URLError(.userAuthenticationRequired)))
            return
        }
        
        // Create multipart form data
        let httpBody = NSMutableData()
        
        // Append the video data
        httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        httpBody.append("Content-Disposition: form-data; name=\"servey_video\"; filename=\"\(videoUrl.lastPathComponent)\"\r\n".data(using: .utf8)!)
        httpBody.append("Content-Type: video/mov\r\n\r\n".data(using: .utf8)!)
        if let videoData = try? Data(contentsOf: videoUrl) {
            httpBody.append(videoData)
            httpBody.append("\r\n".data(using: .utf8)!)
        } else {
            completion(.failure(URLError(.cannotOpenFile)))
            return
        }
        
        // End of the request body
        httpBody.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Assign the multipart form data to the URLRequest body
        request.httpBody = httpBody as Data
        
        // Create the URLSession task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            // Decode the JSON response
            do {
                let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                completion(.success(serverResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
