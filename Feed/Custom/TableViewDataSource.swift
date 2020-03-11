//
//  TableViewDataSource.swift
//  Feed
//
//  Created by Maryam Alimohammadi on 2/16/20.
//  Copyright © 2020 Maryam Alimohammadi. All rights reserved.
//

import UIKit

class TableViewDataSource<T, Cell: UITableViewCell> : NSObject, UITableViewDataSource, UITableViewDelegate {
    
    typealias CellConfigurator = (T, Cell) -> Void
    var models: [T] = []
    
    private var cellConfigurator: CellConfigurator
    
    init(models: [T], cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.cellConfigurator = cellConfigurator
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
        cellConfigurator(model, cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
   
}






