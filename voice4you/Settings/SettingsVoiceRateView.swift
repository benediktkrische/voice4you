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
            .padding(showText ? 20 : 5)
            .background(showText ? Color(UIColor.systemBackground) : nil)
        }
        .clipShape(RoundedRectangle(cornerRadius: showText ? 10 : 0))
        .padding(.horizontal, showText ? 20 : 0)
            
        if(showText){
            Text("Here you can change the speed of your voice. Try different speeds, to find which suits you best")
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
