import SwiftUI

struct CalendarTodoHeaderSwiftUIView: View {
    
    // 선택된 날짜를 바인딩하여 받을 변수
    @Binding var selectedDate: DayModel?

    var body: some View {
        VStack(spacing: 0){
            HStack{
                VStack(spacing: 16){
                    
                    // 일자
                    HStack{
                        Text("\(String(selectedDate?.date.year ?? 2023))년 \(String(selectedDate?.date.month ?? 7))월 \(String(selectedDate?.date.SingleDay ?? 20))일")
                            .font(
                                Font.custom("SUIT", size: 15)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0.27, green: 0.27, blue: 0.33))
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom,20)
        }
    }
}

struct CalendarTodoHeaderSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarTodoHeaderSwiftUIView(selectedDate: .constant(DayModel(currentDate: Date())))
    }
}
