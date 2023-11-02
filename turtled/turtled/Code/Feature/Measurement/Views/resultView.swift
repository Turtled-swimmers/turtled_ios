import SwiftUI

struct ResultView: View {
    let serverResponse: ServerResponse
    @Binding var showDetail: Bool


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) { // Added spacing for overall uniform spacing
                Text("나의 거북목 심각도는...: \(serverResponse.percentage)%")
                    .font(Font.custom("SUIT", size: 20).weight(.bold))
                    .padding(.bottom, 10) // Add padding to give space under the text

                // Maintain aspect ratio within the frame
                AsyncImage(url: URL(string: serverResponse.image)) { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(width: UIScreen.main.bounds.width * 0.9) // Adjust width according to device width
                } placeholder: {
                    Color.gray
                }
                .cornerRadius(8)
                .padding(.bottom, 20) // Add padding to give space under the image

                
                
                
                Text("추천 운동법을 알아보자!")
                                    .font(Font.custom("SUIT", size: 20).weight(.bold))
                                    .padding(.bottom, 10)

                
                    

                ForEach(serverResponse.exerciseImgList, id: \.url) { exercise in
                                   VStack(alignment: .leading, spacing: 10) {
                                       AsyncImage(url: URL(string: exercise.url)) { image in
                                           image.resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: UIScreen.main.bounds.width * 0.85) // Adjust width according to device width
                                       } placeholder: {
                                           Color.gray
                                       }
                                       .cornerRadius(8)
                                       
                                       Text(exercise.content)
                                           .font(Font.custom("SUIT", size: 15).weight(.semibold))
                                   }
                               }
                GreenHorizontalButtonView(text: "돌아가기", action: {
                    self.showDetail = false
                })
            }
            .padding()
        }
    }
}
