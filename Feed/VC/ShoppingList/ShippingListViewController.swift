//
//  ShippingListViewController.swift
//  Feed
//
//  Created by Maryam Alimohammadi on 2/24/20.
//  Copyright © 2020 Maryam Alimohammadi. All rights reserved.
//

import UIKit

class ShippingListViewController: UIViewController, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    private var dataSource: TableViewDataSource<ShippingModel, UITableViewCell>!
    
    var viewModel = ShippingViewModel()
    
    @IBAction func addShipping(_ sender: UIButton) {
        if let text = inputTextField.text {
            inputTextField.text = ""
            viewModel.insertData(title: text )
            reloadTableView()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        reloadTableView()
    }
    
    private func configView(){
        title = "Shipping List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        
    }
    
    private func reloadTableView(){
        let shippingArray = viewModel.fetchData()
        self.dataSource = TableViewDataSource.make(titles:shippingArray)
        self.tableView.dataSource = self.dataSource
        self.tableView.reloadData()
    }
    
    
}

//MARK: - tableView Data source

extension TableViewDataSource where T == ShippingModel, Cell == UITableViewCell{
    static func make(titles:[ShippingModel]) -> TableViewDataSource{
        return TableViewDataSource(
            models: titles
        ) { (model , cell)  in
            cell.textLabel?.text = model.title
        }
    }
}
