//
//  CipherMindModel.swift
//  CipherMind
//
//  Created by Eli Manjarrez on 11/21/20.
//

import Foundation

enum CipherScoreType {
    case CipherScoreTypeNotScored
    case CipherScoreTypeNoMatch
    case CipherScoreTypeCorrectStyle
    case CipherScoreTypeCorrectStyleAndLocation
}

struct CipherMindModel<CipherStyle> where CipherStyle: Equatable {
    var correctSolution: CipherMindCombination
    var guessesArray: [CipherMindCombination] = Array<CipherMindCombination>()
    var combinationWidth: Int
    var maximumAttempts: Int
    
    init(combinationWidth: Int, maximumAttempts:Int, solutionProvider: (Int) -> [CipherStyle]) {
        self.combinationWidth = combinationWidth
        self.maximumAttempts = maximumAttempts
        let correctSolution = solutionProvider(combinationWidth)
        self.correctSolution = CipherMindCombination(correctSolution)
    }
    
    mutating func addGuess(_ values:[CipherStyle]) {
        guard values.count == combinationWidth else {
            assertionFailure()
            return
        }
        guessesArray.append(CipherMindCombination(values))
    }
    
    mutating func scoreLatestGuess() {
        guard guessesArray.count > 0 else {
            return
        }
        guessesArray[guessesArray.endIndex - 1].scoreAgainstSolution(solution: self.correctSolution)
    }
    
    struct CipherMindCombination: Equatable, Identifiable {
        var id: String
        
        var guesses: [CipherStyle]
        private(set) var scores: [CipherScoreType]
        var isFinal: Bool = false
        
        init(_ guesses:[CipherStyle]) {
            self.guesses = guesses
            self.scores = Array<CipherScoreType>()
            for _ in guesses {
                self.scores.append(CipherScoreType.CipherScoreTypeNotScored)
            }
            self.id = UUID().uuidString
        }
        
        mutating func scoreAgainstSolution(solution: CipherMindCombination) {
            guard self.guesses.count == solution.guesses.count else {
                assertionFailure()
                return
            }
            
            scores.removeAll()
            for index in (0..<guesses.count) {
                if guesses[index] == solution.guesses[index] {
                    scores.append(CipherScoreType.CipherScoreTypeCorrectStyleAndLocation)
                } else if solution.containsStyle(guesses[index]) {
                    scores.append(CipherScoreType.CipherScoreTypeCorrectStyle)
                } else {
                    scores.append(CipherScoreType.CipherScoreTypeNoMatch)
                }
            }
        }
        
        func containsStyle(_ style:CipherStyle) -> Bool {
            return guesses.firstIndex(of: style) != nil ? true : false
        }
    }
}

