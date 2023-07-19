//
//  ReceiptViewModel.swift
//  SickSangHae
//
//  Created by user on 2023/07/15.
//

import CoreData
import Foundation

class CoreDataViewModel: ObservableObject {
    private let viewContext = PersistentController.shared.viewContext
    @Published var receipts: [Receipt] = []
    
    init() {
        getAllReceiptData()
    }
    
    
}

extension CoreDataViewModel {
    func getAllReceiptData() {
        let request = NSFetchRequest<Receipt>(entityName: "Receipt")
        
        do {
            receipts = try viewContext.fetch(request)
        } catch {
            print("Cannot fetch receipts from SickSangHae Model")
        }
    }
    
    
    func saveChanges() {
        do {
            try viewContext.save()
        } catch {
            print("Error while Saving in CoreData")
        }
    }
    
    func createReceiptData() {
        
        let receipt = Receipt(context: viewContext)
        receipt.id = UUID()
        receipt.name = "TestName"
        receipt.dateOfPurchase = Date.now
        receipt.fastEatPin = false
        receipt.icon = "icon_test"
        receipt.price = 6000.0
        receipt.state = Status.UnConsumed.rawValue
        
        saveChanges()
        self.getAllReceiptData()
    }
    
    func deleteReceiptData(target: Receipt) {
        viewContext.delete(by: target)
        getAllReceiptData()
    }
    
    func updateReceiptStateData(target: Receipt, state: Status) {
        guard let receipt = viewContext.get(by: target.objectID) else { return }
        receipt.state = state.rawValue
        
        viewContext.saveContext()
        getAllReceiptData()
    }
}
