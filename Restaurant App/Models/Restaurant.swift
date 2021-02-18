//
//  Restaurant.swift
//  Restaurant App
//
//  Created by 吉村一揮 on 2021/02/12.
//

import Foundation

class Restaurant: Decodable {
    
    let results: Shop

}
class Shop: Decodable {
    
    let shop: [ShopInfo]

}

class ShopInfo: Decodable {
    let open: String
    let access: String
    let name: String
    let address: String
    let middle_area: Area
    let genre: Genre
    let budget: Price
    let photo: Photo
}
class Genre: Decodable{
    
    let `catch`: String
    
}

class Area: Decodable {
    
    let name: String //エリア

}

class Price: Decodable {
    
    let average: String
    
}

class Photo: Decodable {
    
    let pc: Pc
    
}
class Pc: Decodable {
    
    let l: String
    
}
