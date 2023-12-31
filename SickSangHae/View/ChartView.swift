//
//  ChartView.swift
//  SickSangHae
//
//  Created by 최효원 on 2023/07/06.
//

import SwiftUI

struct ChartView: View {
    @State private var selectedDate = Date()
    @State private var wholeCost: Double = 1
    @State private var spoiledCost: Double = 1
    @State private var eatenCost: Double = 1
    @State private var slices = [(2.0, Color("PrimaryGB")), (1.0, Color("Gray200"))]

    @EnvironmentObject var coreDataViewModel: CoreDataViewModel

    var body: some View {
        
        Spacer()
            .frame(height: 32.adjusted)

        HStack(alignment: .top){
            Text("식통계")
                .font(.pretendard(.bold, size: 28.adjusted))
                .foregroundColor( Color("PrimaryGB"))

            Spacer()

        }
        .padding(.horizontal, 20.adjusted)
        
        ScrollView{
            VStack(alignment: .center){


                Spacer()
                    .frame(height: 26.adjusted)

                HStack(alignment: .center) {
                    Button(action: {
                        // Go to the previous month
                        selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.gray900)
                    }

                    Text("\(selectedDate.formattedMonth)월")
                        .font(.pretendard(.bold, size: 22.adjusted))
                        .foregroundColor(Color("Gray900"))
                        .padding(.horizontal, 12.adjusted)

                    Button(action: {
                        // Go to the next month
                        if( selectedDate.formattedMonth != getCurrentMonth()){
                            selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(selectedDate.formattedMonth == getCurrentMonth() ? Color("Gray200") : Color("Gray900") )
                    }
                }

                Spacer()
                    .frame(height: 41.adjusted)

                Pie
                .frame(width: 200.adjusted)

                summaryList
                    .padding(.horizontal, 20.adjusted)
                    .padding(.vertical, 38.adjusted)

                // MARK: 디자인에서 이 부분 변경 사항이 있으면 주석을 해제하고 작업 할 것.
//                Group{
//                    Rectangle()
//                        .foregroundColor(.clear)
//                        .frame(width: screenWidth, height: 12.adjusted)
//                        .background(Color("Gray100"))
//
//                    ListTitle(title: "잘 먹은 BEST3")
//                    ListContents(data: data)
//
//                    ListTitle(title: "못 먹은 WORST3")
//                    ListContents(data: data)
//                }
            }
            .onChange(of: selectedDate){ newDate in
                calculateCosts(for: newDate)
            }
        }
    }

    private var Pie : some View {
            Canvas { context, size in
                let donut = Path { p in
                    let donutSize = CGSize(width: size.width * 0.3, height: size.height * 0.3) // Reduce the size by 0.8
                                p.addEllipse(in: CGRect(origin: .zero, size: size))
                                p.addEllipse(in: CGRect(x: (size.width - donutSize.width) / 2,
                                                        y: (size.height - donutSize.height) / 2,
                                                        width: donutSize.width, height: donutSize.height))
                }
                context.clip(to: donut, style: .init(eoFill: true))

                let total = slices.reduce(0) { $0 + $1.0 }
                context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
                var pieContext = context
                pieContext.rotate(by: .degrees(-90))
                let radius = min(size.width, size.height) * 0.48
                var startAngle = Angle.zero
                for (value, color) in slices {
                    let angle = Angle(degrees: 360 * (value / total))
                    let endAngle = startAngle + angle


                    let path = Path { p in
                        p.move(to: .zero)
                        p.addArc(center: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                        p.closeSubpath()
                    }
                    pieContext.fill(path, with: .color(color))

                    startAngle = endAngle
                }

            }
            .onChange(of: selectedDate){ _ in
                calculateCosts(for: selectedDate)
            }
            .onAppear(){
                calculateCosts(for: selectedDate)
            }
            .aspectRatio(1, contentMode: .fit)
        }

    private func calculateCosts(for date: Date) {
        let month = date.formattedMonth
        var newWholeCost: Double = 0
        var newSpoiledCost: Double = 0
        var newEatenCost: Double = 0

        for item in coreDataViewModel.receipts {
            let newWholeMonth = item.dateOfPurchase.formattedMonth
            if newWholeMonth == month{
                newWholeCost += item.price
            }
        }

        for item in coreDataViewModel.eatenDictionary {
            let eatenMonth = Date().extractMonthNumber(from: item.key) ?? "0"
            if eatenMonth == month{
                for k in item.value{
                    newEatenCost += k.price
                }
            }
        }

        for item in coreDataViewModel.spoiledDictionary {
            let eatenMonth = Date().extractMonthNumber(from: item.key) ?? "0"
            if eatenMonth == month{
                for k in item.value{
                    newSpoiledCost += k.price
                }
            }
        }

        spoiledCost = newSpoiledCost
        eatenCost = newEatenCost
        wholeCost = newWholeCost

        if spoiledCost == 0, eatenCost == 0{
            slices = [(0, Color("PrimaryGB")),
                      (1, Color("Gray200"))]
        }
        else{
            slices = [(spoiledCost, Color("PrimaryGB")),
                      (wholeCost - spoiledCost, Color("Gray200"))]
        }
    }

    private func ListTitle(title: String) -> some View{
        HStack {
            Text(title)
                .foregroundColor(Color("Gray900"))
                .font(.pretendard(.semiBold, size: 20.adjusted))

            Spacer()
        }
        .padding([.top, .bottom], 17.adjusted)
        .padding([.leading, .trailing], 20.adjusted)

    }

    private func ListContents(data: Array<String>) -> some View{
        ForEach(data, id:\.self) { item in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("")
                        .foregroundColor(.clear)

                    Image(systemName: "circle.fill")
                        .resizable()
                        .foregroundColor(Color("Gray200"))
                        .frame(width: 36.adjusted, height: 36.adjusted)

                    Spacer()
                        .frame(width: 12.adjusted)

                    Text(item)
                        .font(.pretendard(.semiBold, size: 17.adjusted))
                        .foregroundColor(Color("Gray900"))

                    Spacer()

                    Text("x회")
                        .foregroundColor(Color("Gray900"))
                        .font(.pretendard(.semiBold, size: 14.adjusted))
                        .padding(.trailing, 20.adjusted)
                }
                .padding([.top, .bottom], 8.adjusted)
            }

            Divider()
                .overlay(Color("Gray100"))
                .opacity(item == data.last ? 0 : 1)
        }
        .padding([.leading], 20.adjusted)

    }

    private var summaryList: some View{
        VStack(spacing: 15.adjusted){
            HStack{
                Text("전체")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundColor(Color("Gray900"))
                Spacer()
                Text("\(Int(wholeCost))원")
                    .font(.pretendard(.bold, size: 22))
                    .foregroundColor(Color("Gray900"))
            }
            HStack{
                Text("잘 먹은 금액")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundColor(Color("Gray900"))
                Spacer()
                Text("\(Int(eatenCost))원")
                    .font(.pretendard(.bold, size: 22))
                    .foregroundColor(Color("Gray900"))
            }
            HStack{
                Text("낭비된 금액")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundColor(Color("Gray900"))
                Spacer()
                Text("\(Int(spoiledCost))원")
                    .font(.pretendard(.bold, size: 22))
                    .foregroundColor(Color("PrimaryGB"))
            }
        }
    }


    func getCurrentMonth() -> String {
           return String(Calendar.current.component(.month, from: Date()))
       }
}

private struct BasicListTitle: View {

    let title: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(Color("Gray900"))
                .font(.pretendard(.semiBold, size: 20.adjusted))

            Spacer()

            Button {

            } label: {
                HStack(spacing: 2.adjusted) {
                    Text("최신순")
                        .foregroundColor(Color("Gray600"))
                    Image(systemName: "arrow.up.arrow.down")
                }
            }
            .foregroundColor(Color("Gray600"))
            .font(.pretendard(.regular, size: 14.adjusted))
            .padding(.trailing, 20.adjusted)
        }
        .padding([.top, .bottom], 17.adjusted)
        .padding([.leading], 20.adjusted)
    }
}



struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}


