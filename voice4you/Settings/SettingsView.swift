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
    @State var isAlertShown = false
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
                        Label {
                            Text("Support")
                        } icon: {
                            Image(systemName: "questionmark.circle")
                        }
                    })
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label {
                            Text("About")
                        } icon: {
                            Image(systemName: "info.circle")
                        }
                    }
                    Button(action: {
                        isAlertShown = true
                    }, label: {
                        Label {
                            Text("Reset App")
                        } icon: {
                            Image(systemName: "arrow.circlepath")
                        }
                        .foregroundStyle(.red)
                    })
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
        .navigationViewStyle(.columns)
        .accentColor(Color("tabBar"))
        .alert("Are you sure you want to reset the app?", isPresented: $isAlertShown) {
            Button("Cancel", role: .cancel){
                isAlertShown = false
            }
            Button("Reset", role: .destructive){
                print("reset App")
                globals.reset()
                isAlertShown = false
            }
        }
    }
    
    func dismiss() {
        globals.isShowingSettings.toggle()
    }
}

#Preview {
    SettingsView()
        .environmentObject(Globals())
}
