//
//  UpdateItemView.swift
//  SickSangHae
//
//  Created by CHANG JIN LEE on 2023/07/17.
//

import SwiftUI

struct UpdateItemView: View {
    @State var itemName: String = ""
    @State var itemAmount: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Spacer().frame(width: 155)
                Text("직접 추가")
                    .fontWeight(.bold)
                    .font(.title3)
                Spacer().frame(width: 115)
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15, height: 15)
            }.padding(.trailing, 20)

            HStack {
                Image(systemName: "chevron.left")
                    .frame(width: 8, height: 14.2)
                Text("2023년 7월 5일")
                    .fontWeight(.bold)
                    .padding(34)
                Image(systemName: "chevron.right")
                    .frame(width: 8, height: 14.2)
                    .foregroundColor(.blueGrayColor)
            } // 날짜 선택

            ZStack {
                Rectangle()
                    .frame(width: 350, height: 116)
                    .foregroundColor(.lightGrayColor)
                    .cornerRadius(12)
                VStack(alignment: .leading) {
                    HStack {
                        Text("품목")
                            .padding(.leading,20)
                        TextField("품목을 입력해주세요.", text: $itemName)
                            .foregroundColor(.blueGrayColor)
                            .padding(.leading,30)
                    }
                    Divider()
                        .frame(width: 350, height: 10)
                        .foregroundColor(.lightGrayColor)
                    HStack {
                        Text("금액")
                            .padding(.leading,20)
                        TextField("금액을 입력해주세요.", text: $itemAmount)
                            .foregroundColor(.blueGrayColor)
                            .padding(.leading,30)
                    }
                }.padding(.horizontal, 22)
                
            } // 품목과 금액 입력 탭 - X버튼 없어야 해서 ItemBlockView와 별개로 넣어놓음

            ZStack {
                Rectangle()
                    .frame(width: 350, height: 60)
                    .foregroundColor(.lightGrayColor)
                    .cornerRadius(12)
                HStack {
                    Image(systemName: "plus")
                    Text("품목 추가하기")
                }
                .bold()
                .foregroundColor(.accentColor)
            }
            .padding(.top, 15)
            // 품목 추가 버튼

            Spacer()

            ZStack {
                Rectangle()
                    .frame(width: 350, height: 60)
                    .foregroundColor(.lightGreenGrayColor)
                    .cornerRadius(12)
                HStack {
                    Text("다음")
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .padding(.bottom, 30)
        }
    }
}

    struct UpdateItemView_Previews: PreviewProvider {
        static var previews: some View {
            UpdateItemView()
        }
    }

