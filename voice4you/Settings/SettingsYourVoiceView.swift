//
//  YourVoiceView.swift
//  voice4you
//
//  Created by Benedikt Krische on 15.05.24.
//

import SwiftUI
import AVFoundation

struct SettingsYourVoiceView: View {
    @EnvironmentObject var globals: Globals
    @State var voices: [AVSpeechSynthesisVoice] = AVSpeechSynthesisVoice.speechVoices()
    @State var acceptableVoices = ["Gordon","Karen", "Catherine", "Daniel", "Martha", "Arthur", "Moira", "Rishi", "Nicky", "Aaron", "Samantha", "Tessa"]
    @State var isAlert = false
    @State var showText = false
    
    var body: some View {
        HStack{
            Picker(selection: $globals.selectedVoice, label: Text("select a voice")) {
                ForEach(voices, id: \.self) { voice in
                    if(voice.language.contains("en") && acceptableVoices.contains(voice.name)){
                        Text(voice.name).tag(voice)
                    }
                }
            }
            .pickerStyle(.wheel)
            .background(showText ? Color(UIColor.systemBackground) : nil)
        }
        .clipShape(showText ? RoundedRectangle(cornerRadius: 10) : RoundedRectangle(cornerRadius: 0))
        .padding(.horizontal, showText ? 20 : 0)
        
        if(showText){
            Text("Here you can change your voice. Try them out, to find which suits you best.")
                .padding(.horizontal, 25)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    FinalText()
        .environmentObject(Globals())
}
