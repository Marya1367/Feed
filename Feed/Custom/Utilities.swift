//
//  Utilities.swift
//  Feed
//
//  Created by Maryam Alimohammadi on 2/24/20.
//  Copyright © 2020 Maryam Alimohammadi. All rights reserved.
//

import UIKit

public func showError(msg:String){
    let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    if let vc = UIApplication.getTopViewController(){
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
}
