//
//  Recepie.swift
//  takehomeAPP
//
//  Created by Ajnur Bogucanin on 3. 8. 2024..
//

import Foundation

class Recipe{
    //VARS
    public var name:String=""
    public var tags:[String]=[]
    
    //Json Constructor
    init(json: [String: Any]) {
        
        let name = json["name"] as? String ?? "No Recipe"
        let tags = json["tags"] as? [String] ?? []
            
        self.name = name
        self.tags = tags
        
    }
}
