//
//  FinalText.swift
//  voice4you
//
//  Created by Benedikt Krische on 06.12.23.
//

import SwiftUI
import AVFoundation
import SwiftTTS
import CoreAudioTypes

struct FinalText: View {
    @EnvironmentObject var globals: Globals
    @State var text: String = ""
    @State var progress: Double = 0
    @State var promttf = ""
    @State var Answer = ""
    @State var degrees = 0.0
    
    private let voices = AVSpeechSynthesisVoice.speechVoices()
    var body: some View {
        VStack{
            NavigationStack{
                List{
                    VoiceSettings(voices: voices)
                    Section(header: Text("your sentence")){
                        VStack(){
                            Text(globals.sentence.wordsAsString.joined(separator: " "))
                                .font(.title2)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .frame(height: 500)
                .scrollContentBackground(.hidden)
                .background(Color("bgd"))
                .navigationTitle("Generate Your Sentence")
                .toolbarColorScheme(.dark, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                })
                )
                .toolbarBackground(Color("tabBar"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .onAppear(){
                    text = globals.sentence.wordsAsString.joined(separator: " ")
                }
                VStack{
                    Spacer()
                    HStack(){
                        Spacer()
                        ProgressView(value: progress)
                            .progressViewStyle(.linear)
                            .accentColor(Color("tabBar"))
                        Spacer()
                    }
                    Button {
                        speakText(text)
                    } label: {
                        Label(
                            "Speak it!",
                            systemImage: "text.bubble"
                        )
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("tabBar"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
                .background(Color("bgd"))
            }
        }
    }
    
    private func dismiss() {
        globals.isPresentedFinalText.toggle()
    }
    
    func speakText(_ text: String) {
        globals.tts.setVoice(globals.selectedVoice)
        globals.tts.setRateRatio(globals.rate)
        globals.tts.speak(text)
        Task {
            for await prog in globals.tts.speakingProgress() {
                progress = prog
            }
        }
    }
}

#Preview {
    FinalText()
        .environmentObject(Globals())
}
