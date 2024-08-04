//This file is repsonsible for look and functionality of App's login

//IMPORTS
import SwiftUI

//View
struct LoginView: View {
    //VARS
    @StateObject private var currentUser = CurrentUser()
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var EmptyAlertShowing: Bool = false
    @State private var validCredentialsAlertShowing: Bool = false
    @State private var isLoggedIn: Bool = false
    @State private var user: User?
    @State private var message: String?

    //Utility integration
    let util = Util()
    
    //BODY
    var body: some View {
        NavigationView {
            VStack {
                //Checks if user is logged in and redirects to HomeView
                if isLoggedIn {
                    HomeView().environmentObject(currentUser)
                } else {
                    VStack {
                        // UI ELEMENTS \\
                        //Username txt filed
                        TextField("Username", text: $username)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5.0)
                            .padding(.bottom, 20)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        
                        //Password txt field
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5.0)
                            .padding(.bottom, 20)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        
                        //Error message
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding(.bottom, 20)
                        }
                        
                        //Login Button
                        Button(action: {
                            DispatchQueue.main.async {
                                login(usernameF: username, passwordF: password)
                            }
                        }) {
                            Text("Login")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(5.0)
                        }
                        .padding(.bottom, 20)
                        
                        //Registration Redirect
                        NavigationLink(destination: RegisterView()) {
                            Text("Don't have an account? Register here")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    
                    //Empty field alert
                    .alert("Some of the fields are empty!", isPresented: $EmptyAlertShowing) {
                        Button("OK") { }
                    }
                    //Invalid credentials alert
                    .alert("Invalid credentials!", isPresented: $validCredentialsAlertShowing) {
                        Button("OK") { }
                    }
                }
            }
        }
    }
    
    //Function that displays an alert if there are empty fields
    func setEmptyAlert(isEmpty: Bool) {
            EmptyAlertShowing = isEmpty
    }
    
    //Function that displays an alert if user entered invalid credentials
    func setValidCredentials(credAlert: Bool) {
        DispatchQueue.main.async {
            validCredentialsAlertShowing = credAlert
        }
    }
    
    //Function that allows authed user to proceed to HomeView
    func setLoggedInStatus(isLoggedIn: Bool) {
        DispatchQueue.main.async {
            self.isLoggedIn = isLoggedIn
        }
    }
    
    //Function that stores an error message
    func setErrorMessage(message: String?) {
        DispatchQueue.main.async {
            self.errorMessage = message
        }
    }
    
    //Function for performing a login
    func login(usernameF: String, passwordF: String) {
        
        //Checks if there are empty fields
        if util.fieldsEmpty(fields:[usernameF,passwordF]){
            setEmptyAlert(isEmpty:true)
        }
        
        //Proceeds to login if all fields are filled
        else{
            
            //Set the payload
            let payload: [String: Any] = ["username": usernameF, "password": passwordF]
            
            //Send the request
            util.sendRequest(to: "https://dummyjson.com/auth/login", with: payload, method:"POST") {
                result in DispatchQueue.main.async {
                    switch result {
                        //Catch the json if successful
                    case .success(let json):
                        //Create a user object
                        self.user = User(json: json)
                        //Unwrap the optional
                        if let unwrappedUser = user {
                            //Checks if we got the real user or default value
                            if unwrappedUser.getUsername() == "Guest"{
                                self.setValidCredentials(credAlert: true)
                            }
                            //Executes successful login
                            else{
                                //Add it to currentUser so it is accessable to other views
                                currentUser.logged_user = unwrappedUser
                                //Check
                                print("From a current user: \(currentUser.logged_user?.getUsername() ?? "No user")")
                                //Set logged status
                                self.setLoggedInStatus(isLoggedIn: true)
                            }
                        }
                        
                    //I don't even want to talk about this one we are manifesting case from line 138
                    case .failure(let error):
                        self.message = error.localizedDescription
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
