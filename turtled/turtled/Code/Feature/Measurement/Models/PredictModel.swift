import Foundation

// Define the structure of the server response
struct ServerResponse: Decodable {
    let percentage: Int
    let image: String
    let exerciseImgList: [ExerciseImage]

    enum CodingKeys: String, CodingKey {
        case percentage
        case image
        case exerciseImgList = "exercise_img_list"
    }
}

// Define the structure for each exercise image in the list
struct ExerciseImage: Decodable {
    let url: String
    let content: String
}
