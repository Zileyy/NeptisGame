//IMPORTS
import SwiftUI

//View
struct HomeView: View {
    
    //VARS
    @EnvironmentObject private var currentUser:CurrentUser
    @State private var navigateToGameView = false
    @State private var startClicked = false
    @State private var selectedOpponent: String = "emilys"
    @State private var opponents: [String] = []
    @StateObject private var gameLogic = GameLogic()
    let util = Util()
    
    var body: some View {
        NavigationStack{
            VStack {
                
                //Welcome message
                Text("Hello \(currentUser.logged_user?.getFirstname() ?? "Guest")")
                    .font(.caption)
                    .padding(.top, 10)
                
                //Title
                Text("Neptis Game")
                    .font(.title)
                    .padding(.top, 10)
                
                //Spacer
                Spacer()
                
                //Label
                Text("Select your opponent")
                    .font(.headline)
                    .padding(.bottom, 10)
                
                //Dropdown menu
                Picker("Select your opponent", selection: $selectedOpponent) {
                    ForEach(opponents, id: \.self) { opponent in
                        Text(opponent).tag(opponent)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                //Spacer
                Spacer()
                
                //Start button
                Button(action: {
                    startClicked = true
                }) {
                    Text("Start")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
                
            }
            .onAppear(){
                storeOpponents()
            }
            .padding()
            .navigationDestination(isPresented: $navigateToGameView) {
                GameView()
                    .environmentObject(gameLogic) 
            }
            //Empty field alert
            .alert("Do you want to play guess name with \(selectedOpponent)?", isPresented: $startClicked) {
                Button("Yay!") {
                    //Configure game logic
                    print("Start button tapped. Selected opponent: \(selectedOpponent)")
                    //Configure players
                    gameLogic.player1 = currentUser.logged_user?.getUsername() ?? "You"
                    gameLogic.player2 = selectedOpponent
                    //Redirect
                    navigateToGameView = true
                }
                Button("Naah.") {}
            }
        }
    }
    //Function that stores usernames to opponents
    func storeOpponents(){
        DispatchQueue.main.async {
            util.fetchUsernames { usernames, error in
                if let error = error {
                    print("Error fetching usernames: \(error.localizedDescription)")
                } else if let usernames = usernames {
                    opponents = usernames
                }
            }
        }
    }
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            let currentUser = CurrentUser()
            currentUser.logged_user = User()
            
            return HomeView()
                .environmentObject(currentUser)
            
        }
    }
}
