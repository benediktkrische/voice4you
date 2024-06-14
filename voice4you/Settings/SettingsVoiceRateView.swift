//
//  VoiceSpeedView.swift
//  voice4you
//
//  Created by Benedikt Krische on 15.05.24.
//

import SwiftUI

struct SettingsVoiceRateView: View {
    @EnvironmentObject var globals: Globals
    @State var isEditing = false
    @State var isAlert = false
    @State var showText = false
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Image(systemName: "tortoise.fill")
                        .foregroundStyle(globals.color.dark)
                    Slider(value: $globals.voiceRate, in: 0.3...1.8, step: 0.1, onEditingChanged: { editing in
                        isEditing = editing
                    })
                    .accentColor(globals.color.dark)
                    Image(systemName: "hare.fill")
                        .foregroundStyle(globals.color.dark)
                }
                Text("\(globals.voiceRate.magnitude, specifier: "%.1f")")
                    .foregroundColor(globals.color.dark)
                    .font(.title2)
            }
            .padding(showText ? 20 : 5)
            .background(showText ? Color(UIColor.systemBackground) : nil)
        }
        .clipShape(RoundedRectangle(cornerRadius: showText ? 10 : 0))
        .padding(.horizontal, showText ? 20 : 0)
        .onChange(of: isEditing) {
            if(!isEditing){
                Task() {
                    do {
                        try await globals.save()
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
            
        if(showText){
            Text("Here you can change the speed of your voice. Try different speeds, to find which suits you best")
                .padding(.horizontal, 25)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    MainView(saveAction: {})
        .environmentObject(Globals())
}
