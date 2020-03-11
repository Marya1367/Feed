//
//  CoreDataManagerTests.swift
//  FeedTests
//
//  Created by Maryam Alimohammadi on 2/19/20.
//  Copyright © 2020 Maryam Alimohammadi. All rights reserved.
//

import XCTest
import CoreData
@testable import Feed

class CoreDataManagerTests: XCTestCase {

    var coreDataManager: CoreDataManager!
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Feed", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false 
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
                                        
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    

    
    override func setUp() {
        super.setUp()
        initStubs()
        coreDataManager = CoreDataManager(container: mockPersistantContainer)
    }
    
    func initStubs() {

        func insertTileItem( name: String, headline: String, subline:String, data: String, score: NSNumber ) -> TileModel? {
            let obj = NSEntityDescription.insertNewObject(forEntityName: "TileModel", into: mockPersistantContainer.viewContext)

            obj.setValue("image", forKey: "name")
            obj.setValue("Tim Cook", forKey: "headline")
            obj.setValue("CEO of Apple Inc.", forKey: "subline")
            obj.setValue("data", forKey:"data")
            obj.setValue(1, forKey: "score")

            return obj as? TileModel
        }
        
        func insertShipping(title: String) -> ShippingModel? {
             let obj = NSEntityDescription.insertNewObject(forEntityName: "ShippingModel", into: mockPersistantContainer.viewContext)
            obj.setValue("First Shipping", forKey: "title")
            
            return obj as? ShippingModel
            
        }

         _ = insertTileItem(name: "image", headline: "Tim Cook", subline: "CEO of Apple Inc.", data: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Tim_Cook_2009_cropped.jpg/220px-Tim_Cook_2009_cropped.jp", score: 1)
          _ = insertTileItem(name: "image2", headline: "Tim Cook", subline: "CEO of Apple Inc.", data: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Tim_Cook_2009_cropped.jpg/220px-Tim_Cook_2009_cropped.jp", score: 1)
         _ = insertTileItem(name: "image3", headline: "Tim Cook", subline: "CEO of Apple Inc.", data: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Tim_Cook_2009_cropped.jpg/220px-Tim_Cook_2009_cropped.jp", score: 1)
       

        
        _ = insertShipping(title: "first Title")
         _ = insertShipping(title: "first Second")
        
        do {
            try mockPersistantContainer.viewContext.save()
        }  catch {
            print("create fakes error \(error)")
        }
            
    }
    
    func testFetchAllTiles() {
        let results = coreDataManager.fetchAllTiles()

        XCTAssertEqual(results.count, 3)
            
    }
    
    func testFetchAllShippings() {
        let results = coreDataManager.fetchAllShippings()

        XCTAssertEqual(results.count, 2)
            
    }
    func clearTileStorage() {
               
           let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "TileModel")
           let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
           for case let obj as NSManagedObject in objs {
               mockPersistantContainer.viewContext.delete(obj)
           }
           try! mockPersistantContainer.viewContext.save()

    }
    
    func clearShippingStorage() {
               
           let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "ShippingModel")
           let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
           for case let obj as NSManagedObject in objs {
               mockPersistantContainer.viewContext.delete(obj)
           }
           try! mockPersistantContainer.viewContext.save()

    }
    
    override func tearDown() {
       clearTileStorage()
    }

  

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
