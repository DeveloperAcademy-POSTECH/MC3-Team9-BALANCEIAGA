//
//  EditIconDetailView.swift
//  SickSangHae
//
//  Created by CHANG JIN LEE on 2023/07/15.
//

import SwiftUI

struct EditIconDetailView: View {
    @State private var isShowingSheet = false
    var body: some View {
        
        Button(action: {
            isShowingSheet.toggle()
        }) {
            Circle()
                .frame(width: screenWidth * 0.08)
                .foregroundColor(Color("Gray100"))
                .overlay(Image(systemName: "pencil"))
                .foregroundColor(Color("Gray800"))
        }
        .sheet(isPresented: $isShowingSheet,
               onDismiss: didDismiss) {
            
            ScrollView {
                Circle()
                    .frame(width: screenWidth * 0.28)
                    .foregroundColor(Color("Gray200"))
                Text("계란 30구")
                    .font(.title2)
                    .bold()
                    .padding(screenHeight * 0.028)
                
                LazyVGrid (
                    columns: [GridItem(.adaptive(minimum: 70))]
                ){
                    ForEach(0..<36) { i in
                        VStack {
                            Circle()
                                .fill(Color("Gray100"))
                                .frame(width: screenWidth * 0.18)
                            Text("얍")
                        }
                    }
                }
            }
            
            .padding(20)
            
            
                Button("Dismiss",
                       action: { isShowingSheet.toggle() })
            }
            
        }
    }
    
    
    func didDismiss() {
    }

struct EditIconDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EditIconDetailView()
    }
}
