//
//  CustomWordButton.swift
//  voice4you
//
//  Created by Benedikt Krische on 29.04.24.
//

import SwiftUI

struct CustomWordButton: View {
    @EnvironmentObject var globals: Globals
    @State private var isShowingAlert = false
    @State private var answerText = ""
    
    var body: some View {
        Button(action: {
            globals.generator.impactOccurred()
            isShowingAlert = true
        }, label: {
            Image(systemName: "keyboard")
                .padding(.horizontal, 10)
                .foregroundStyle(Color.primary)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color(UIColor.tertiarySystemFill))
                        .frame(width: nil, height: 30)
                )
        })
        .alert("Custom Word", isPresented: $isShowingAlert) {
            TextField("Enter your word", text: $answerText)
            Button("Cancel", role: .cancel) {
                isShowingAlert = false
                answerText = ""
            }
            Button(action: {
                globals.undoSentence.append(globals.sentence)
                globals.sentence.words.append(SentenceWord(name: answerText, uuid: UUID()))
                isShowingAlert = false
                answerText = ""
            }, label: {
                Text("Add")
            })
        }
    }
    
}

#Preview {
    CustomWordButton()
        .environmentObject(Globals())
}
