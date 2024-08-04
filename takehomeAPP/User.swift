//
//  User.swift
//  takehomeAPP
//
//  Created by Ajnur Bogucanin on 31. 7. 2024..
//

import Foundation


class User{
    
    //Vars
    private var id: Int
    private var username: String
    private var token: String
    private var refreshToken: String
    private var fistname:String
    
    //Util
    let util = Util()
    
    //Default Constructor
    init(){
        //Personal
        self.id = 0
        self.username = "Guest"
        self.fistname = "Guest"
        //Auth
        self.token = "None"
        self.refreshToken = "None"
        
    }
    
    //Json Constructor
    init(json: [String: Any]) {
        
        //Get data from json
        let id = json["id"] as? Int ?? 0
        let username = json["username"] as? String ?? "Guest"
        let token = json["token"] as? String ?? "None"
        let refreshToken = json["refreshToken"] as? String ?? "None"
        let firstname = json["firstName"] as? String ?? "Guest"
            
        //Store data
        self.id = id
        self.username = username
        self.fistname = firstname
        self.token = token
        self.refreshToken = refreshToken
        
    }
    
    //Acessors
    //Function that returns a username of a logged user
    public func getUsername()->String{
        return self.username
    }
    
    //Function that returns name of a logged user
    public func getFirstname()->String{
        return self.fistname
    }
}
