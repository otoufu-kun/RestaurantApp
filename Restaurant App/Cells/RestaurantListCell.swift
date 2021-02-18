//
//  RestaurantListCell.swift
//  Restaurant App
//
//  Created by 吉村一揮 on 2021/01/23.
//

import UIKit
import Nuke

class RestaurantListCell: UICollectionViewCell {
    
    var shopItems: ShopInfo? {
        didSet {
            
            if let url = URL(string: shopItems?.photo.pc.l ?? "") {
                Nuke.loadImage(with: url, into: shopImageView)
            }
            
            shopNameLabel.text = shopItems?.name
            descriptionLabel.text = shopItems?.genre.catch
            shopGenreLabel.text = shopItems?.middle_area.name
            
        }
    }
    
    
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var shopGenreLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
}
