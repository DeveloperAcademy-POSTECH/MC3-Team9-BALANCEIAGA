//
//  SmallButtonView.swift
//  SickSangHae
//
//  Created by CHANG JIN LEE on 2023/07/15.
//

import SwiftUI

struct SmallButtonView: View {
    var body: some View {
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
        .padding(.horizontal, 20)
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .bold()
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
