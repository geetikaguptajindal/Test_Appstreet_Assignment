//
//  APIClient.swift
//  Geetika_Assignment
//
//  Created by geetikagupta on 22/08/20.
//  Copyright © 2020 geetikagupta. All rights reserved.
//

import Foundation

struct Resource {
    let url: URL
    let method: String = "GET"
}

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum APIClientError: Error {
    case noData
}

//https://pixabay.com/api/?key=18002629-cb98ce9abe0b3b48bd89d2c5b&q=yellow+flowers&image_type=photo&pretty=true&page=2

final class APIClient {
    //load data from a url
    func load(page:Int, searchKeyWord: String , result: @escaping ((Result<Data>) -> Void)) {
        var url = URLComponents(string: Constants.URLs.Pixabay_API)!
         
        var items = [URLQueryItem]()
        let param: [String : String] = ["q": searchKeyWord, "key":Constants.URLs.Pixabay_API_Key, "image_type":"photo", "page": "\(page)"]
        for (key,value) in param {
            if value.isEmpty == false {
                items.append(URLQueryItem(name: key, value: value))
            }
        }
        url.queryItems = items
        
        let request = URLRequest(url: (url.url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let `data` = data else {
                result(.failure(APIClientError.noData))
                return
            }
            if let `error` = error {
                result(.failure(error))
                return
            }
            // to resolve issue created as data was not decoding
            let utf8Data = String(decoding: data, as: UTF8.self).data(using: .utf8) ?? Data()
            result(.success(utf8Data))
        }
        task.resume()
    }
    
}
