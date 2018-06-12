//
//  User.swift
//  App
//
//  Created by Ireneusz Parysz on 11.06.2018.
//

import Foundation
import FluentPostgreSQL
import Vapor
import Authentication



struct User: PostgreSQLModel, Migration {
    var id: Int?
    var email: String
    var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
extension User: BasicAuthenticatable{
    static var usernameKey: UsernameKey {
        return \User.email
    }
    
    static var passwordKey: PasswordKey {
        return \User.password
    }
}
extension User {
    struct AuthenticatedUser: Content{
        var email: String
        var id: Int
    }
    struct LoginRequest: Content{
        var email: String
        var password: String
    }
}
