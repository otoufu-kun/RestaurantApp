//
//  RestaurantViewController.swift
//  Restaurant App
//
//  Created by 吉村一揮 on 2021/02/16.
//

import UIKit
import Nuke

class RestaurantViewController: UIViewController{
    
    var selectedItem: ShopInfo?
    
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopDescriptionLabel: UILabel!
    @IBOutlet weak var shopAddressLabel: UILabel!
    @IBOutlet weak var shopTimeLabel: UILabel!
    @IBOutlet weak var shopBugetAverageLabel: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupView()
    }
    private func setupView(){
        if let url = URL(string: selectedItem?.photo.pc.l ?? "") {
            Nuke.loadImage(with: url, into: shopImageView)
        }
        shopNameLabel.text = selectedItem?.name
        shopDescriptionLabel.text = selectedItem?.genre.catch
        shopAddressLabel.text = selectedItem?.address
        shopTimeLabel.text = selectedItem?.open
        shopBugetAverageLabel.text = selectedItem?.budget.average
    }
}

