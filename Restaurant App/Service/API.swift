//
//  API.swift
//  Restaurant App
//
//  Created by 吉村一揮 on 2021/02/18.
//

import Foundation
import Alamofire

class API {
    
    static let shared = API()
    
    private let baseUrl = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/"
    
    
    func request<T: Decodable>( params: [String: Any], type: T.Type, completion: @escaping (T) -> Void) {
        let url = baseUrl + "?"
        
        var params = params
        // GCPで設定済みのkeyを入力
        params["key"] = "7595749c2fcd061a"
        params["format"] = "json"
        
        let request = AF.request(url, method: .get, parameters: params)
        
        request.responseJSON { (response) in
            guard let statusCode = response.response?.statusCode else { return }
            if statusCode <= 300 {
                do {
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    let value = try decoder.decode(T.self, from: data)
                    
                    completion(value)
                } catch {
                    print("変換に失敗しました。: ", error)
                }
            }

        }
    }
    
    
}
