//
//  Database.swift
//  Geetika_Assignment
//
//  Created by geetikagupta on 22/08/20.
//  Copyright © 2020 geetikagupta. All rights reserved.
//

import Foundation
import CoreData
import UIKit
    
final class Database {
    
    // MARK:- variable
    lazy var context = Database.sharedInstance.persistentContainer.viewContext

    // MARK:- Shared Instance
    static let sharedInstance = Database()

    private init () {}
    

   // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Geetika_Assignment")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // save data into context
    func save(object: [String: String]) {
        
        if let dataContext = NSEntityDescription.insertNewObject(forEntityName: "SearchText", into: context) as? SearchText {
            dataContext.text = object ["text"]
            Database.sharedInstance.saveContext()
        }
    }
    
    //fetch request for any type entity
    func getData<T: NSManagedObject> (_ objectType: T.Type) -> [T] {
        
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName) //used to retrieve data from persistence store
        
        var searchText =  [T]()
        do {
            searchText = try context.fetch(fetchRequest) as! [T]//context.fetch(Student.fetchRequest())
        } catch  {
            print ("error")
        }
        
        print(searchText.count)
        return searchText
    }
    
    //delete data from context
    func deleteFirstData () {
        let searchTexts =  getData(SearchText.self)
        if searchTexts.count > 10 {
            context.delete(searchTexts[0])
            Database.sharedInstance.saveContext()
        }
   }
}
