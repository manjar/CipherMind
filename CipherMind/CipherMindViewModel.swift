//
//  CipherMindViewModel.swift
//  CipherMind
//
//  Created by Eli Manjarrez on 11/21/20.
//

import Foundation

class CipherMindViewModel : ObservableObject {
    static private(set) var emojiSet: Array<String> = ["♥️", "🧡", "💛", "💚", "💙", "💜", "🖤", "🤍", "🤎"]
    @Published private var model: CipherMindModel<String> = createCipherModel()
    
    static func createCipherModel() -> CipherMindModel<String> {
        CipherMindModel(combinationWidth: combinationWidth, maximumAttempts: maxAttempts) { combinationWidth in
            return randomSolution(ofWidth: combinationWidth)
        }
    }
    
    static func randomSolution(ofWidth width: Int) -> Array<String> {
        var returnArray = Array<String>()
        for _ in (0..<width) {
            let nextIndex = Int.random(in: 0..<emojiSet.count)
            let nextItem = emojiSet[nextIndex]
            returnArray.append(nextItem)
        }
        print ("Created random solution \(returnArray)")
        return returnArray
    }
    
    func submitGuess(_ valueArray:Array<String>) {
        model.addGuess(valueArray)
    }
    
    func addRandomGuess() {
        model.addGuess(CipherMindViewModel.randomSolution(ofWidth: 5))
    }
    
    var guessesArray: [CipherMindModel<String>.CipherMindCombination] { model.guessesArray }
    var correctSolution: Array<String> { model.correctSolution.guesses }
    var combinationWidth: Int { model.combinationWidth }
    
    static var combinationWidth =  5
    static let maxAttempts      = 12
}
