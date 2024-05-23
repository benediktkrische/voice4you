//
//  Globals.swift
//  voice4you
//
//  Created by Benedikt Krische on 04.04.24.
//

import Foundation
import SwiftUI
import AVFoundation
import SwiftTTS

@MainActor
class Globals: ObservableObject {
    @Published var sentence: Sentence = Sentence(words: ["I", "really", "want", "some", "chocolate", "ice-cream"])
    @Published var isPresentedFinalText: Bool = false
    @Published var isShowingTabBar: Bool = true
    @Published var isShowingSettings: Bool = false
    @Published var path: NavigationPath = NavigationPath()
    @Published var selectedTab: Tab = .nouns
    @Published var generator = UIImpactFeedbackGenerator(style: .light)
    @Published var tts = SwiftTTS.live
    @Published var searchText: String = ""
    @Published var rate: Float = 1
    @Published var selectedVoice: AVSpeechSynthesisVoice = AVSpeechSynthesisVoice(language: "en-US")!
    @Published var draggingItem: SentenceWord?
    @Published var undoSentence: [Sentence] = []
    @Published var dateOfFirstAppStart: Date = Date()
    @Published var isFirstAppStart: Bool = true
    
    
    enum CodingKeys: CodingKey {
        case sentence, rate, selectedVoice, dateOfFirstAppStart, isFirstAppStart
    }
    
    struct CodableGlobals: Codable {
        let sentence: Sentence?
        let rate: Float?
        let selectedVoiceIdentifier: String?
        let dateOfFirstAppStart: Date?
        let isFirstAppStart: Bool?
    }
    
    func encode() throws -> Data {
        let codable = CodableGlobals(sentence: sentence, rate: rate, selectedVoiceIdentifier: selectedVoice.identifier, dateOfFirstAppStart: dateOfFirstAppStart, isFirstAppStart: isFirstAppStart)
        let encoder = JSONEncoder()
        return try encoder.encode(codable)
    }
    
    func decode(from data: Data) throws {
        let decoder = JSONDecoder()
        let codable = try decoder.decode(CodableGlobals.self, from: data)
        self.sentence = codable.sentence ?? Sentence(words: ["I", "really", "want", "some", "chocolate", "ice-cream"])
        self.rate = codable.rate ?? 1
        self.selectedVoice = AVSpeechSynthesisVoice(identifier: codable.selectedVoiceIdentifier!) ?? AVSpeechSynthesisVoice(language: "en-US")!
        self.dateOfFirstAppStart = codable.dateOfFirstAppStart ?? Date()
        self.isFirstAppStart = codable.isFirstAppStart ?? true
    }
    
    init(){}
    
    /*
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sentence = try container.decode(Sentence.self, forKey: .sentence)
        rate = try container.decode(Float.self, forKey: .rate)
    }
     */
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("globals.data")
    }
    
    func load() async throws {
        let task = Task<Globals, Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                print("No settings saved yet - generating new Instance ...")
                return Globals()
            }
            
            let globalsObject = Globals()
            try globalsObject.decode(from: data)
            return globalsObject
        }
        let values = try await task.value
        self.sentence = values.sentence
        self.rate = values.rate
        self.selectedVoice = values.selectedVoice
        self.dateOfFirstAppStart = values.dateOfFirstAppStart
        self.isFirstAppStart = values.isFirstAppStart
        print("finished loading safed data")
    }
    
    func save() async throws {
        let task = Task {
            let data = try self.encode()
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
            print("saved Data")
        }
        _ = try await task.value
    }
    
    func reset() {
        Task() {
            let fileURL = try Self.fileURL()
            do {
                print("deleting file at \(fileURL)")
                try FileManager.default.removeItem(at: fileURL)
                try await load()
            }catch {
                print("Error: \(error)")
            }
            
        }
    }
}
