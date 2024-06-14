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
        NavigationStack (path: $globals.settingsPath){
            List{
                Section {
                    SettingsYourVoiceView()
                } header: {
                    Text("select your voice")
                } footer: {
                    Text("Try different voices, to find which suits you best.")
                }
                Section {
                    SettingsVoiceRateView()
                } header: {
                    Text("select Your rate")
                } footer: {
                    Text("Try different speeds, to find which suits you best.")
                }
                Section(header: Text("Other")){
                    NavigationLink(destination: {
                        SettingsAIView()
                    }, label: {
                        Label {
                            Text("AI Settings")
                                .foregroundStyle(globals.isAISettingsViewHighlighted ? .blue : .primary)
                        } icon: {
                            Image(systemName: "sparkles")
                                .foregroundStyle(globals.isAISettingsViewHighlighted ? .blue : globals.color.dark)
                        }
                    })
                    NavigationLink(destination: {
                        SettingsColorView()
                    }, label: {
                        Label {
                            Text("Colorscheme")
                        } icon: {
                            Image(systemName: "paintpalette")
                        }
                    })
                    
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
            .background(globals.color.light)
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
            .toolbarBackground(globals.color.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .accentColor(globals.color.dark)
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
