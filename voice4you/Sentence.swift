//
//  data.swift
//  voice4you
//
//  Created by Benedikt Krische on 06.12.23.
//

import SwiftUI
import UniformTypeIdentifiers

struct Sentence: Hashable, Codable{
    var words: [SentenceWord]
    
    init(words: [String]) {
        self.words = []
        for w in words {
            let wo: SentenceWord = SentenceWord(name: w, uuid: UUID())
            self.words.append(wo)
        }
    }
    
    var wordsAsString: [String] {
        var new: [String] = []
        for w in words{
            new.append(w.name)
        }
        return new
    }
}

struct SentenceWord: Hashable, Codable, Transferable{
    var name: String
    var uuid: UUID
    var hidden: Bool = false
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .sentenceWord)
        DataRepresentation(exportedContentType: .text) { Transferable in
            Transferable.name.data(using: .utf8)!
        }
    }
}

extension UTType {
    static let sentenceWord = UTType(exportedAs: "at.htlklu.voice4you.sentenceWord")
}
