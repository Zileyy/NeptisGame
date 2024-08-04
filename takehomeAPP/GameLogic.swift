//
//  GameLogic.swift
//  takehomeAPP
//
//  Created by Ajnur Bogucanin on 4. 8. 2024..
//

import Foundation
import Combine

class GameLogic:ObservableObject{
    
    //Utility
    let util = Util()
    
    //Players\\
    //Player names
    @Published var player1:String=""
    @Published var player2:String=""
    
    //Player scores
    @Published var player1Score = 0
    @Published var player2Score = 0
    
    //Game\\
    //Current Recipe name
    @Published var currentRecipe:String=""
    
    //Recipe tags
    @Published var currentRecipeTags:[String]=[]
    @Published var allRecipeTags:[String]=[]
    
    //Turn count
    @Published var turn:Int=0
    
    //Game is running
    @Published var gameRunning:Bool = true
    
    //Game Constrtuctor
    init() {
        self.player1 = "player1"
        self.player2 = "player2"
        self.currentRecipe = ""
        self.currentRecipeTags = []
        self.getRandomRecipe()
        self.fetchAllRecipe()
        self.turn = 1
    }
    
    //Game Constrtuctor
    init(player1: String, player2: String) {
        self.player1 = player1
        self.player2 = player2
        self.currentRecipe = ""
        self.currentRecipeTags = []
        self.getRandomRecipe()
        self.fetchAllRecipe()
        self.turn = 1
    }
    
    //Function that gets a random recipe
    public func getRandomRecipe(){
        
        //Vars for names and tags
        var recipeNames:[String] = []
        var recipeTags:[[String]] = []
        
        //Fetch recipe names and tags
        util.fetchRecipes { names, tags, error in
            DispatchQueue.main.async {
                if let error = error {
                    let errorMessage = error.localizedDescription
                    print(errorMessage)
                } else {
                    //vars
                    recipeNames = names ?? []
                    recipeTags = tags ?? []
                    
                    //Get a random recipe index
                    let randomRecipeIndex = Int.random(in: 0...recipeNames.count-1)
                    
                    //Set the values
                    self.currentRecipe = recipeNames[randomRecipeIndex]
                    self.currentRecipeTags = recipeTags[randomRecipeIndex]
                    //Check
                    print("Recipe: \(self.currentRecipe) Tags: \(self.currentRecipeTags)")
                }
            }
        }
    }
    
    //Checks your guess
    public func checkPlayerGuess(_ guess: String) -> Bool {
        print("Your: \(guess)")
        if currentRecipeTags.contains(guess) {
            player1Score += 1
            return true
        }
        return false
    }
        
    //AI guess logic
    public func opponentGuess() -> Bool {
        print(allRecipeTags)
        var guess = allRecipeTags.randomElement()
        print("AI: \(guess ?? "No guess")")
        for item in currentRecipeTags{
            if item == guess{
                player2Score += 1
                return true
            }else{
                return false
            }
        }
        return false
    }
    
    //Function that fetches all recpie names
    public func fetchAllRecipe(){
        //Fetch
        util.getAllRecipeTags { tags in
            if let tags = tags {
                self.allRecipeTags = tags
            } else {
                print("Failed to fetch tags")
            }
        }
        
    }
        
        //Funcion for next turn and incorrectly indented
        public func nextTurn() {
            turn += 1
            if turn > 10 {
                gameRunning = false
            } else {
                getRandomRecipe()
            }
        }
    
}
