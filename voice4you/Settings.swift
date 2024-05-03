//
//  Settings.swift
//  voice4you
//
//  Created by Benedikt Krische on 25.02.24.
//

import SwiftUI
import AVFoundation

struct Settings: View {
    @EnvironmentObject var globals: Globals
    let voices = AVSpeechSynthesisVoice.speechVoices()
    var body: some View {
        VStack{
            NavigationStack{
                List{
                    VoiceSettings(voices: voices)
                }
                .scrollContentBackground(.hidden)
                .background(Color("bgd"))
                .navigationTitle("Settings")
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
                
            }
        }
        .background(Color("bgd"))
        .accentColor(Color("tabBar"))
    }
    
    func dismiss() {
        globals.isShowingSettings.toggle()
    }
}

struct VoiceSettings: View {
    @EnvironmentObject var globals: Globals
    @State var voices: [AVSpeechSynthesisVoice]
@State var acceptableVoices = ["Gordon","Karen", "Catherine", "Daniel", "Martha", "Arthur", "Moira", "Rishi", "Nicky", "Aaron", "Samantha", "Tessa"]
    
    var body: some View {
        Section(header: Text("Voice")){
            NavigationLink(destination: {
                VStack{
                    Picker(selection: $globals.selectedVoice, label: Text("select a voice")) {
                        ForEach(voices, id: \.self) { voice in
                            if(voice.language.contains("en") && acceptableVoices.contains(voice.name)){
                                Text(voice.name).tag(voice)
                            }
                        }
                    }
                    .pickerStyle(.inline)
                    HStack{
                        Text("Here you can change your voice. Try them out, to find which best suits you")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding()
                    }
                    Spacer()
                        
                }
                .background(Color("bgd"))
            }, label: {
                HStack{
                    Label("Your voice", systemImage: "waveform")
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    Text(globals.selectedVoice.name)
                        .foregroundStyle(Color(UIColor(.secondary)))
                }
            })
            NavigationLink(destination: {
                VStack{
                    HStack{
                        Image(systemName: "tortoise.fill")
                            .foregroundStyle(Color("tabBar"))
                        Slider(value: $globals.rate, in: 0.5...2, step: 0.1)
                            .accentColor(Color("tabBar"))
                        Image(systemName: "hare.fill")
                            .foregroundStyle(Color("tabBar"))
                    }.padding()
                    HStack{
                        Text("Here you can change the speed of your voice. Try different speeds, to find which best suits you")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding()
                    }
                    Spacer()
                }
            }, label: {
                HStack{
                    Label("Voice Speed", systemImage: "speedometer")
                        .foregroundStyle(.primary)
                    Spacer()
                    Text(String(round(globals.rate*10)/10))
                        .foregroundStyle(Color(UIColor(.secondary)))
                }
            })
        }
    }
}

#Preview {
    Settings()
        .environmentObject(Globals())
}
