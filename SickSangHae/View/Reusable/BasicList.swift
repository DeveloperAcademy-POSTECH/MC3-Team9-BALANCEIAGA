//
//  BasicList.swift
//  SickSangHae
//
//  Created by CHANG JIN LEE on 2023/07/15.
//

import SwiftUI

struct BasicList: View {
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @State var isDescending = true
    
    @State var appState: AppState

    
    var body: some View {
        ScrollView {
            PinnedListTitle
            pinnedListContent(pinnedList: ListContentViewModel(status: .shortTermPinned, itemList: coreDataViewModel.shortTermPinnedList))
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: screenWidth, height: 12)
                .background(Color("Gray100"))
            
            BasicListTitle
            basicListContent(basicList: ListContentViewModel(status: .shortTermUnEaten, itemList: coreDataViewModel.shortTermUnEatenList), isDesecending: isDescending)
            
        }
        .listStyle(.plain)
        
    }
    
    var BasicListTitle: some View {
            HStack {
                Text("기본")
                    .foregroundColor(Color("Gray900"))
                    .font(.pretendard(.semiBold, size: 20))
                
                Spacer()
                
                Button {
                    isDescending.toggle()
                } label: {
                    HStack(spacing: 2) {
                        Text(isDescending ? "최신순" : "오래된순")
                            .foregroundColor(Color("Gray600"))
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
                .foregroundColor(Color("Gray600"))
                .font(.pretendard(.medium, size: 14))
                .padding(.trailing, 20)
            }
            .padding([.top, .bottom], 17)
            .padding(.leading, 20)
    }
    
    private var PinnedListTitle: some View {
            HStack {
                Text("빨리 먹어야 해요 🕖")
                    .foregroundColor(Color("Gray900"))
                    .font(.pretendard(.semiBold, size: 20))
                
                Spacer()
            }
            .padding(.vertical, 17)
            .padding(.horizontal, 20)
        }
    
    func pinnedListContent(pinnedList: ListContentViewModel) -> some View {
        return ForEach(pinnedList.itemList, id: \.self) { item in
                VStack {
                    listCell(item: item, appState: appState)
                    
                    Divider()
                        .overlay(Color("Gray100"))
                        .opacity(item == pinnedList.itemList.last ? 0 : 1)
                        .padding(.leading, 20)
            }
        }
    }
    
    func basicListContent(basicList: ListContentViewModel, isDesecending: Bool) -> some View {
        return ForEach(isDescending ? basicList.itemList : basicList.itemList.reversed(), id: \.self) { item in
                VStack {
                    listCell(item: item, appState: appState)
                    
                    Divider()
                        .overlay(Color("Gray100"))
                        .opacity(item == basicList.itemList.last ? 0 : 1)
                        .padding(.leading, 20)
            }
        }
    }
}






private struct ListContent: View {
    @ObservedObject var coreDataViewModel: CoreDataViewModel
    @ObservedObject var listContentViewModel: ListContentViewModel
    
    @State var isDescending: Bool
    
    @State var appState: AppState
    
    init(coreDataViewModel: CoreDataViewModel, listContentViewModel: ListContentViewModel, isDescending: Bool, appState: AppState) {
        self.coreDataViewModel = coreDataViewModel
        self.listContentViewModel = listContentViewModel
        self.isDescending = isDescending
        self.appState = appState
    }
    
    var body: some View {
        ForEach(listContentViewModel.itemList) { item in
            VStack {
                listCell(item: item, appState: appState)
                
                Divider()
                    .overlay(Color("Gray100"))
                    .opacity(item == listContentViewModel.itemList.last ? 0 : 1)
                    .padding(.leading, 20)
                
            }
        }
    }
    
}

class ListContentViewModel: ObservableObject {
    
    let status: Status
    @Published var itemList: [Receipt]
    @Published var offsets: [CGFloat]
    
    init(status: Status, itemList: [Receipt]) {
        self.status = status
        self.itemList = itemList
        self.offsets = [CGFloat](repeating: 0, count: itemList.count)
    }
}

extension View {
    func listCell(item: Receipt, appState: AppState) -> some View {
        return NavigationLink {
            ItemDetailView(topAlertViewModel: TopAlertViewModel(name: item.name, changedStatus: item.currentStatus), receipt: item, appState: appState, needToEatASAP: item.currentStatus)
        } label: {
            ZStack {
                Rectangle()
                    .fill(.white)
                HStack(spacing: 0) {
                    Text("")
                        .foregroundColor(.clear)
                    
                    Image(item.icon)
                        .resizable()
                        .foregroundColor(Color("Gray200"))
                        .frame(width: 36, height: 36)
                        .padding(.leading, 20)
                    
                    Spacer()
                        .frame(width: 12)
                        
                    
                    Text(item.name)
                        .font(.system(size: 17).weight(.semibold))
                        .foregroundColor(Color("Gray900"))
                        .frame(height: 17)
                    
                    Spacer()
                    
                    Text("구매한지 \(item.dateOfPurchase.dateDifference)일")
                        .foregroundColor(Color("Gray900"))
                        .font(.system(size: 14).weight(.semibold))
                        .padding(.trailing, 20)
                }
                .padding(.vertical, 8)
            }
        }
    }
}


struct BasicList_Previews: PreviewProvider {
    static let previewCoreDataViewModel = CoreDataViewModel()
    static var previews: some View {
        BasicList(appState: AppState())
            .environmentObject(previewCoreDataViewModel)
    }
}
