//
//  OpenWeatherTestApp
//
// Created by Vlad Shchuka on 2024, All rights reserved.
//

import Foundation
import CoreData

public struct ManagedObjectContextObserverChangeInfo<T> {

   public let inserted: [T]
   public let updated: [T]
   public let deleted: [T]

   public init(inserted: [T], updated: [T], deleted: [T]) {
      self.inserted = inserted
      self.updated = updated
      self.deleted = deleted
   }

   public var isEmpty: Bool {
      return inserted.isEmpty && updated.isEmpty && deleted.isEmpty
   }
}

public class ManagedObjectContextObserver<T: NSManagedObject> {

   public var predicate: NSPredicate?
   public var onContextChanged: ((ManagedObjectContextObserverChangeInfo<T>) -> Void)?
   private let notificationName = Notification.Name.NSManagedObjectContextDidSave
   private var observer: NSObjectProtocol!
   private weak var context: NSManagedObjectContext?

   public init(context: NSManagedObjectContext) {
      let nc = NotificationCenter.default
      observer = nc.addObserver(forName: notificationName, object: context, queue: nil) { [weak self] note in
         let insertedAll = ((note.userInfo?[NSInsertedObjectsKey] as? NSSet)?.allObjects as? [NSManagedObject]) ?? []
         let updatedAll = ((note.userInfo?[NSUpdatedObjectsKey] as? NSSet)?.allObjects as? [NSManagedObject]) ?? []
         let deletedAll = ((note.userInfo?[NSDeletedObjectsKey] as? NSSet)?.allObjects as? [NSManagedObject]) ?? []
         var inserted = ((insertedAll.filter { $0 is T }) as? [T]) ?? []
         var updated = ((updatedAll.filter { $0 is T }) as? [T]) ?? []
         var deleted = ((deletedAll.filter { $0 is T }) as? [T]) ?? []
         if let predicate = self?.predicate {
            inserted = inserted.filter { predicate.evaluate(with: $0) }
            updated = updated.filter { predicate.evaluate(with: $0) }
            deleted = deleted.filter { predicate.evaluate(with: $0) }
         }
         let info = ManagedObjectContextObserverChangeInfo(inserted: inserted, updated: updated, deleted: deleted)
         if !info.isEmpty {
            self?.onContextChanged?(info)
         }
      }
      self.context = context
   }

   deinit {
       if let observer {
           NotificationCenter.default.removeObserver(observer, name: notificationName, object: context)
       }
   }
}

