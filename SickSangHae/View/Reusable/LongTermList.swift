//
//  LongTermList.swift
//  SickSangHae
//
//  Created by CHANG JIN LEE on 2023/07/15.
//

import SwiftUI

struct LongTermList: View {
    let testLists = ["계란 30구","모둠쌈","요플레","요플레","모둠쌈","라면","양파","계란","모둠쌈","요플레","모둠쌈","모둠쌈","계란","요플레","모둠쌈","요플레"]

    var body: some View {
        NavigationStack {
            List {
                ForEach(testLists, id: \.self) { testList in

                    HStack{

                        // 이 부분 빈 문자열이 없으면 이미지 밑에 구분선이 왜 없어질까요?
                        Text("")
                            .foregroundColor(.clear)

                        Image(systemName: "circle.fill")
                            .resizable()
                            .foregroundColor(Color("Gray200"))
                            .frame(width: 36.adjusted, height: 36.adjusted)

                        Text(testList)
                            .foregroundColor(Color("Gray900"))
                            .font(.system(size: 17.adjusted).weight(.semibold))
                        //                            .font(.custom("Pretendard-Bold", size: 20)) // Pretendard Bold 폰트 적용

                        Spacer()

                        Text("구매한지 x일")
                            .foregroundColor(Color("Gray900"))
                            .font(.system(size: 14.adjusted).weight(.semibold))
                    }

                }
                .padding(.vertical, 16.adjusted)
            }
            .listStyle(.plain)
            .padding(.top, 27.adjusted)
            .navigationBarItems(leading: leadingText, trailing: trailingButton)
        }

    }

    var leadingText: some View {
            Text("천천히 먹어도 돼요")
            .foregroundColor(Color("Gray900"))
            .font(.system(size: 20.adjusted).weight(.bold))
            .padding(.top, 27.adjusted)
        }

    var trailingButton: some View {
        Button(action: {
            // Your action for the trailing button
        }) {
            Text("최신순")
            Image(systemName: "arrow.up.arrow.down")
        }
        .foregroundColor(Color("Gray600"))
        .font(.system(size: 14.adjusted).weight(.semibold))
        .padding(.top, 27.adjusted)
    }


}

struct LongTermList_Previews: PreviewProvider {
    static var previews: some View {
        LongTermList()
    }
}
