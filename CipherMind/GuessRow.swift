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
            ZStack {
                ZStack {
                    if (score != nil) {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color(UIColor.white), Color(UIColor.lightGray)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .padding(-6)
                        Circle()
                            .stroke(lineWidth: 3.0)
                            .padding(-3.0)
                            .foregroundColor(colorForScore(score!))
                        //                        .background(Circle()
                        //                                        .inset(by: -3)
                        //                                        .background()
                    }
                    Text(string)
                        .font(.system(size: 28.0))
                        .onDrag { NSItemProvider(object: string as NSString) }
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
