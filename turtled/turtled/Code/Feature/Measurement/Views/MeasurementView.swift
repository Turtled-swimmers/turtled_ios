
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPickerPresented: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.isPickerPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPickerPresented = false
        }
    }
}


struct MeasurementView: View {
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented: Bool = false
    @State private var isLoading: Bool = false
    @State private var percentage: Int?

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
                            
                            self.isPickerPresented = true

                        })
                        .sheet(isPresented: $isPickerPresented) {
                                                ImagePicker(selectedImage: $selectedImage, isPickerPresented: $isPickerPresented)
                                            }
                        .onChange(of: selectedImage) { newImage in
                            if newImage != nil {
                                
                                isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    isLoading = false
                                    percentage = Int.random(in: 50...98)
                                }
                            }
                        }
                        VStack(alignment: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/
                         ){
                            Text("기록")
                                .fontWeight(.bold)
                                .padding(.top, 30.0)
                                .font(
                                    Font.custom("SUIT", size: 30)
                                        .weight(.regular)
                                )
                            // F8F9FE 배경을 가진 수평 카드
                            ResultView(imageName: "sample_1", date: "2023-10-20", percentage: 67)
                            ResultView(imageName: "sample_3", date: "2023-10-20", percentage: 82)
                            ResultView(imageName: "sample_2", date: "2023-10-20", percentage: 92)
                        }

                        if isLoading {
                            Text("Loading...")
                                .padding()
                        }

                        if let image = selectedImage, let percentage = percentage {
                            // 이미지 선택 후 디테일 뷰로 이동
                            NavigationLink(
                                destination: DetailView(image: image, percentage: percentage),
                                isActive: .constant(true), // 활성화 상태로 유지
                                label: {
                                    EmptyView()
                                }
                            )
                            .opacity(0) // 실제로 보이지 않는 버튼
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
// 디테일 뷰
struct DetailView: View {
    var image: UIImage
    var percentage: Int

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.5)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Text("거북목 측정 결과: \(percentage)%")
        }
        .navigationTitle("디테일 뷰")
    }
}


