//
//  TileViewModel.swift
//  Feed
//
//  Created by Maryam Alimohammadi on 2/16/20.
//  Copyright © 2020 Maryam Alimohammadi. All rights reserved.
//

import Foundation

final class TileViewMode {
    
    public var tilesArray: [TileModel] = []
    public var error : String?
    private var coreData = CoreDataManager.sharedManager
    
    public func fetchData(completion: @escaping () -> Void)
        
    {
        if !isTimeToLoad() {
            tilesArray = coreData.fetchAllTiles().sorted(by: { $0.getScore() > $1.getScore()})
            completion()
        }else{
            APIService.shared.request() { [weak self] (result: Result<TileResponseModel, Error>) in
                switch result{
                case .success(let tilesArray):
                    self?.tilesArray = tilesArray.tiles.sorted(by: { $0.getScore() > $1.getScore()})
                case . failure(let error):
                    self?.error = error.localizedDescription
                }
                
                completion()
                
               
            }
        }
    }
    
    
    
    public func getCellType(index: Int) -> TileTypes?{
        let model = tilesArray[index]
        guard let name = model.name else {
            return nil
        }
        switch name {
        case TileTypes.image.rawValue :
            return .image
        case TileTypes.video.rawValue :
            return .video
        case TileTypes.website.rawValue :
            return .website
        case TileTypes.shoppingList.rawValue :
            return .shoppingList
        default:
            return nil
        }
    }
    
    public func getTileData(index: Int) -> String?{
        let model = tilesArray[index]
        return model.data
    }
    
    public func getTileHeadLine(index: Int) -> String?{
        let model = tilesArray[index]
        return model.headline
    }
    
    private func isTimeToLoad() -> Bool{
        
        let userDefault = UserDefaults.standard
        
        guard let date = userDefault.value(forKey: "coreDataModifyDate") as? Date else{
            return true
        }
        
        if let diff = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour, diff > 24 {
            return true
        }
        
        if coreData.fetchAllTiles().count == 0 {
            return true
        }
        
        return false
        
    }
    
}



