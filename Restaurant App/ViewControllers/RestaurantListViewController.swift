//
//  ViewController.swift
//  Restaurant App
//
//  Created by 吉村一揮 on 2021/01/23.
//

import UIKit
import Alamofire

//GPS

class RestaurantListViewController: UIViewController{
    
    //レストランのリスト
    @IBOutlet weak var restaurantListCollectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIButton!
    
    private var prevContentOffset: CGPoint = .init(x: 0, y: 0)
    private let headerMoveHeight: CGFloat = 7
    
    //プロパティ
    private let cellId = "cellId"
    private var shopItems = [ShopInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantListCollectionView.delegate = self
        restaurantListCollectionView.dataSource = self
        
        restaurantListCollectionView.register(UINib(nibName: "RestaurantListCell", bundle: nil),forCellWithReuseIdentifier: cellId)
        
        searchButton.addTarget(self, action: #selector(tappedSearchButton), for: .touchUpInside)
        
        fetchAPISerachInfo()
    }
    
    //search画面遷移
    @objc private func tappedSearchButton(){
        let searchController = SearchViewController()
        let nav = UINavigationController(rootViewController: searchController)
        self.present(nav, animated: true, completion: nil)
    }
    
    //API通信　仮置き
    private func fetchAPISerachInfo(){
        //ホットペッパーグルメリサーチAPIurl
        let urlString = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=7595749c2fcd061a&lat=34.67&lng=135.52&range=2&order=4&format=json"
                
                let request = AF.request(urlString)
                
                request.responseJSON { (response) in
                    do {
                        guard let data = response.data else { return }
                        let decode = JSONDecoder()
                        let restaurant = try decode.decode(Restaurant.self, from: data)
                        self.shopItems = restaurant.results.shop
                        self.restaurantListCollectionView.reloadData()
                    } catch {
                        print("変換に失敗しました。: ", error)
                    }
                }
    }
    
    //headerスクロール対応
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.prevContentOffset = scrollView.contentOffset
        }
        guard let presentIndexPath = restaurantListCollectionView.indexPathForItem(at: scrollView.contentOffset) else {return}
        if scrollView.contentOffset.y < 0 {return}
        if presentIndexPath.row >= shopItems.count - 2 {return}
        
        let alphaRatio = 1 / headerHeightConstraint.constant
        
        if self.prevContentOffset.y < scrollView.contentOffset.y {
            if headerTopConstraint.constant >= -headerHeightConstraint.constant{
                headerTopConstraint.constant -= headerMoveHeight
                headerView.alpha -= alphaRatio * headerMoveHeight
            }
        }else if self.prevContentOffset.y > scrollView.contentOffset.y {
            if headerTopConstraint.constant >= 0 {return}
            headerTopConstraint.constant += headerMoveHeight
            headerView.alpha += alphaRatio * headerMoveHeight
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            headerViewEndAnimation()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        headerViewEndAnimation()
    }
    
    private func headerViewEndAnimation() {
        if headerTopConstraint.constant < -headerHeightConstraint.constant / 2 {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations: {
                self.headerTopConstraint.constant = -self.headerHeightConstraint.constant
                self.headerView.alpha = 0
                self.view.layoutIfNeeded()
            })
        }else {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations: {
                self.headerTopConstraint.constant = 0
                self.headerView.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
    }
}
//API通信
extension RestaurantListViewController {
    
    private func fetchYoutubeSerachInfo() {
        //GPS
        
        let params = ["range": "1"]

        API.shared.request(params: params, type: Shop.self) { (shop) in
            self.shopItems = shop.shop
        }
    }
}

extension RestaurantListViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    //お店詳細画面への画面遷移
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let restaurantViewController = UIStoryboard(name: "Restaurant", bundle: nil).instantiateViewController(identifier: "RestaurantViewController") as RestaurantViewController
        //restaurantViewController.modalPresentationStyle = .fullScreen
        //情報の反映
        restaurantViewController.selectedItem = shopItems[indexPath.row]
        
        self.present(restaurantViewController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        
        return .init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = restaurantListCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RestaurantListCell
        cell.shopItems = shopItems[indexPath.row]
        
        return cell
    }
}
