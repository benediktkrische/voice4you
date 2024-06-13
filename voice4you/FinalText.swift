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
    @State var progress: Double = 0
    @State var isButtonEnabled = true
    @State var isProgressbarVisible = false
    @State var isAlertPresented = false
    @State var isAIselected = true
    @State var apiAnswer = ""
    
    private let voices = AVSpeechSynthesisVoice.speechVoices()
    var body: some View {
        NavigationStack{
            VStack{
                List{
                    SettingsVoiceView()
                    Section(header: Text("your sentence")){
                        Text(globals.sentence.wordsAsString.joined(separator: " "))
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .padding()
                            .bold(!isAIselected)
                            .foregroundStyle(isAIselected ? .black : Color("tabBar"))
                            .onTapGesture {
                                if(apiAnswer != ""){
                                    globals.generator.impactOccurred()
                                    isAIselected = false
                                }
                            }
                    }
                    if (globals.isAIEnabled){
                        AISection(isAIselected: $isAIselected, apiAnswer: $apiAnswer, isAlertPresented: $isAlertPresented)
                    }
                }
                VStack{
                    if(isProgressbarVisible){
                        ProgressView(value: progress)
                            .frame(height: 20)
                            .progressViewStyle(.linear)
                            .accentColor(Color("tabBar"))
                            .padding(.horizontal)
                    }
                    BottomBar(isButtonEnabled: $isButtonEnabled, apiAnswer: $apiAnswer, isAIselected: $isAIselected) { text in
                        speakText(text)
                    }
                    .padding(.bottom)
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            .background(Color("bgd"))
            .navigationTitle("Generate Your Sentence")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("tabBar"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }.onAppear(){
            if(globals.alwaysRemakeSentence){
                isAIselected = true
            }
        }
        .alert("OpenAI-Key not set", isPresented: $isAlertPresented) {
            Button("Cancel", role: .cancel) {
                isAlertPresented = false
            }
            Button(action: {
                isAlertPresented = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    globals.isPresentedFinalText = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        globals.isShowingSettings = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(.linear){
                                globals.isAISettingsViewHighlighted = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.linear){
                                    globals.isAISettingsViewHighlighted = false
                                }
                            }
                        }
                    }
                }
            }, label: {
                Text("Add Key")
            })
        }
    }
    
    private func dismiss() {
        globals.isPresentedFinalText.toggle()
    }
    
    func speakText(_ text: String) {
        globals.tts.setVoice(globals.selectedVoice)
        globals.tts.setRateRatio(globals.voiceRate)
        globals.tts.speak(text)
        Task {
            for await prog in globals.tts.speakingProgress() {
                withAnimation(.bouncy){
                    progress = prog
                }
                if prog >= 1 {
                    withAnimation(.linear){
                        isProgressbarVisible = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        withAnimation(.linear){
                            isButtonEnabled = true
                        }
                    }
                    break
                } else {
                    withAnimation(.linear){
                        isProgressbarVisible = true
                        isButtonEnabled = false
                    }
                }
            }
            progress = 0
        }
    }
}

struct BottomBar: View {
    @EnvironmentObject var globals: Globals
    @Binding var isButtonEnabled: Bool
    @Binding var apiAnswer: String
    @Binding var isAIselected: Bool
    var speakText: (String) -> Void
    
    var body: some View {
        HStack{
            Spacer()
            Button(action: {
                globals.isPresentedFinalText.toggle()
                globals.generator.impactOccurred()
            }, label: {
                ZStack{
                    Circle()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(globals.selectedTab.color)
                    Image(systemName: "arrow.left")
                        .foregroundStyle(Color("tabBarElements"))
                        .font(.system(size: 34))
                        .shadow(radius: 5)
                }
            })
            ZStack{
                HStack{
                    RoundedRectangle(cornerRadius: 40)
                        .frame(width: nil, height: 60)
                        .foregroundStyle(globals.selectedTab.color)
                        
                    Spacer()
                }
                HStack{
                    Spacer()
                    Rectangle()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(globals.selectedTab.color)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 80)
            .overlay(content:  {
                Button {
                    if(isButtonEnabled){
                        isButtonEnabled = false
                        if(apiAnswer == "" || !isAIselected){
                            speakText(globals.sentence.wordsAsString.joined(separator: " "))
                        }else{
                            speakText(apiAnswer)
                        }
                        globals.generator.impactOccurred()
                    }
                } label: {
                    Label(
                        "Speak it!",
                        systemImage: "text.bubble"
                    )
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("tabBar"))
                    .foregroundColor(isButtonEnabled ? .white : .gray)
                    .cornerRadius(30)
                    .padding(.horizontal)
                }
                .disabled(!isButtonEnabled)
            })
        }
    }
}

#Preview {
    /*
    BottomBar(isButtonEnabled: .constant(true), apiAnswer: .constant(""), isAIselected: .constant(false), speakText: {_ in })
        .environmentObject(Globals())
     */
    FinalText()
        .environmentObject(Globals())
}
