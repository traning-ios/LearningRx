//
//  UserModel.swift
//  SearchName
//
//  Created by quynhlx on 2019/11/03.
//  Copyright © 2019 quynhlx. All rights reserved.
//

import Foundation

struct UserModel {
    var userName : String!
    var id : Int!
    
    init() {
        self.userName = ""
        self.id = 0
    }
    
    init(object: AnyObject) {
        guard let dic = object as? Dictionary<String, AnyObject> else {
            self.userName = ""
            self.id = 0
            return
        }
        
        self.userName = dic["login"] as? String ?? ""
        self.id = dic["id"] as? Int ?? 0
    }
    
}
