//
//  CoreDataController.swift
//  SickSangHae
//
//  Created by user on 2023/07/13.
//

import CoreData
import Foundation

struct PersistentController {
    static let shared = PersistentController()
    let container = NSPersistentContainer(name: "SickSangHaeModel")
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    init() {
        container.loadPersistentStores { description, error in
            if let error {
                print("코어데이터 로딩 실패")
                print(error.localizedDescription)
            }
        }
    }
}

extension NSManagedObjectContext {
    func get(by objectID: NSManagedObjectID) -> Receipt? {
        do {
            guard let result = try self.existingObject(with: objectID) as? Receipt else {
                print("Get 한 object 변환 실패")
                return nil
            }
            print(result)
            return result
        } catch {
            print("해당하는 object 찾는거 실패")
            return nil
        }
    }
    
    func delete(by object: Receipt) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Receipt")
        request.predicate = NSPredicate(format: "id == %@", object.id.uuidString)
        do {
            let results = (try fetch(request) as? [NSManagedObject]) ?? [NSManagedObject]()
            results.forEach {
                print($0)
                self.delete($0)
            }
        } catch {
            print("CoreData 에서 삭제 실패함!!!\n")
        }
        
        self.saveContext()
    }
    
    func saveContext() {
        do {
            if self.hasChanges {
                try save()
            }
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
