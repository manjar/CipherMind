//
//  PegPallette.swift
//  CipherMind
//
//  Created by Eli Manjarrez on 11/21/20.
//

import SwiftUI

struct PegPallette : View {
    var pegs: [String]
    var body: some View {
        HStack {
            ForEach(pegs.map { String($0) }, id: \.self) { peg in
                Text(peg)
//                    .font(Font.system(size: self.defaultEmojiSize))
                    .onDrag { NSItemProvider(object: peg as NSString) }
            }
        }
    }
}
