//
//  UserViewModel.swift
//  SearchName
//
//  Created by quynhlx on 2019/11/03.
//  Copyright © 2019 quynhlx. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class UserViewModel: NSObject {
    var searchInput = BehaviorRelay<String?>(value: "")
    var searchResult = BehaviorRelay<[UserModel]>(value: [])
    let disposeBag = DisposeBag()
    override init() {
        super.init()
        bindingData()
    }
    
    func bindingData() {
        self.searchInput.asObservable().subscribe(onNext: { (text) in
            if text!.isEmpty {
                var value = self.searchResult.value
                value.removeAll()
                self.searchResult.accept(value)
            } else {
                self.requestData(keyword: text!)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func requestData(keyword: String) {
        let urlString = "https://api.github.com/search/users?q=\(keyword)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    
        guard let url = URL(string: urlString)
            else {
                return
        }
        
        let session = URLSession.shared
        session.dataTask(with: url) {(data, res, error) in
            if error == nil {
                do {
                    guard let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as?  Dictionary<String, AnyObject> else {
                        return
                    }                   
                    guard let items = result["items"] as? Array<AnyObject> else {
                        print("exits = \(result)")
                        return
                    }
                    var users :Array<UserModel> = []
                    
                    for item in items {
                        let user = UserModel(object: item)
                        users.append(user)
                    }
                    
                    if users.count == 0 {
                        var value = self.searchResult.value
                        value.removeAll()
                        self.searchResult.accept(value)
                    } else {
                        self.searchResult.accept(users)
                    }
                    print("count = \(users.count)")
                } catch {
                    
                }
            }
            
        }.resume()
    }
}

