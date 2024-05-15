//
//  SettingsVoiceView.swift
//  voice4you
//
//  Created by Benedikt Krische on 15.05.24.
//

import SwiftUI

struct SettingsVoiceView: View {
    @EnvironmentObject var globals: Globals
    
    var body: some View {
        Section(header: Text("Voice")){
            NavigationLink(destination: {
                VStack{
                    Spacer()
                    SettingsYourVoiceView(showText: true)
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
                    SettingsVoiceRateView(showText: true)
                    Spacer()
                }
                .background(Color("bgd"))
                .navigationTitle("Change your speed")
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

#Preview {
    SettingsVoiceView()
        .environmentObject(Globals())
}
