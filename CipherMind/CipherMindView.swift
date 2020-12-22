//
//  ContentView.swift
//  CipherMind
//
//  Created by Eli Manjarrez on 11/21/20.
//

import SwiftUI

struct CipherMindView: View {
    @ObservedObject var cipherViewModel = CipherMindViewModel()
    @State var currentGuess: [String] = Array<String>()
    @State var carryingForward: Bool = false
    
    var body: some View {
        VStack {
            Text("Emoji Mind").padding(.vertical)
            ZStack {
                GuessRow(pegs: cipherViewModel.correctSolution)
                Rectangle().stroke()
                if (!cipherViewModel.isSolved) {
                    Rectangle().foregroundColor(.black)
                }
            }.frame(width: nil, height: 50)
            ScrollView {
                ForEach(cipherViewModel.guessesArray) { guess in
                    GuessRow(pegs: guess.guesses, scores: guess.scores)
                        .frame(width: nil, height: 25)
                        .padding(.vertical)
                }.padding(.vertical)
            }
            DropTargetRow(currentGuess: $currentGuess)
                .frame(width: nil, height: 50)
            PegPallette(pegs: CipherMindViewModel.emojiSet)
            Button(action: {
                withAnimation(.easeInOut) {
                    carryForwardKnownItems()
                }
            }, label: {
                Text("Carry known items forward")
            })
            .padding(5.0)
            .background(RoundedRectangle(cornerRadius: 5.0)
                            .stroke(carryingForward ? Color.blue : Color.clear))
            .disabled(cipherViewModel.isSolved)
            .padding(5)
            Button(action: {
                withAnimation(.easeInOut) {
                    submitGuess()
                }
            }, label: {
                Text("Submit guess")
            })
            .disabled(!canSubmit || cipherViewModel.isSolved)
            .padding(5)
            Button(action: {
                withAnimation(.easeInOut) {
                    cipherViewModel.newGame()
                    resetGuess()
                }
            }, label: {
                Text("New Game")
            })
            .padding(5)
            Button(action: {
                withAnimation(.easeInOut) {
                    cipherViewModel.addRandomGuess()
                    if carryingForward {
                        processCarryForward()
                    }
                }
            }, label: {
                Text("Random guess")
            })
            .disabled(cipherViewModel.isSolved)
            .padding(5)
        }.padding()
        .onAppear {
            resetGuess()
        }
    }
    
    init() {
        self.cipherViewModel = CipherMindViewModel()
    }
    
    func carryForwardKnownItems() {
        if carryingForward {
            carryingForward = false
        } else {
            carryingForward = true
            processCarryForward()
        }
    }
    
    func processCarryForward() {
        for guess in cipherViewModel.guessesArray {
            for i in 0..<guess.scores.count {
                if guess.scores[i] == CipherScoreType.CipherScoreTypeCorrectStyleAndLocation {
                    currentGuess[i] = guess.guesses[i]
                }
            }
        }
    }
    
    var canSubmit: Bool {
        for element in currentGuess {
            if element == "" {
                return false
            }
        }
        
        return true
    }
    
    func submitGuess() {
        cipherViewModel.submitGuess(currentGuess)
        resetGuess()
        if carryingForward {
            processCarryForward()
        }
    }
    
    func resetGuess() {
        currentGuess = Array(repeating: "", count: cipherViewModel.combinationWidth)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CipherMindView()
    }
}
