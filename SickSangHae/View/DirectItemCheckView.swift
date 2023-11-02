//
//  DirectItemCheckView.swift
//  SickSangHae
//
//  Created by user on 2023/07/30.
//


import SwiftUI

struct DirectItemCheckView: View {

    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: UpdateItemViewModel
    @State var appState: AppState
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @State private var isShowingModal = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                VStack {
                    ZStack(alignment: .top){
                        ZigZagShape()
                            .fill(Color.gray50)
                            .ignoresSafeArea()
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 185)
                        VStack{
                            HStack {
                                Button(action:{dismiss()}, label: {
                                    Image(systemName: "chevron.left")
                                        .resizable()
                                        .frame(width: 10, height: 19)
                                        .foregroundColor(.gray900)
                                })
                                
                                Spacer()
                                
                                Text("직접 추가")
                                    .foregroundColor(Color("Gray900"))
                                    .font(.system(size: 17.adjusted)
                                        .weight(.bold))
                                
                                Spacer()
                                
                                Button(action: {
                                    self.appState.moveToRootView = true
                                    
                                }, label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                })
                                .foregroundColor(.gray900)
                            }.padding(.horizontal, 20)
                            
                            HStack {
                                Text("아래 식료품을 등록할게요")
                                    .foregroundColor(Color("Gray400"))
                                    .fontWeight(.bold)
                                    .padding(34)
                            }
                        }
                    }
                    
                    ListTitle

                    ScrollView{
                        ListContents
                    }

                    Spacer()

                    Button{
                        isShowingModal = true
                    } label: {
                        ZStack{
                            Rectangle()
                                .frame(width: 350, height: 60)
                                .foregroundColor(Color("PrimaryGB"))
                                .cornerRadius(12)
                            HStack {
                                Text("등록하기")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        }
                        .padding(.bottom, 30)
                    }

                }
            }
            .onDisappear(){
                registerItemsToCoreData()
            }
            .navigationBarBackButtonHidden(true)
        }
        .fullScreenCover(isPresented: $isShowingModal){
            RegisterCompleteView(appState: appState)
        }
    }
    private var ListTitle: some View {
        HStack{
            Text(viewModel.dateString)
                .foregroundColor(Color("Gray900"))
                .font(.system(size: 20.adjusted).weight(.bold))

            Spacer()


        }
        .padding([.top, .bottom], 17.adjusted)
        .padding(.leading, 20.adjusted)
    }

    private var ListContents: some View{
            VStack{
                listDetail(listTraling: "품목", listLeading: "금액")
                    .padding(.horizontal, 40)
                    .padding(.top)

                Divider()
                    .overlay(Color("Gray100"))

                ForEach(viewModel.itemBlockViewModels, id: \.self) { item in

                    listDetail(listTraling: item.name, listLeading: String(item.price) + "원")

                    Divider()
                        .overlay(Color("Gray100"))
                }
                .padding(.horizontal, 40.adjusted)
            }
    }


    // TODO: listTraling에 품목을, listLeading에 금액을 넣어야 해요.
    private func listDetail(listTraling: String, listLeading: String) -> some View{
        return HStack{
            Text(listTraling)
                .font(.system(size: 17.adjusted).weight(.semibold))

            Spacer()

            Text(listLeading)
                .foregroundColor(Color.gray800)
                .font(.system(size: 14.adjusted).weight(.semibold))
        }
        .padding([.top, .bottom], 8.adjusted)
    }


    func registerItemsToCoreData() {
        viewModel.itemBlockViewModels.forEach { item in
            coreDataViewModel.createReceiptData(name: item.name, price: abs(Double(item.price)), date: viewModel.date)
        }
    }
}

struct ZigZagShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.size.width
        let height = rect.size.height
        
        let zigZagWidth: CGFloat = 7
        let zigZagHeight: CGFloat = 5
        var yInitial = height - zigZagHeight
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: yInitial))
        
        var slope = -1
        var x: CGFloat = 0
        var i = 0
        while x < width {
            x = zigZagWidth * CGFloat(i)
            let p = zigZagHeight * CGFloat(slope)
            let y = yInitial + p
            path.addLine(to: CGPoint(x: x, y: y))
            slope = slope * (-1)
            i += 1
        }
        
        path.addLine(to: CGPoint(x: width, y: 0))
        
        yInitial = 0 + zigZagHeight
        x = CGFloat(width)
        i = 0
        while x > 0 {
            x = width - (zigZagWidth * CGFloat(i))
            let p = zigZagHeight * CGFloat(slope)
            let y = yInitial + p
            path.addLine(to: CGPoint(x: x, y: y))
            slope = slope * (-1)
            i += 1
        }

        return path
    }
}

struct DirectItemCheckView_Previews: PreviewProvider {

    static var previews: some View {
        DirectItemCheckView(viewModel: UpdateItemViewModel(),appState: AppState())
    }
}
