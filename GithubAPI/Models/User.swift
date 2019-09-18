//
//  User.swift
//  GithubAPI
//
//  Created by Van Le on 9/18/19.
//  Copyright © 2019 ITPS. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    
    var login: String = ""
    var avatar_url: String = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        login <- map["login"]
        avatar_url <- map["avatar_url"]
    }
}

class Users: Mappable {
    
    var items: [User] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        items <- map["items"]
    }
}
