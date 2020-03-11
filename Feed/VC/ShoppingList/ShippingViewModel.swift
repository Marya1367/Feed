//
//  ShippingViewModel.swift
//  Feed
//
//  Created by Maryam Alimohammadi on 2/24/20.
//  Copyright © 2020 Maryam Alimohammadi. All rights reserved.
//

import Foundation

final class ShippingViewModel{
    
    private var shippingArray : [ShippingModel] = []
    private let coreData = CoreDataManager.sharedManager
    
    public func fetchData() -> [ShippingModel]{
        return coreData.fetchAllShippings()
    }
    
    public func insertData(title: String){
         _ = coreData.insertShipping(title: title)
    }
}
