//
//  CoreDataManager.swift
//  Feed
//
//  Created by Maryam Alimohammadi on 2/16/20.
//  Copyright © 2020 Maryam Alimohammadi. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer!
    static let sharedManager = CoreDataManager()
    
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
    }
    
    convenience init() {
        //Use the default container for production environment
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        self.init(container: appDelegate.persistentContainer)
    }
 
    public func getManagementContext() -> NSManagedObjectContext
    {
        
        return CoreDataManager.sharedManager.persistentContainer.viewContext
        
    }
    
    public func saveContext () -> Bool {
        let context = self.getManagementContext()
        if context.hasChanges {
            do {
                try context.save()
                let userDefault = UserDefaults.standard
                userDefault.set(Date(), forKey: "coreDataModifyDate")
                return true
            } catch {
                debugPrint("save context error : \(error)")
                return false
            }
            
            
        }
        return true
    }
    
    
    //MARK - Tile
    func insertTile( name: String, headline: String, subline:String, data: String, score: NSNumber ) -> TileModel? {
        guard let tileModel = NSEntityDescription.insertNewObject(forEntityName: "TileModel", into: getManagementContext()) as? TileModel else { return nil }
        tileModel.name = name
        tileModel.headline = headline
        tileModel.subline = subline
        tileModel.data = data
        tileModel.score = score
        
        return tileModel
    }
    
    private func updateCoreData() -> Bool
    {
        return CoreDataManager.sharedManager.saveContext()
    }
    
    public func fetchAllTiles() -> [TileModel] {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TileModel>(entityName: "TileModel")
        do {
            let tiles = try managedObjectContext.fetch(fetchRequest)
            return tiles
        } catch let error {
            print(error)
            return []
        }
    }
    
    
    
    func clearTileStorage() {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TileModel")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(batchDeleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    //MARK - Shipping
    
    func insertShipping(title: String ) -> ShippingModel? {
        guard let shippingModel = NSEntityDescription.insertNewObject(forEntityName: "ShippingModel", into: getManagementContext()) as? ShippingModel else { return nil }
        
        shippingModel.title = title
        let _ = CoreDataManager.sharedManager.saveContext()
        return shippingModel
    }
    
    func fetchAllShippings() -> [ShippingModel]{
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ShippingModel>(entityName: "ShippingModel")
        do {
            let shippings = try managedObjectContext.fetch(fetchRequest)
            return shippings
        } catch let error {
            print(error)
            return []
        }
    }
    
    func clearShippingStorage(){
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShippingModel")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(batchDeleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
}
