//
//  ContentView.swift
//  CipherMind
//
//  Created by Eli Manjarrez on 11/21/20.
//

import SwiftUI

struct CipherMindView: View {
    @ObservedObject var cipherViewModel = CipherMindViewModel()
    @State var currentGuess: [String] {
        didSet {
            print("current guess changed to \(currentGuess)")
        }
    }
    
    var body: some View {
        VStack {
            Text("Emoji Mind").padding(.vertical)
            GuessRow(pegs: cipherViewModel.correctSolution)
            PegPallette(pegs: CipherMindViewModel.emojiSet)
            ForEach(cipherViewModel.guessesArray) { guess in
                GuessRow(pegs: guess.guesses)
            }
            DropTargetRow(currentGuess: $currentGuess)
                .frame(width: nil, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Button(action: {
                withAnimation(.easeInOut) {
                    cipherViewModel.submitGuess(currentGuess)
                }
            }, label: {
                Text("Submit guess")
            })
            Button(action: {
                withAnimation(.easeInOut) {
                    cipherViewModel.addRandomGuess()
                }
            }, label: {
                Text("Random guess")
            })
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CipherMindView(currentGuess: ["♥️", "♥️", "♥️", "♥️", "♥️"])
    }
}
