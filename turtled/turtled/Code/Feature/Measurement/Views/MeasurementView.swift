//
//  MeasurementView.swift
//  turtled
//
//  Created by 서희찬 on 2023/10/16.
//

import SwiftUI

struct MeasurementView: View {
    var body: some View {
        NavigationView{
            ScrollView{

                    VStack{
                        // 캐릭터
                        Image("turtle3")
                            .aspectRatio(contentMode: .fill)
                            .padding(.vertical, 50.0)
                        
                        // 버튼
                        GreenHorizontalButtonView(text: "측정하러 가기", action: {})
                        
                        Text("기록")
                            .fontWeight(.bold)
                            .padding(.top, 30.0)
                            .font(
                                Font.custom("SUIT", size: 30)
                                    .weight(.regular)
                            )
                        // F8F9FE 배경을 가진 수평 카드
                        HStack(alignment: .top){
                            Spacer()
                                      // 수평의 30퍼정도 차지하는 사진
                                      Image("default_turtled")
                                          .resizable()
                                          .aspectRatio(contentMode: .fit)
                                          .frame(width: UIScreen.main.bounds.width * 0.25)
                            Spacer()
                                      VStack(alignment: .leading){
                                          
                                          // 날짜
                                          Text("2023-10-16")
                                              .fontWeight(.bold)
                                              .font(
                                                  Font
                                                    .system(size: 15)
                                              )
                                              .padding(.bottom, 1.0)
                                          
                                          // 거북목 측정 결과 : 00%
                                          Text("거북목 측정 결과: 00%")
                                              .font(
                                                  Font
                                                    .system(size: 20)
                                              )
                                      }
                                      .padding(.top, 20.0)
                            Spacer()
                        }.padding(.vertical, 10.0).background(Color(red: 0.97, green: 0.98, blue: 1))

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
