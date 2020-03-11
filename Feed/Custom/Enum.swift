//
//  Enum.swift
//  Feed
//
//  Created by Maryam Alimohammadi on 2/24/20.
//  Copyright © 2020 Maryam Alimohammadi. All rights reserved.
//

import UIKit

//MARK: - define error types
enum APIError: Error{
    case missingData
    case decodeError
}


//MARK: - define deferent types for tiles

enum TileTypes: String{
    case image = "image"
    case video = "video"
    case website = "website"
    case shoppingList = "shopping_list"
    
}

//MARK: - viewControllers identifier
enum VCIDes: String{
    case imageVCID = "TileImageViewController"
    case webVCID = "WebViewViewController"
    case shippingVCID = "ShippingListViewController"
}
