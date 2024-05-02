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

class Globals: ObservableObject {
    @Published var sentence: Sentence = Sentence.init(words: ["I", "really", "want", "some", "chocolate", "ice-cream"])
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
}
