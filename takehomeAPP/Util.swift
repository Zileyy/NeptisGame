//
//  Util.swift
//  takehomeAPP
//
//  Created by Ajnur Bogucanin on 29. 7. 2024..
//
//  File made for tools (functions) that are going to be called from here for better readability.

//IMPORTS
import Foundation
import SwiftUI

//I made this comment just because it looked ugly without it
public class Util {
    
    //Function that checks if String is empty and for alerting user on empty fields
    func fieldsEmpty(fields : [String]) -> Bool{
        //Checking all fields for empty ones
        for field in fields{
            if( field == ""){return true}
        }
        return false
    }
    
    //Function made for processing API requests (hopefully universal)
    func sendRequest(to urlString: String, with payload: [String: Any], method method_:String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // URL check
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 1, userInfo: nil)))
            return
        }
        
        // POST request
        var request = URLRequest(url: url)
        request.httpMethod = method_
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Set the HTTP body if needed
        do {
            if(method_ == "POST"){
                request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
            }else{
                request.httpBody = nil
            }
        } catch {
            completion(.failure(error))
            return
        }
        
        //Execute the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 2, userInfo: nil)))
                return
            }
            
            //Parse JSON
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(json))
                } else {
                    completion(.failure(NSError(domain: "Invalid JSON format", code: 3, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    //Function for fetching all usernames for opponent list
    func fetchUsernames(completion: @escaping ([String]?, Error?) -> Void) {
        //VARS
        let urlString = "https://dummyjson.com/users"
        let payload: [String: Any] = [:]

        //Send the request
        sendRequest(to: urlString, with: payload, method:"GET") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    //Extract usernames
                    if let users = json["users"] as? [[String: Any]] {
                        let usernames = users.compactMap { $0["username"] as? String }
                        completion(usernames, nil)
                    } else {
                        completion(nil, NSError(domain: "Invalid JSON structure", code: 4, userInfo: nil))
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    //Function that fetches recipe names and tags
    func fetchRecipes(completion: @escaping ([String]?, [[String]]?, Error?) -> Void) {
        //URL for fetching recipes
        let urlString = "https://dummyjson.com/recipes"
        let payload: [String: Any] = [:]

        //Send the request
        sendRequest(to: urlString, with: payload, method: "GET") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    //Extract recipe names and tags
                    if let recipes = json["recipes"] as? [[String: Any]] {
                        var recipeNames: [String] = []
                        var recipeTags: [[String]] = []
                        
                        //Append them to the lists
                        for recipe in recipes {
                            if let name = recipe["name"] as? String {
                                recipeNames.append(name)
                            }
                            if let tags = recipe["tags"] as? [String] {
                                recipeTags.append(tags)
                            }
                        }
                        
                        completion(recipeNames, recipeTags, nil)
                    } else {
                        completion(nil, nil, NSError(domain: "Invalid JSON structure", code: 4, userInfo: nil))
                    }

                case .failure(let error):
                    completion(nil, nil, error)
                }
            }
        }
    }
    
    //Function that gets all recipe tags for AI
    func getAllRecipeTags(completion: @escaping ([String]?) -> Void) {
        //Api request
        guard let url = URL(string: "https://dummyjson.com/recipes/tags") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        //Data
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error fetching recipe tags: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            //Http response
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response")
                completion(nil)
                return
            }
            
            //Empty data check
            guard let data = data else {
                print("No data returned")
                completion(nil)
                return
            }
            
            do {
                //Get Json data
                let tags = try JSONDecoder().decode([String].self, from: data)
                print("From util")
                completion(tags)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        // Start the data task
        task.resume()
    }
}
