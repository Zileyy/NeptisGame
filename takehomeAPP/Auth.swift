//
//  Auth.swift
//  takehomeAPP
//
//  Created by Ajnur Bogucanin on 29. 7. 2024..
//

import Foundation

class Auth {
   
    //Function for registration
    func register(firstName: String, lastName: String, age: String, username: String, password: String) {
        guard let url = URL(string: "https://dummyjson.com/users/add") else {
            print("Invalid URL")
            return
        }

        //POST request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        //Payload for making the POST request
        let payload: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "age": Int(age) ?? 0,
            "username": username,
            "password": password
        ]
        
        //Processing the request
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let _ = json["id"] as? Int {
                    DispatchQueue.main.async {
                        isRegistered = true
                    }
                } else {
                    DispatchQueue.main.async {
                        errorMessage = "Registration failed"
                    }
                }
            } catch {
                print("JSON Error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
}
