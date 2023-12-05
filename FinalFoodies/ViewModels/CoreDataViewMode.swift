//
//  CoreDataViewMode.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 10/7/23.
//
import CoreData

protocol CoreDataManaging {
    var context: NSManagedObjectContext { get }
    func saveContext()
    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) -> [T]
    func delete(_ object: NSManagedObject)
}

class CoreDataManger: CoreDataManaging {
    private var persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) -> [T] {
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch items: \(error)")
            return []
        }
    }
    
    func delete(_ object: NSManagedObject) {
        context.delete(object)
        saveContext()
    }
}
