import SwiftUI
import Combine

class RegisterViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var age: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @State var emptyAlert: Bool = false
    @Published var isRegistered: Bool = false
    
    func rs(){
        
            self.emptyAlert = true
            
    }
}
