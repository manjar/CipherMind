//
//  CipherMindApp.swift
//  CipherMind
//
//  Created by Eli Manjarrez on 11/21/20.
//

import SwiftUI

@main
struct CipherMindApp: App {
    var body: some Scene {
        WindowGroup {
            CipherMindView(currentGuess: ["", "", "", "", ""])
        }
    }
}
