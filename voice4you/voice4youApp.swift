//
//  voice4youApp.swift
//  voice4you
//
//  Created by Benedikt Krische on 03.04.24.
//

import SwiftUI
import SwiftData

@main
struct voice4youApp: App {
    @StateObject private var globals = Globals()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Category.self, Word.self])
        do {
            guard let bundleURL = Bundle.main.url(forResource: "voice4youData", withExtension: "store") else {
                fatalError("Failed to find voice4youData.store")
            }
            let fileManager = FileManager.default
            let documentDirectoryURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let documentURL = documentDirectoryURL.appendingPathComponent("voice4youData.store")
            
            // Only copy the store from the bundle to the Documents directory if it doesn't exist
            if !fileManager.fileExists(atPath: documentURL.path) {
                try fileManager.copyItem(at: bundleURL, to: documentURL)
            }
            let modelConfiguration = ModelConfiguration(url: documentURL)
            return try ModelContainer(for: schema, configurations: modelConfiguration)
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            MainView() {
                saveChangings()
            }
            .environmentObject(globals)
            .task {
                do {
                    try await globals.load()
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
            .onChange(of: globals.sentence) {
                saveChangings()
            }
            .onChange(of: globals.voiceRate){
                saveChangings()
            }
            .onChange(of: globals.openAIAPIKey){
                saveChangings()
            }
            .onChange(of: globals.openAIFreeRequests){
                saveChangings()
            }
            .onChange(of: globals.selectedVoice){
                saveChangings()
            }
            .onChange(of: globals.openAIChatResults){
                saveChangings()
            }
            .onChange(of: globals.dateOfFirstAppStart){
                saveChangings()
            }
            .onChange(of: globals.isFirstAppStart){
                saveChangings()
            }
            .onChange(of: globals.isAIEnabled){
                saveChangings()
            }
            .onChange(of: globals.color) {
                saveChangings()
            }
        }
        .modelContainer(sharedModelContainer)
    }
    
    func saveChangings(){
        Task() {
            do {
                try await globals.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
