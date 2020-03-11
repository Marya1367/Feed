//
//  ViewController.swift
//  Feed
//
//  Created by Maryam Alimohammadi on 2/14/20.
//  Copyright © 2020 Maryam Alimohammadi. All rights reserved.
//

import UIKit
import AVKit

class TileListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    private var dataSource: TableViewDataSource<TileModel, TileTableViewCell>!
    private var viewModel = TileViewMode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        getData()
        
    }
    
    private func configView(){
        title = "Tiles"
        tableView.backgroundColor = #colorLiteral(red: 0.8931308389, green: 0.920907259, blue: 0.9666106105, alpha: 1)
        tableView.register(UINib(nibName: TileTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: TileTableViewCell.reuseIdentifier)
    }
    
    private func getData(){
        viewModel.fetchData { [weak self] in
            if let error = self?.viewModel.error{
                showError(msg:error)
            }
            self?.dataSource = TableViewDataSource.make(tiles: (self?.viewModel.tilesArray) ?? [])
            self?.tableView.dataSource = self?.dataSource
            self?.tableView.reloadData()
            }
        
    }
    
}

//MARK: Table Delegate
extension TileListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = viewModel.getCellType(index: indexPath.row) else{
            return
        }
        
        let data: String = viewModel.getTileData(index: indexPath.row) ?? ""
        let headline = viewModel.getTileHeadLine(index: indexPath.row)
        
        switch type {
        case .image:
            showImage(with: data, headline: headline)
        case .video:
            showVideo(with: data)
        case .website:
            showWebView(with: data, headline: headline)
        case .shoppingList:
            showShippingListView()
        }
    }
    
    //MARK: - Load Image view
    private func showImage(with url: String, headline: String?){
        let vc = storyboard?.instantiateViewController(withIdentifier: VCIDes.imageVCID.rawValue) as! TileImageViewController
        vc.imageSource = url
        vc.titleName = headline
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Load Video view
    private func showVideo(with url: String){
        guard let url = URL(string: url) else{
            return
        }
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        present(playerViewController, animated: true) {
            player.play()
        }
    }
    
    //MARK: - Load Webview
    private func showWebView(with url: String, headline: String?){
        let vc = storyboard?.instantiateViewController(withIdentifier: VCIDes.webVCID.rawValue) as! WebViewViewController
        vc.videoSource = url
        vc.titleName = headline
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK: - Load Shipping List view
    
    private func showShippingListView(){
        let vc = storyboard?.instantiateViewController(withIdentifier: VCIDes.shippingVCID.rawValue) as! ShippingListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: Table Data Source
extension TableViewDataSource where T == TileModel, Cell == TileTableViewCell  {
    
    static func make(tiles: [TileModel]) -> TableViewDataSource {
        return TableViewDataSource(
            models: tiles
        ) { (model , cell)  in
            cell.cellConfiguration(model: model)
        }
    }
    
}
