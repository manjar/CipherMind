//
//  DropTargetRow.swift
//  CipherMind
//
//  Created by Eli Manjarrez on 11/22/20.
//

import SwiftUI

protocol DropCellDelegate {
    func drop(providers: [NSItemProvider], atIndex index: Int) -> Bool
}

struct DropTargetRow : View, DropCellDelegate {
    @Binding var currentGuess: [String]
    var body: some View {
        HStack {
            ForEach(0..<currentGuess.count) { index in
                DropTargetCell(currentString: currentGuess[index], delegate: self, id: index)
            }
        }.padding(.horizontal)
    }
    
    internal func drop(providers: [NSItemProvider], atIndex index: Int) -> Bool {
        let found = providers.loadObjects(ofType: String.self) { string in
            currentGuess[index] = string
        }
        return found
    }
    
    struct DropTargetCell: View {
        var currentString: String
        var delegate: DropCellDelegate
        var id: Int
        var body: some View {
            ZStack {
                Rectangle()
                    .foregroundColor(Color.gray)
                Text(currentString)
            }.onDrop(of: ["public.utf8-plain-text"], isTargeted: nil) { providers, location in
                // SwiftUI bug (as of 13.4)? the location is supposed to be in our coordinate system
                // however, the y coordinate appears to be in the global coordinate system
                return delegate.drop(providers: providers, atIndex: id)
                }
        }
    }
}

extension Array where Element == NSItemProvider {
    func loadObjects<T>(ofType theType: T.Type, firstOnly: Bool = false, using load: @escaping (T) -> Void) -> Bool where T: NSItemProviderReading {
        if let provider = self.first(where: { $0.canLoadObject(ofClass: theType) }) {
            provider.loadObject(ofClass: theType) { object, error in
                if let value = object as? T {
                    DispatchQueue.main.async {
                        load(value)
                    }
                }
            }
            return true
        }
        return false
    }
    func loadObjects<T>(ofType theType: T.Type, firstOnly: Bool = false, using load: @escaping (T) -> Void) -> Bool where T: _ObjectiveCBridgeable, T._ObjectiveCType: NSItemProviderReading {
        if let provider = self.first(where: { $0.canLoadObject(ofClass: theType) }) {
            let _ = provider.loadObject(ofClass: theType) { object, error in
                if let value = object {
                    DispatchQueue.main.async {
                        load(value)
                    }
                }
            }
            return true
        }
        return false
    }
    func loadFirstObject<T>(ofType theType: T.Type, using load: @escaping (T) -> Void) -> Bool where T: NSItemProviderReading {
        self.loadObjects(ofType: theType, firstOnly: true, using: load)
    }
    func loadFirstObject<T>(ofType theType: T.Type, using load: @escaping (T) -> Void) -> Bool where T: _ObjectiveCBridgeable, T._ObjectiveCType: NSItemProviderReading {
        self.loadObjects(ofType: theType, firstOnly: true, using: load)
    }
}
