//
//  UpdateItemView.swift
//  SickSangHae
//
//  Created by CHANG JIN LEE on 2023/07/17.
//

import SwiftUI

struct OCRUpdateItemView: View {
    @Namespace var bottomID
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: UpdateItemViewModel
    @Binding var gptAnswer: [String:[Any]]
    @State private var isItemCheckView = false
    let appState: AppState
    
    @State var showCalendarModal = false
    
    var body: some View {
            ZStack(alignment: .top) {
                Color.white
                    .ignoresSafeArea(.all)
                VStack(spacing: 0) {
                    topBar
                    Spacer().frame(height: 36.adjusted)
                    DateSelectionView(viewModel: viewModel, showCalendarModal: $showCalendarModal)
                    Spacer().frame(height: 30.adjusted)
                    ZStack(alignment: .top) {
                        VStack(spacing: 0) {
                            ScrollViewReader { proxy in
                                ScrollView(.vertical) {
                                    ForEach(viewModel.itemBlockViewModels, id: \.self) { item in
                                        ItemBlockView(viewModel: viewModel, itemBlockViewModel: item)
                                            .onChange(of: viewModel.itemBlockViewModels) { _ in
                                                withAnimation {
                                                    proxy.scrollTo(bottomID, anchor: .bottom)
                                                }
                                            }
                                    }
                                }
                            }
                            Spacer()
                            addItemButton
                                .onTapGesture {
                                    withAnimation {
                                        addItemBlockView()
                                    }
                                }
                                .id(bottomID)
                            
                        }
                }
            }
        }
        .onAppear {
            for i in 0..<gptAnswer["상품명"]!.count {
                viewModel.makeInitialItemBlock(name: gptAnswer["상품명"]![i] as! String, price: gptAnswer["금액"]![i] as! Int)
            }
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $viewModel.isDatePickerOpen){
            CalendarModalView(viewModel: viewModel, showCalendarModal: $showCalendarModal)
                .presentationDetents([.large, .fraction(0.65), .fraction(0.75)])
        }
    }
    
    
    private var topBar: some View {
        HStack {
            Button(action:{dismiss()}, label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 10, height: 19)
            })
            Spacer()
            Text("수정")
                .font(.pretendard(.bold, size: 17))
            Spacer()
            Button(action: {
                self.appState.moveToRootView = true
            } , label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15, height: 15)
            })
        }
        .foregroundColor(.gray900)
        .padding([.leading, .trailing], 20.adjusted)
    }
    
    private var addItemButton: some View {
        ZStack {
            Rectangle()
                .frame(maxWidth: 350, maxHeight: 60)
                .foregroundColor(Color.gray50)
                .cornerRadius(12)
            
            HStack {
                Image(systemName: "plus")
                Text("품목 추가하기")
            }
            .bold()
            .foregroundColor(.accentColor)
        }
        .padding(.top, 15)
    }
    
    private var nextButton: some View {
        Button(action: {
            viewModel.isShowTextfieldWarning = !viewModel.areBothTextFieldsNotEmpty
            registerItemBlockViews()
            //            isItemCheckView = true
            dismiss()
        }, label: {
            ZStack{
                Rectangle()
                    .cornerRadius(12)
                    .frame(maxWidth: 88.adjusted, maxHeight: 60.adjusted)
                Text("다음")
                    .foregroundColor(.white)
                    .font(.pretendard(.regular, size: 17))
            }
            .padding(.horizontal, 20.adjusted)
            .padding(.bottom, 30.adjusted)
        })
    }
}

extension OCRUpdateItemView {
    struct CalendarModalView: View {
        @ObservedObject var viewModel: UpdateItemViewModel
        @Binding var showCalendarModal: Bool
        
        var body: some View {
            VStack(spacing: 0) {
                HStack(alignment: .center){
                    Text("날짜 바꾸기")
                        .font(.pretendard(.semiBold, size: 17))
                        .padding(.top, 41)
                }
                DatePicker("날짜 선택", selection: $viewModel.date, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
                    .padding()
                    .onChange(of: viewModel.date, perform: { newDate in
                        if newDate > Date() {
                            viewModel.date = Date()
                        }
                    })
                
                ZStack {
                    Rectangle()
                        .frame(width: 350, height: 60)
                        .foregroundColor(Color.gray50)
                        .cornerRadius(12)
                    Button {
                        showCalendarModal = false
                    } label: {
                        Text("확인")
                            .foregroundColor(.primaryGB)
                            .bold()
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
    
    struct DateSelectionView: View {
        @ObservedObject var viewModel: UpdateItemViewModel
        @Binding var showCalendarModal: Bool
        
        var body: some View {
            HStack(spacing: 24) {
                Button(action: {
                    viewModel.decreaseDate = viewModel.date
                }, label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 8, height: 14)
                })
                
                Button(action: {
//                    viewModel.isDatePickerOpen.toggle()
                    showCalendarModal = true
                }, label: {
                    Text("\(viewModel.dateString)")
                        .font(.pretendard(.bold, size: 20))
                })
                
                Button(action: {
                    viewModel.increaseDate = viewModel.date
                }, label: {
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 8, height: 14)
                })
                .foregroundColor(viewModel.isDateBeforeToday ? .black : .gray)
            }
            .foregroundColor(.black)
        }
    }
    
    struct DatePickerView: View {
        @ObservedObject var viewModel: UpdateItemViewModel
        
        var body: some View {
            ZStack {
                Rectangle()
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
                
                GeometryReader { geo in
                    DatePicker(
                        viewModel.dateString,
                        selection: $viewModel.date,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .datePickerStyle(.wheel)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .onChange(of: viewModel.date) { _ in
                        viewModel.isDatePickerOpen = false
                    }
                    
                }
                .padding(20)
            }
            .frame(height: screenHeight/(2.6))
            .padding(.horizontal, 15)
        }
    }
    
    
    func addItemBlockView() {
        viewModel.addNewItemBlock()
    }
    
    func registerItemBlockViews() {
        
        gptAnswer = ["상품명":[], "단가":[], "수량":[], "금액":[]]
        
        viewModel.itemBlockViewModels.forEach { item in
            gptAnswer["상품명"]!.append(item.name)
            gptAnswer["단가"]!.append(item.price)
            gptAnswer["수량"]!.append(1)
            gptAnswer["금액"]!.append(item.price)
        }
        //        for i in 0..<viewModel.itemBlockViewModels.count {
        //
        //        }
    }
}


struct OCRUpdateItemView_Previews: PreviewProvider {
    @State var testDict = ["상품명":[], "단가":[], "수량":[], "금액":[]]
    static var previews: some View {
        OCRUpdateItemView(viewModel: UpdateItemViewModel(), gptAnswer: .constant(["test": []]), appState: AppState())
    }
}
