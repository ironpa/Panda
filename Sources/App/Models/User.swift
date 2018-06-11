//
//  User.swift
//  App
//
//  Created by Ireneusz Parysz on 11.06.2018.
//

import Foundation
import FluentPostgreSQL
import Vapor



struct User: PostgreSQLModel, Migration {
    var id: Int?
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
