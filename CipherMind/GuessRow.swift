//
//  GuessRow.swift
//  CipherMind
//
//  Created by Eli Manjarrez on 11/21/20.
//

import SwiftUI

struct GuessRow : View {
    var pegs: [String]
    var scores: [CipherScoreType]?
    var body: some View {
        HStack {
            ForEach(0..<pegs.count) { pegIndex in
                GuessCell(string: pegs[pegIndex], score: scores?[pegIndex])
            }
        }
    }
    
    struct GuessCell: View {
        var string: String
        var score: CipherScoreType?
        var body: some View {
            VStack {
                Text(string)
                    .onDrag { NSItemProvider(object: string as NSString) }
                if (score != nil) {
                    Circle().foregroundColor(colorForScore(score!))
                }
            }
        }
        
        func colorForScore(_ score: CipherScoreType) -> Color {
            switch score {
            case .CipherScoreTypeNoMatch, .CipherScoreTypeNotScored:
                return Color.clear
            case .CipherScoreTypeCorrectStyle:
                return Color.gray
            case .CipherScoreTypeCorrectStyleAndLocation:
                return Color.black
            }
        }
    }
}
