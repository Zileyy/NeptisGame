//
//  GameView.swift
//  takehomeAPP
//
//  Created by Ajnur Bogucanin on 4. 8. 2024..
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameLogic:GameLogic
    @State private var playerGuess = ""
    @State private var showGameOverAlert = false
    
    var body: some View {
        VStack {
            Text("You vs \(gameLogic.player2)")
                .font(.largeTitle)
                .padding()
            
            Text("Score: \(gameLogic.player1Score) - \(gameLogic.player2Score)")
                .font(.title)
            
            Text("Attempts: \(gameLogic.turn)/10")
                .font(.title2)
                .padding()
            
            Text("Recipe: \(gameLogic.currentRecipe)")
                .font(.title2)
                .padding()
            
            TextField("Enter your tag guess", text: $playerGuess)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Send") {
                if gameLogic.checkPlayerGuess(playerGuess) {
                    print("Correct Guess!")
                } else {
                    print("Wrong Guess!")
                }
                gameLogic.opponentGuess()
                gameLogic.nextTurn()
                playerGuess = ""
                if !gameLogic.gameRunning {
                    showGameOverAlert = true
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .alert(isPresented: $showGameOverAlert) {
            Alert(
                title: Text(gameLogic.player1Score > gameLogic.player2Score ? "You won! Congrats!" : "You lost! More luck next time…"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
