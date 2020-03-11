//
//  APIService.swift
//  Feed
//
//  Created by Maryam Alimohammadi on 2/14/20.
//  Copyright © 2020 Maryam Alimohammadi. All rights reserved.
//

import UIKit


struct APIService {
    
    static let shared = APIService()
    static let str = "https://firebasestorage.googleapis.com/v0/b/payback-test.appspot.com/o/feed.json?alt=media&token=0f3f9a33-39df-4ad2-b9df-add07796a0fa"
    let url = URL(string: str)
    var session = URLSession(configuration: .default)
    
    func request<T:Decodable>(completion: @escaping (Result<T, Error>) -> Void){
        
        guard let url = url else{
            fatalError()
        }
        session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {

            guard  error == nil else{
                completion(.failure(error!))
                return
            }
            
            guard let data = data else{
                completion(.failure(APIError.missingData))
                return
            }
            
            do{
                
                let decoder = JSONDecoder()
                decoder.userInfo[CodingUserInfoKey.managedObjectContext!] = CoreDataManager.sharedManager.getManagementContext()
                let model = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    let _ = CoreDataManager.sharedManager.saveContext()
                    completion(.success(model))
                }
            }catch{
                
                completion(.failure(APIError.decodeError))
            }
            }
        }.resume()
        
    }
    
    
}


