//
//  Support.swift
//  voice4you
//
//  Created by Benedikt Krische on 15.05.24.
//

import SwiftUI

struct Support: View {
    @EnvironmentObject var globals: Globals
    
    var body: some View {
        VStack{
            Text("If you have any questions, please contact us at:")
                .font(.body)
                .foregroundColor(.secondary)
            Text("benedikt.krische@edu.htl-klu.at")
            .tint(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(globals.color.dark)
            .cornerRadius(10)
            .padding(.horizontal)
            .onTapGesture {
                UIApplication.shared.open(URL.init(string: "mailto:benedikt.krische@edu.htl-klu.at?subject=Support%20for%20voice4you")!)
            }
            
            Text("For more information visit:")
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.top)
            Text("Github - Voice4you")
            .frame(maxWidth: .infinity)
            .padding()
            .background(globals.color.dark)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .onTapGesture(perform: {
                UIApplication.shared.open(URL.init(string: "https://github.com/benediktkrische/voice4you")!)
            })
            
        }
    }
}

#Preview {
    Support()
        .environmentObject(Globals())
}
