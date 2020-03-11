//
//  TileModel.swift
//  Feed
//
//  Created by Maryam Alimohammadi on 2/16/20.
//  Copyright © 2020 Maryam Alimohammadi. All rights reserved.
//

import Foundation
import CoreData

@objc(TileModel)
final class TileModel: NSManagedObject, Decodable{
    
    @NSManaged var name : String?
    @NSManaged var headline : String?
    @NSManaged var subline : String?
    @NSManaged var data : String?
    @NSManaged var score : NSNumber?
    
    enum CodingKeys: String, CodingKey{
        case name
        case headline
        case subline
        case data
        case score
    }
    
    required convenience init(from decoder: Decoder) throws {

        guard let contextUserInfoKey = CodingUserInfoKey.managedObjectContext else {
            fatalError()
        }

        guard let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,let entity = NSEntityDescription.entity(forEntityName: "TileModel", in: managedObjectContext) else {
            fatalError()
            
        }

        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.headline = try container.decodeIfPresent(String.self, forKey: .headline)
        self.subline = try container.decodeIfPresent(String.self, forKey: .subline)
        self.data = try container.decodeIfPresent(String.self, forKey: .data)
        self.score = try container.decodeIfPresent(Int.self, forKey: .score) as NSNumber?
        
        
    }
    
    
    public func getScore() -> Int{
        return Int(truncating: self.score ?? 0)
    }
    
}




