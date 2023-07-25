//
//  CenterAlertView.swift
//  SickSangHae
//
//  Created by CHANG JIN LEE on 2023/07/15.
//

import SwiftUI

struct CenterAlertView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            centerAlert
        }
    } //body닫기
    
    
    var centerAlert: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(.white, lineWidth: 2)
            .frame(width: 300, height: 170)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .opacity(0.6)
            .overlay(
                VStack {
                    centerAlertText
                        .padding(.top, 20)
                    centerAlertButton
                        .padding(.bottom, 20)
                }
            )
    } //backgroundRectangle닫기
    
    var centerAlertText: some View {
        VStack(spacing: 0) {
            Text("제목")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color("Gray900"))
                .frame(width: 240, height: 20)
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
            
            Text("본문 경고 메시지")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(Color("Gray800"))
                .frame(width: 240, height: 17)
                .multilineTextAlignment(.center)
                .padding(.bottom, 18)
        }
    } //centerAlertText닫기
    
    var centerAlertButton: some View {
        HStack {
            Button(action: {
                // showCenterAlert = false
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 125, height: 45)
                        .foregroundColor(Color("Gray100"))
                    Text("아니오")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color("Gray600"))
                }
            })
            
            Spacer()
                .frame(width: 10)
            
            Button(action: {
                /*
                 deleteItem
                 showCenterAlert = false
                 */
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 125, height: 45)
                        .foregroundColor(Color("PointR"))
                    Text("네, OO할래요")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
            })
        } //HStack닫기
    } //centerAlertButton닫기
} //struct닫기

struct CenterAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CenterAlertView()
    }
}
