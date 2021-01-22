//
//  ViewController.swift
//  Restaurant App
//
//  Created by 吉村一揮 on 2021/01/23.
//

import UIKit

class ViewController: UIViewController{
    
    //レストランのリスト
    @IBOutlet weak var restaurantListCollectionView: UICollectionView!
    
    //プロパティ
    private let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantListCollectionView.backgroundColor = .red
        restaurantListCollectionView.delegate = self
        restaurantListCollectionView.dataSource = self
        
        restaurantListCollectionView.register(UICollectionViewCell.self,forCellWithReuseIdentifier: cellId)
        // Do any additional setup after loading the view.
    }


}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        return .init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = restaurantListCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        cell.backgroundColor = .green
        return cell
    }
    
    
}
