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
import OpenAI
import Security

@MainActor
class Globals: ObservableObject {
    @Published var sentence: Sentence = Sentence(words: ["I", "really", "want", "some", "chocolate", "ice-cream"])
    @Published var isPresentedFinalText: Bool = false
    @Published var isShowingSettings: Bool = false
    @Published var path: NavigationPath = NavigationPath()
    @Published var settingsPath: NavigationPath = NavigationPath()
    @Published var selectedTab: Tab = .nouns
    @Published var generator = UIImpactFeedbackGenerator(style: .light)
    @Published var generatorHeavy = UIImpactFeedbackGenerator(style: .heavy)
    @Published var generatorSoft = UIImpactFeedbackGenerator(style: .soft)
    @Published var generatorError = UIImpactFeedbackGenerator(style: .rigid)
    @Published var tts = SwiftTTS.live
    @Published var searchText: String = ""
    @Published var voiceRate: Float = 1
    @Published var selectedVoice: AVSpeechSynthesisVoice = AVSpeechSynthesisVoice(language: "en-US")!
    @Published var draggingItem: SentenceWord?
    @Published var undoSentence: [Sentence] = []
    @Published var dateOfFirstAppStart: Date = Date()
    @Published var isFirstAppStart: Bool = true
    @Published var isAIEnabled: Bool = true
    @Published var isAISettingsViewHighlighted: Bool = false
    @Published var openAIChatResults: [ChatResult] = []
    @Published var openAIFreeRequests: Int = 30
    @Published var openAIAPIKey: String? = nil
    @Published var freeOpenAPIKey: String? = nil
    @Published var alwaysRemakeSentence: Bool = false
    
    enum CodingKeys: CodingKey {
        case sentence, voiceRate, selectedVoice, dateOfFirstAppStart, isFirstAppStart, openAIChatResults, openAIFreeRequests, isAIEnabled, alwaysRemakeSentence
    }
    
    struct CodableGlobals: Codable {
        let sentence: Sentence?
        let voiceRate: Float?
        let selectedVoiceIdentifier: String?
        let dateOfFirstAppStart: Date?
        let isFirstAppStart: Bool?
        let openAIChatResults: [ChatResult]?
        let openAIFreeRequests: Int?
        let openAIAPIKey: String?
        let isAIEnabled: Bool?
        let alwaysRemakeSentence: Bool?
    }
    
    func encode() throws -> Data {
        let codable = CodableGlobals(sentence: sentence, voiceRate: voiceRate, selectedVoiceIdentifier: selectedVoice.identifier, dateOfFirstAppStart: dateOfFirstAppStart, isFirstAppStart: isFirstAppStart, openAIChatResults: openAIChatResults, openAIFreeRequests: openAIFreeRequests, openAIAPIKey: openAIAPIKey, isAIEnabled: isAIEnabled, alwaysRemakeSentence: alwaysRemakeSentence)
        let encoder = JSONEncoder()
        return try encoder.encode(codable)
    }
    
    func decode(from data: Data) throws {
        let decoder = JSONDecoder()
        let codable = try decoder.decode(CodableGlobals.self, from: data)
        self.sentence = codable.sentence ?? Sentence(words: ["I", "really", "want", "some", "chocolate", "ice-cream"])
        self.voiceRate = codable.voiceRate ?? 1
        self.selectedVoice = AVSpeechSynthesisVoice(identifier: codable.selectedVoiceIdentifier!) ?? AVSpeechSynthesisVoice(language: "en-US")!
        self.dateOfFirstAppStart = codable.dateOfFirstAppStart ?? Date()
        self.isFirstAppStart = codable.isFirstAppStart ?? true
        self.openAIChatResults = codable.openAIChatResults ?? []
        self.openAIFreeRequests = codable.openAIFreeRequests ?? 30
        self.openAIAPIKey = codable.openAIAPIKey ?? nil
        self.isAIEnabled = codable.isAIEnabled ?? true
        self.alwaysRemakeSentence = codable.alwaysRemakeSentence ?? false
    }
    
    init(){}
    
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
        self.voiceRate = values.voiceRate
        self.selectedVoice = values.selectedVoice
        self.dateOfFirstAppStart = values.dateOfFirstAppStart
        self.isFirstAppStart = values.isFirstAppStart
        self.openAIChatResults = values.openAIChatResults
        self.openAIFreeRequests = values.openAIFreeRequests
        self.openAIAPIKey = values.openAIAPIKey
        self.isAIEnabled = values.isAIEnabled
        self.freeOpenAPIKey = Secrets().getFreeApiKey()
        self.alwaysRemakeSentence = values.alwaysRemakeSentence
        
        let user = "default"
        let label = "API_KEY"
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: user,
            kSecAttrLabel as String: label,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        var item: CFTypeRef?
        
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            // Extract result
            if let existingItem = item as? [String: Any],
               let passwordData = existingItem[kSecValueData as String] as? Data,
               let value = String(data: passwordData, encoding: .utf8)
            {
                self.openAIAPIKey = value
            }
        }else{
            self.openAIAPIKey = nil
        }
        print("finished loading saved data")
    }
    
    func save() async throws {
        let task = Task {
            if (self.openAIAPIKey != nil){
                let user = "default"
                let label = "API_KEY"
                let value = self.openAIAPIKey!.data(using: .utf8)!
                let attributes: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrLabel as String: label,
                    kSecAttrAccount as String: user,
                    kSecValueData as String: value,
                ]
                if SecItemAdd(attributes as CFDictionary, nil) != noErr {
                    let user = "default"
                    let label = "API_KEY"
                    let newValue = self.openAIAPIKey!.data(using: .utf8)!
                    let query: [String: Any] = [
                        kSecClass as String: kSecClassGenericPassword,
                        kSecAttrLabel as String: label,
                        kSecAttrAccount as String: user,
                    ]
                    let attributes: [String: Any] = [kSecValueData as String: newValue]
                    if SecItemUpdate(query as CFDictionary, attributes as CFDictionary) != noErr {
                        print("Something went wrong trying to update the password")
                    }
                }
            } else {
                let user = "default"
                let label = "API_KEY"
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrLabel as String: label,
                    kSecAttrAccount as String: user,
                ]
                SecItemDelete(query as CFDictionary)
            }
            
            let data = try self.encode()
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
            print("saved Data")
        }
        _ = try await task.value
    }
    
    func reset() {
        Task() {
            let user = "default"
            let label = "API_KEY"
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrLabel as String: label,
                kSecAttrAccount as String: user,
            ]
            SecItemDelete(query as CFDictionary)
            
            let freeRequests = self.openAIFreeRequests
            
            let fileURL = try Self.fileURL()
            do {
                print("deleting file at \(fileURL)")
                try FileManager.default.removeItem(at: fileURL)
                try await load()
                self.openAIFreeRequests = freeRequests
                try await save()
            }catch {
                print("Error: \(error)")
            }
        }
    }
}
