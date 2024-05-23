//
//  Settings.swift
//  voice4you
//
//  Created by Benedikt Krische on 25.02.24.
//

import SwiftUI
import AVFoundation

struct SettingsView: View {
    @EnvironmentObject var globals: Globals
    var body: some View {
        NavigationStack{
                List{
                    Section(header: Text("select your voice")){
                        SettingsYourVoiceView()
                    }
                    Section(header: Text("select Your rate")){
                        SettingsVoiceRateView()
                    }
                    Section(header: Text("About")){
                        NavigationLink(destination: {
                            Support()
                        }, label: {
                            HStack{
                                Image(systemName: "questionmark.circle")
                                Text("Support")
                            }
                        })
                        NavigationLink {
                            AboutView()
                        } label: {
                            HStack{
                                Image(systemName: "info.circle")
                                Text("About")
                            }
                        }

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

#Preview {
    SettingsView()
        .environmentObject(Globals())
}
