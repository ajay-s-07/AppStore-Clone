//
//  Service.swift
//  AppStore
//
//  Created by Ajay Sarkate on 04/07/23.
//

import Foundation

class Service {
    
    static let shared = Service() // singleton
    
    func fetchApps(searchTerm: String, completion: @escaping ([Result], Error?) -> ()) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion([], nil)
                return
            }
            guard let data = data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(searchResult.results, nil)
            } catch let jsonErr {
                completion([], jsonErr)
                print("Failed to decode: " , jsonErr)
            }
            
        }.resume()
    }
    
    func fetchGames(completion: @escaping (AppGroup?, Error?) -> ()) {
        
        let urlString =  "https://rss.applemarketingtools.com/api/v2/us/apps/top-free/50/apps.json"
        fetchAppGroup(urlString: urlString, completion: completion)
    }
    
    func fetchGames2(completion: @escaping (AppGroup?, Error?) -> ()) {
        
        let urlString =  "https://rss.applemarketingtools.com/api/v2/us/apps/top-paid/50/apps.json"
        fetchAppGroup(urlString: urlString, completion: completion)
    }
    
    func fetchAppGroup(urlString: String, completion: @escaping (AppGroup?, Error?) -> Void) {
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    
    func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> Void) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            
            do {
                let objects = try JSONDecoder().decode(T.self, from: data!)
                completion(objects, nil)
            } catch {
                completion(nil, error)
                print("Failed to decode: " , err)
            }
            
        }.resume()
    }
    
}

class Stack<T: Decodable> {
    var items = [T]()
    func push(item: T) { items.append(item)}
    func pop() -> T? { return items.last}
}

func dummy() {
    let stack = Stack<String>()
    stack.push(item: "Hello world")
    
    let stack2 = Stack<Int>()
    stack2.push(item: 1)
}
