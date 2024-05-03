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
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    YourVoiceView()
                    VoiceSpeedView()
                    Spacer()
                }
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
        .accentColor(Color("tabBar"))
    }
    
    func dismiss() {
        globals.isShowingSettings.toggle()
    }
}

struct VoiceSettings: View {
    @EnvironmentObject var globals: Globals
    
    var body: some View {
        Section(header: Text("Voice")){
            NavigationLink(destination: {
                VStack{
                    Spacer()
                    YourVoiceView(showText: true)
                    Spacer()
                }
                .background(Color("bgd"))
                .navigationTitle("Change your voice")
                .toolbarColorScheme(.dark, for: .navigationBar)
                .navigationBarTitleDisplayMode(.large)
                .toolbarBackground(Color("tabBar"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
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
                    Spacer()
                    VoiceSpeedView(showText: true)
                    Spacer()
                }
                .background(Color("bgd"))
                .navigationTitle("Change your voice")
                .toolbarColorScheme(.dark, for: .navigationBar)
                .navigationBarTitleDisplayMode(.large)
                .toolbarBackground(Color("tabBar"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
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

struct YourVoiceView: View {
    @EnvironmentObject var globals: Globals
    @State var voices: [AVSpeechSynthesisVoice] = AVSpeechSynthesisVoice.speechVoices()
    @State var acceptableVoices = ["Gordon","Karen", "Catherine", "Daniel", "Martha", "Arthur", "Moira", "Rishi", "Nicky", "Aaron", "Samantha", "Tessa"]
    @State var isAlert = false
    @State var showText = false
    
    var body: some View {
        if(!showText){
            HStack{
                Label("YOUR VOICE", systemImage: "info.circle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 30)
                    .onTapGesture {
                        isAlert.toggle()
                    }
                Spacer()
            }
            
            .padding(.top)
        }
        HStack{
            Picker(selection: $globals.selectedVoice, label: Text("select a voice")) {
                ForEach(voices, id: \.self) { voice in
                    if(voice.language.contains("en") && acceptableVoices.contains(voice.name)){
                        Text(voice.name).tag(voice)
                    }
                }
            }
            .pickerStyle(.inline)
            .background(Color(UIColor.systemBackground))
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
        .alert("Info", isPresented: $isAlert, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text("Here you can change your voice. Try them out, to find which suits you best.")
        })
        if(showText){
            Text("Here you can change your voice. Try them out, to find which suits you best.")
                .padding(.horizontal, 25)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct VoiceSpeedView: View {
    @EnvironmentObject var globals: Globals
    @State var isEditing = false
    @State var isAlert = false
    @State var showText = false
    
    var body: some View {
        VStack{
            if(!showText){
                HStack{
                    Label("YOUR RATE", systemImage: "info.circle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 30)
                        .onTapGesture {
                            isAlert.toggle()
                        }
                    Spacer()
                }
                .padding(.top)
            }
            VStack{
                VStack{
                    HStack{
                        Image(systemName: "tortoise.fill")
                            .foregroundStyle(Color("tabBar"))
                        Slider(value: $globals.rate, in: 0.5...1.5, step: 0.1, onEditingChanged: { editing in
                            isEditing = editing
                        })
                        .accentColor(Color("tabBar"))
                        Image(systemName: "hare.fill")
                            .foregroundStyle(Color("tabBar"))
                    }
                    Text("\(globals.rate.magnitude, specifier: "%.1f")")
                        .foregroundColor(Color("tabBar"))
                        .font(.title2)
                }
                .padding()
                .background(Color(UIColor.systemBackground))
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            .alert("Info", isPresented: $isAlert, actions: {
                Button("OK", role: .cancel) { }
            }, message: {
                Text("Here you can change the speed of your voice. Try different speeds, to find which suits you best")
            })
            if(showText){
                Text("Here you can change the speed of your voice. Try different speeds, to find which suits you best")
                    .padding(.horizontal, 25)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .background(Color("bgd"))
    }
}

#Preview {
    FinalText()
        .environmentObject(Globals())
    //Settings()
    //    .environmentObject(Globals())
}
