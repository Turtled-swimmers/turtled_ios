
import SwiftUI
import AVFoundation


struct MeasurementView: View {
    @State private var isLoading: Bool = false
    @State private var percentage: Int?
    
    @State private var image: UIImage = UIImage()
    @State private var showImagePicker: Bool = false
    @State private var selectedVideoURL: URL?
    @State private var sourceType: UIImagePickerController.SourceType = .camera


    
    var body: some View {
        NavigationView{
            ScrollView{
                    VStack{
                        // 캐릭터
                        Image("turtle3")
                            .aspectRatio(contentMode: .fill)
                            .padding(.vertical, 50.0)
                        // 버튼
                        GreenHorizontalButtonView(text: "측정하러 가기", action: {
                            showImagePicker.toggle()
//                            self.showImagePicker = true
                        })
                        .fullScreenCover(isPresented: $showImagePicker, content: {
                            ImagePicker(selectedVideoURL: $selectedVideoURL, selectedImage: $image, sourceType: $sourceType)

                        })
                        VStack(alignment: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/
                         ){
                            Text("기록")
                                .fontWeight(.bold)
                                .padding(.top, 30.0)
                                .font(
                                    Font.custom("SUIT", size: 30)
                                        .weight(.regular)
                                )
                            ResultView(imageName: "sample_1", date: "2023-10-20", percentage: 67)
                            ResultView(imageName: "sample_3", date: "2023-10-20", percentage: 82)
                            ResultView(imageName: "sample_2", date: "2023-10-20", percentage: 92)
                        }
                    }
                .padding(.horizontal, 20.0)
            }.navigationTitle("거북목 측정")
        }
    }
}

struct MeasurementView_Previews: PreviewProvider {
    static var previews: some View {
        MeasurementView()
    }
}

struct ResultView: View {
    var imageName: String
    var date: String
    var percentage: Int

    var body: some View {
        HStack(alignment: .top){
            Spacer()
            // Image
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.25)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Spacer()
            
            VStack(alignment: .leading){
                // Date
                Text(date)
                    .fontWeight(.bold)
                    .font(Font.system(size: 15))
                    .padding(.bottom, 1.0)
                
                // Percentage result
                Text("거북목 측정 결과: \(percentage)%")
                    .font(Font.system(size: 20))
            }
            .padding(.top, 20.0)

            Spacer()
        }
        .padding(.vertical, 15.0)
        .background(Color(red: 0.97, green: 0.98, blue: 1))
    }
}



