
import SwiftUI
import AVFoundation

struct MeasurementView: View {
    @State private var isLoading: Bool = false

    @State private var percentage: Int?
    
    @State private var image: UIImage = UIImage()
    @State private var showImagePicker: Bool = false
    @State private var selectedVideoURL: URL?
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var resultView: ResultView? // Add this line
    @State private var navigateToResult = false
    @State private var serverResponse: ServerResponse? // Hold the server response data
    @State var showDetail = false
    


    
    var body: some View {
        NavigationView{
            ScrollView{
                ZStack{
                    if isLoading {
                        // Overlay the loading indicator on top of your existing content
                        ProgressView("Uploading...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue)) // Customize as needed
                            .scaleEffect(1.5) // Make it larger if you like
                    }
                    else if showDetail, let response = serverResponse {
                        ResultView(serverResponse: response, showDetail: $showDetail)
                    }

                    else{
                        VStack{
                            // 캐릭터
                            Image("turtle3")
                                .aspectRatio(contentMode: .fill)
                                .padding(.vertical, 50.0)
                            // 버튼
                            GreenHorizontalButtonView(text: "측정하러 가기", action: {
                                showImagePicker.toggle()
                            })
                            .fullScreenCover(isPresented: $showImagePicker, content: {
                                ImagePicker(selectedVideoURL: $selectedVideoURL, selectedImage: $image, sourceType: $sourceType)
                                    .onDisappear {
                                        // When the ImagePicker is dismissed, check if a video URL is selected
                                        if let videoURL = selectedVideoURL {
                                            self.isLoading = true
                                            print("Selected video URL: \(videoURL)")
                                            VideoUploadManager.shared.uploadVideo(videoUrl: videoURL) { result in
                                                DispatchQueue.main.async {
                                                    self.isLoading = false // Stop the loading indicator when the operation is finished
                                                    switch result {
                                                    case .success(let response):
                                                        self.serverResponse = response // Set the server response here
                                                        self.showDetail = true
                                                        
                                                        
                                                        
                                                    case .failure(let error):
                                                        // Handle the error
                                                        print("Upload failed with error: \(error)")
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                
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
                                ResultRowView(imageName: "sample_1", date: "2023-10-20", percentage: 67)
                                ResultRowView(imageName: "sample_3", date: "2023-10-20", percentage: 82)
                                ResultRowView(imageName: "sample_2", date: "2023-10-20", percentage: 92)
                            }
                        }
                        .padding(.horizontal, 20.0)
                    }
                }
            }.navigationTitle("거북목 측정")
        
        }
    }
}

struct MeasurementView_Previews: PreviewProvider {
    static var previews: some View {
        MeasurementView()
    }
}

struct ResultRowView: View {
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



