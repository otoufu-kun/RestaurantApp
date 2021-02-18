//
//  SearchViewController.swift
//  Restaurant App
//
//  Created by 吉村一揮 on 2021/02/17.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    private let restaurantCellId = "restaurantCellId"
    private var shopItems = [ShopInfo]()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "お店を検索"
        sb.delegate = self
        
        return sb
    }()
    
    lazy var restaurantCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews(){
        view.backgroundColor = .white
        
        navigationItem.titleView = searchBar
        navigationItem.titleView?.frame = searchBar.frame
        
        restaurantCollectionView.frame = self.view.frame
        self.view.addSubview(restaurantCollectionView)
        restaurantCollectionView.register(UINib(nibName: "RestaurantListCell", bundle: nil), forCellWithReuseIdentifier: restaurantCellId)
    }
    
}

//UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        //api通信を呼ぶ
        let searchText = searchBar.text ?? ""
        fetchAPISerachInfo(searchText: searchText)
    }
    
}
//UICollectionViewDelegate, UICollectionViewDataSource
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        return .init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = restaurantCollectionView.dequeueReusableCell(withReuseIdentifier: restaurantCellId, for: indexPath) as! RestaurantListCell
        cell.shopItems = shopItems[indexPath.row]
        return cell
    }
}

//API通信
extension SearchViewController {
    
    private func fetchAPISerachInfo(searchText: String) {
        let params = ["keyword": searchText]

        API.shared.request(params: params, type: Shop.self) { (shop) in
            self.restaurantCollectionView.reloadData()
        }
    }
}
