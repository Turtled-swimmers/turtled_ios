import SwiftUI

struct MedalView: View {
    // 더미데이터
    let medals = [
        Medal(image: "dalsung_medal", title: "성실 거북", content1: "나는야 성실 거북!", content2: "\"매일 매일 스트레칭 열심히 할거야!\"", requirement: "✔️ 달성 조건 : 1일 1스트레칭 연속 5회", isAchieved: true),
        Medal(image: "dalsung_medal", title: "열정 거북", content1: "나는야 열정 거북!", content2: "\"열정적으로 운동할거야!\"", requirement: "✔️ 달성 조건 : 1주일 연속 운동", isAchieved: false),
        Medal(image: "dalsung_medal", title: "건강 거북", content1: "나는야 건강 거북!", content2: "\"건강을 위해 매일 걷기 운동을 할거야!\"", requirement: "✔️ 달성 조건 : 1개월 연속 10,000보 걷기", isAchieved: true)
    ]
    var body: some View {
        NavigationView{
            ScrollView(showsIndicators: false){
                ForEach(medals) { medal in
                    // 메달 리스트
                    HStack{
                        VStack{
                            Image(medal.image)
                                .opacity(medal.isAchieved ? 1.0 : 0.4)
                            // title
                            Text(medal.title)
                                .opacity(medal.isAchieved ? 1.0 : 0.4)
                        }
                        .padding(.trailing, 15)
                        VStack(alignment: .leading){
                            // content1
                            Text(medal.content1)
                                .font(.system(size: 15))
                                .opacity(medal.isAchieved ? 1.0 : 0.4)
                            
                            // content2
                            Text(medal.content2)
                                .font(.system(size: 15))
                            
                                .opacity(medal.isAchieved ? 1.0 : 0.4)
                            // requirment
                            Text(medal.requirement)
                                .font(.system(size: 15))
                                .opacity(medal.isAchieved ? 1.0 : 0.4)
                        }
                        Spacer()
                    }
                    .padding(.vertical,10)
                    // 분리선
                    Divider()
                }
                .padding(.horizontal, 24.0)
                .padding(.top,20)
                // 아래여백
                Spacer()
            } .navigationTitle("메달") // Navigation Title 설정
        }

        
        
    }
    
}

struct MedalView_Previews: PreviewProvider {
    static var previews: some View {
        MedalView()
    }
}
