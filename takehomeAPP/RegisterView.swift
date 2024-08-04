//
//  RegisterView.swift
//  takehomeAPP
//
//  Created by Ajnur Bogucanin on 29. 7. 2024..
//
//  This is the view for registration screen.

import SwiftUI

struct RegisterView: View {

    @StateObject private var currentUser = CurrentUser()
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var age: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var errorMessage: String?
    @State var emptyAlert: Bool = false
    @State var isRegistered: Bool = false
    let util = Util()
    //UI Elements
    
    var body: some View {
        if isRegistered {
            HomeView().environmentObject(currentUser)
        } else {
            VStack {
                //Name
                TextField("First Name", text: $firstName)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                //Last Name
                TextField("Last Name", text: $lastName)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                //Age Field
                TextField("Age", text: $age)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                //IGN or Username
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                //Password
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                //Error Message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                }
                
                //Register Button
                Button(action: {
                    register(name: firstName, lname: lastName, age: age, user: username, pass: password)
                }) {
                    Text("Register")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(5.0)
                }
            }
            .padding()
            //Empty Field Alert
            .alert("Some of the fields are empty!", isPresented: $emptyAlert) {
                Button("OK") { }
            }
            
        }
    }
    
    // Functions for Registration \\
    
    // Function to set the emptyAlert property
    func setEmptyAlert(isEmpty: Bool) {
        emptyAlert = isEmpty
    }
    
    // Function to set the isRegistered property
    func setRegisteredStatus(isReg: Bool) {
       isRegistered = isReg
    }
    
    //Function for user registration
    func register(name :String, lname:String, age:String , user:String , pass:String) {
        //While loop for flow control
        while true{
            
            //Check for empty fields
            if util.fieldsEmpty(fields: [name,lname,age,user,pass]){
                setEmptyAlert(isEmpty: true)
                break
            }
            
            //Define the URL
            guard let url = URL(string: "https://dummyjson.com/users/add") else {
                print("Invalid URL")
                return
            }
            
            //Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //Payload
            let requestBody: [String: Any] = [
                "firstName": name,
                "lastName": lname,
                "age": age,
                "username":user,
                "password":pass
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
            
            //Data Task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let json = json as? [String: Any] {
                    
                    //Fetch JSON and make a user object with it
                    print("JSON Response: \(json)")
                    var user = User(json: json)
                    print(user.getUsername())
            
                    //Make a user publically
                    currentUser.logged_user = user
                    //Check
                    print("From a current user: \(currentUser.logged_user?.getUsername() ?? "No user")")
                    //Set registered status
                    self.setRegisteredStatus(isReg:true)
                    
                } else {
                    print("Failed to parse JSON")
                }
            }
            
            //Start the task
            task.resume()
            break
        }
        
    }
    
    }

//View
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
        
        
    }
}
