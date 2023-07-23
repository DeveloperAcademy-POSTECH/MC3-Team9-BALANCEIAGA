//
//  SmallButtonView.swift
//  SickSangHae
//
//  Created by CHANG JIN LEE on 2023/07/15.
//

import SwiftUI

struct SmallButtonView: View {
    var body: some View {
        ZStack {
            VStack{
                Divider()
                    .foregroundColor(Color("Gray100"))
                    .frame(width: 390.adjusted, height: 1.adjusted)
                HStack {
                    Button("먹었어요😋") {
                        print("click")
                    }
                    .buttonStyle(CustomButtonStyle())
                    .background(
                        Rectangle()
                            .stroke(lineWidth: 0)
                            .background(Color("PrimaryG"))
                            .cornerRadius(15)
                    )
                    Spacer()
                    Button("상했어요🤢") {
                        print("click")
                    }
                    .buttonStyle(CustomButtonStyle())
                    .background(
                        Rectangle()
                            .stroke(lineWidth: 0)
                            .background(Color("SmallButton"))
                            .cornerRadius(15)
                    )
                }
                .padding(EdgeInsets(top: 15.adjusted, leading: 20.adjusted, bottom: 40.adjusted, trailing: 20.adjusted))
                // Figma 화면과 비슷한 배율로 그리려면 top padding 15로 해야함
            }
            .frame(width: 390.adjusted, height: 119.adjusted)
        }
    }
    
    struct CustomButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .fontWeight(.heavy)
                .frame(width: 167.adjusted, height: 60.adjusted)
                .foregroundColor(.white)
                .opacity(configuration.isPressed ? 0.7 : 1)
        }
    }
    
    
    struct SmallButtonView_Previews: PreviewProvider {
        static var previews: some View {
            SmallButtonView()
        }
    }
}
