//
//  OpenWeatherTestApp
//
// Created by Vlad Shchuka on 2024, All rights reserved.
//

import Foundation
import CoreData

class CoreDataProvider {
    private init() {}
    static let current = CoreDataProvider()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "OpenWeatherTestApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataProvider {
    struct Sort {
        let key: String
        let ascending: Bool
    }
    
    struct Filter {
        let key, value: String
    }
    
    struct DateRange {
        let toDate, fromDate: Date
    }
}

extension CoreDataProvider {
    func getNewEntityby<T>() -> T? where T : NSManagedObject {
        let context = persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: T.description(), in: context) else { return nil }
        let newOrder = NSManagedObject(entity: entity, insertInto: context)
        return (newOrder as? T)
    }
    
    func getEntitiesListby<T>(filter: Filter? = nil, dateRange: DateRange? = nil, sort: Sort? = nil) -> [T]? where T : NSManagedObject {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.description())
        request.returnsObjectsAsFaults = false
        if let filter {
            request.predicate = NSPredicate(format: "\(filter.key) = %@", filter.value)
        } else if let dateRange {
            request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", dateRange.fromDate as NSDate, dateRange.toDate as NSDate)
        }
        if let sort {
            request.sortDescriptors = [NSSortDescriptor(key: sort.key, ascending: sort.ascending)]
        }
        do {
            let result = try context.fetch(request)
            guard let orders = result as? [T] else { return nil }
            return orders
        } catch {
            return nil
        }
    }
    
    func getEntetiesBy<T: NSManagedObject>(filter: Filter? = nil, dateRange: DateRange? = nil, sort: Sort? = nil, completion: ([T]?) -> Void) {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.description())
        request.returnsObjectsAsFaults = false
        if let filter {
            request.predicate = NSPredicate(format: "\(filter.key) = %@", filter.value)
        } else if let dateRange {
            request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", dateRange.fromDate as NSDate, dateRange.toDate as NSDate)
        }
        if let sort {
            request.sortDescriptors = [NSSortDescriptor(key: sort.key, ascending: sort.ascending)]
        }
        context.performAndWait {
            do {
                let result = try context.fetch(request)
                guard let enteties = result as? [T] else { return completion(nil) }
                completion(enteties)
            } catch {
                completion(nil)
            }
        }
    }
    
    func delete(_ entity: NSManagedObject) {
        let context = persistentContainer.viewContext
        context.performAndWait {
            context.delete(entity)
            self.saveContext()
        }
    }
}
