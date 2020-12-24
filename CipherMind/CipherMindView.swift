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
            Text("Emoji Mind").padding(.vertical, 5.0)
            ZStack {
                RoundedRectangle(cornerRadius: 3.0)
                    .stroke()
                    .foregroundColor(.black)
                GuessRow(pegs: cipherViewModel.correctSolution)
                if (!cipherViewModel.isSolved) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 3.0).foregroundColor(.black)
                        HStack(spacing: 26) {
                            ForEach(0..<cipherViewModel.correctSolution.count) { element in
                                Text("?")
                                    .font(.system(size: 42))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .frame(width: nil, height: 50)
            
            // Guess history
            ScrollView {
                ScrollViewReader { value in
                    ForEach(0..<cipherViewModel.guessesArray.count, id:\.self) { index in
                        GuessRow(pegs: cipherViewModel.guessesArray[index].guesses, scores: cipherViewModel.guessesArray[index].scores)
                            .frame(width: nil, height: 25)
                            .padding(.vertical)
                    }
                        .padding(.vertical)
                    .onChange(of: cipherViewModel.guessesArray.count) { _ in
                        withAnimation {
                            value.scrollTo(cipherViewModel.guessesArray.count - 1)
                        }
                    }
                }
            }
            
            // Target row
            DropTargetRow(currentGuess: $currentGuess)
                .frame(width: nil, height: 50)
            
            // Pallette
            PegPallette(pegs: CipherMindViewModel.emojiSet, currentGuess: $currentGuess)
                .padding(.top)
            
            // Submit guess
            Button(action: {
                withAnimation(.easeInOut) {
                    submitGuess()
                }
            }, label: {
                Text("Submit guess")
                    .font(.system(size: 32))
                    .fontWeight(.bold)
                    .padding(.top, 5.0)
            })
            .disabled(!canSubmit || cipherViewModel.isSolved)

            // Carry forward automatically
            Button(action: {
                withAnimation(.easeInOut) {
                    carryForwardKnownItems()
                }
            }, label: {
                Text("Carry known items forward")
            })
            .background(RoundedRectangle(cornerRadius: 5.0)
                            .stroke(carryingForward ? Color.blue : Color.clear))
            .disabled(cipherViewModel.isSolved)
            
            // New Game
            Button(action: {
                withAnimation(.easeInOut) {
                    cipherViewModel.newGame()
                    resetGuess()
                }
            }, label: {
                Text("New Game")
            })
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
            .padding(.bottom, 5)
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
