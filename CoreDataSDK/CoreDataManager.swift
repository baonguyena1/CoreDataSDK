//
//  CoreDataManager.swift
//  CoreDataSDK
//
//  Created by Bao Nguyen on 23/12/2020.
//

import Foundation
import CoreData

public class CoreDataManager {
    private var coreDataContainer: CoreDataContainer!
    
    public var batchSize = 50
    
    public var context: NSManagedObjectContext {
        return coreDataContainer.mainContext
    }
    
    public init(momdName: String, bundle: Bundle) {
        coreDataContainer = CoreDataContainer(momdName: momdName, bundle: bundle)
    }
    
    public func fetchObjects<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: entity))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        request.fetchBatchSize = batchSize
        do {
            return try coreDataContainer.mainContext.fetch(request)
        } catch {
            print(error)
            return []
        }
    }
    
    public func fetchObject<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> T? {
        let request = NSFetchRequest<T>(entityName: String(describing: entity))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        request.fetchBatchSize = 1
        do {
            return try coreDataContainer.mainContext.fetch(request).first
        } catch {
            print(error)
            return nil
        }
    }
    
    public func delete(objects: [NSManagedObject]) {
        let context = coreDataContainer.mainContext
        objects.forEach { context.delete($0) }
    }
    
    public func save() {
        coreDataContainer.saveContext()
    }
    
    public func persist(synchronously: Bool = false, completion: ((Bool, Error?) -> Void)? = nil) {
        let mainContext = coreDataContainer.mainContext
        let privateContext = coreDataContainer.privateContext
        
        if mainContext.hasChanges {
            mainContext.performAndWait {
                do {
                    try mainContext.save()
                    completion?(true, nil)
                } catch {
                    if privateContext.hasChanges {
                        func savePrivateContext() {
                            do {
                                try privateContext.save()
                                completion?(true, nil)
                            } catch {
                                completion?(false, error)
                            }
                        }
                        
                        if synchronously {
                            privateContext.perform(savePrivateContext)
                        } else {
                            privateContext.performAndWait(savePrivateContext)
                        }
                    } else {
                        completion?(false, error)
                    }
                }
            }
        } else {
            completion?(false, nil)
        }
    }
}
