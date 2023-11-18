//
//  HistoryView.swift
//  SickSangHae
//
//  Created by kimsangwoo on 2023/07/17.
//

import SwiftUI

struct HistoryView: View {
    
    @State var isEatenTab = true
    @State var isShowingCenterAlertView = false
    @State var isDeletingItem = false
    @State var selectedItem: Receipt?
    
    @State private var isChangeTab = true
    
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text("식기록")
                    .font(.pretendard(.bold, size: 28))
                    .foregroundColor(.primaryGB)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                
                segmentedTabButton
                
                ScrollView {
                    listSection
                }
                .listStyle(.plain)
            } // VStack
            
        CenterAlertView(
            titleMessage: "식료품 삭제",
            bodyMessage: selectedItem?.name ?? "알수없음",
            actionButtonMessage: "삭제",
            isShowingCenterAlertView: $isShowingCenterAlertView,
            isDeletingItem: $isDeletingItem
        )
            .opacity(isShowingCenterAlertView ? 1 : 0)
            .onChange(of: isDeletingItem) { _ in
                if isDeletingItem {
                    coreDataViewModel.deleteReceiptData(target: selectedItem)
                    isDeletingItem = false
                } // if
            } // onChange
        } // ZStack
    } // body
    
    var segmentedTabButton: some View {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button(action: {
                        isEatenTab = true
                        withAnimation(.spring(duration: 0.3)) {
                            isChangeTab = true
                        }
                    }, label: {
                        Text("먹었어요😋")
                            .font(.pretendard(.bold, size: 20))
                            .foregroundColor(.gray900)
                            .frame(width: screenWidth * 0.5)
                            .padding(.vertical, 16)
                    }) // Button
                    
                    Button(action: {
                        isEatenTab = false
                        withAnimation(.spring(duration: 0.3)) {
                            isChangeTab = false
                        }
                    }, label: {
                        Text("상했어요🤢")
                            .font(.pretendard(.bold, size: 20))
                            .foregroundColor(.gray900)
                            .frame(width: screenWidth * 0.5)
                            .padding(.vertical, 16)
                    }) // Button
                } // HStack
                
                Rectangle()
                    .foregroundColor(.primaryGB)
                    .frame(width: screenWidth * 0.5, height: 3)
                    .padding(.leading, isChangeTab ? 0 : screenWidth * 0.5)
                    .padding(.trailing, isChangeTab ? screenWidth * 0.5 : 0)
                
                Rectangle()
                    .foregroundColor(.gray100)
                    .frame(height: 1)
            } // VStack
    } // segmentedTabButton
    
    var listSection: some View {
        var targetDictionary: [String : [Receipt]] = [String : [Receipt]]()
        var keys: [String] = [String]()
        
        if isEatenTab {
            targetDictionary = coreDataViewModel.eatenDictionary
            keys = Array(targetDictionary.keys.sorted(by: >))
        } else {
            targetDictionary = coreDataViewModel.spoiledDictionary
            keys = Array(targetDictionary.keys.sorted(by: >))
        }
        
        let content: AnyView
        
        if keys.isEmpty {
            content = AnyView(
                VStack {
                    Image(systemName: "tray")
                        .resizable()
                        .foregroundColor(.gray200)
                        .frame(width: 80, height: 60)
                        .padding(.top, screenHeight * 0.25)
                    
                    Text("현재 해당 식기록이 없어요")
                        .foregroundColor(.gray200)
                        .font(.pretendard(.bold, size: 17))
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            ) // AnyView
        } else {
            content = AnyView(
                ForEach(keys, id:\.self) { key in
                    VStack {
                        listTitle(itemDictionary: targetDictionary, key: key)
                        itemList(itemDictionary: targetDictionary, key: key)

                        if keys.last != key {
                            Rectangle()
                                .foregroundColor(.gray100)
                                .frame(height: 12)
                        } // if
                    } // VStack
                } // ForEach
            ) // AnyView
        } // else
        
        return content
    } // listSection
    
    func listTitle(itemDictionary: [String: [Receipt]], key: String) -> some View {
        HStack {
            Text(key)
                .foregroundColor(.gray800)
                .font(.pretendard(.bold, size: 17))
            
            Spacer()
        } // HStack
        .padding(.top, 16)
        .padding(.horizontal, 20)
    } // listTitle
    
    func itemList(itemDictionary: [String: [Receipt]], key: String) -> AnyView {
        guard let itemList = itemDictionary[key] else { return AnyView(EmptyView()) }
        
        return AnyView(
            ForEach(itemList, id:\.self) { item in
                HStack(spacing: 0) {
                    Image(item.icon)
                        .resizable()
                        .foregroundColor(.gray200)
                        .frame(width: 40, height: 40)
                        .padding(.trailing, 12)
                    
                    Text(item.name)
                        .font(.pretendard(.semiBold, size: 17))
                        .foregroundColor(.gray900)
                    
                    Spacer()
                    
                    contextMenus(item: item)
                } //HStack닫기
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
            } // ForEach
        ) // AnyView
    } // itemList
    
    func contextMenus(item: Receipt) -> some View {
        Menu {
            Button(action: {
                coreDataViewModel.recoverPreviousStatus(target: item)
            }, label: {
                Text("복구하기")
                Image(systemName: "arrow.counterclockwise")
            }) // Button
            
            Divider()
            
            Button(role: .destructive, action: {
                selectedItem = item
                withAnimation(.easeInOut(duration: 0.2)) {
                    isShowingCenterAlertView = true
                }
            }, label: {
                Text("삭제하기")
                Image(systemName: "trash.fill")
            }) // Buton
        } label: {
            Rectangle()
                .frame(width: 36, height: 36)
                .foregroundColor(.clear)
                .overlay(
                    Image(systemName: "ellipsis")
                        .resizable()
                        .foregroundColor(Color("Gray200"))
                        .frame(width: 21, height: 5)
                )
        } // Menu
    } // menuButtons
} // struct

struct HistoryView_Previews: PreviewProvider {
    static let coreDataViewModel = CoreDataViewModel()
    static var previews: some View {
        HistoryView()
            .environmentObject(coreDataViewModel)
    }
}
