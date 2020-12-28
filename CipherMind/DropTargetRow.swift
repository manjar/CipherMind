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
            Spacer()
            ForEach(0..<currentGuess.count, id: \.self) { index in
                DropTargetCell(currentString: currentGuess[index], delegate: self, id: index)
                    .onTapGesture {
                        currentGuess[index] = ""
                    }
            }
            Spacer()
        }.padding(.horizontal)
    }
    
    internal func drop(providers: [NSItemProvider], atIndex index: Int) -> Bool {
        let found = providers.loadObjects(ofType: String.self) { string in
            currentGuess[index] = string
        }
        return found
    }
    
    struct DropTargetCell: View {
        var currentString: String?
        var delegate: DropCellDelegate
        var id: Int
        var body: some View {
            ZStack {
                Rectangle()
                    .stroke(lineWidth: 3.0)
                    .foregroundColor(Color.gray)
                Text(currentString ?? "")
                    .font(.system(size: 28.0))
            }.onDrop(of: ["public.utf8-plain-text"], isTargeted: nil) { providers, location in
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
