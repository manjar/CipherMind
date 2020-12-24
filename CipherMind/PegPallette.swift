//
//  PegPallette.swift
//  CipherMind
//
//  Created by Eli Manjarrez on 11/21/20.
//

import SwiftUI

struct PegPallette : View {
    var pegs: [String]
    @Binding var currentGuess: [String]
    var body: some View {
        HStack {
            ForEach(pegs.map { String($0) }, id: \.self) { peg in
                Text(peg)
                    .font(.system(size: 28.0))
                    .onDrag { NSItemProvider(object: peg as NSString) }
                    .onTapGesture {
                        addToCurrentGuess(peg: peg)
                    }
            }
        }
    }
    
    func addToCurrentGuess(peg: String) {
        if let firstEmpty = currentGuess.firstIndex(where: { $0 == "" }) {
            currentGuess[firstEmpty] = peg
        }
    }
}
