//
//  ButtonView.swift
//  voice4you
//
//  Created by Benedikt Krische on 29.04.24.
//

import SwiftUI

struct ButtonView: View {
    @EnvironmentObject var globals: Globals
    @State var word: SentenceWord
    @State var changingWord = ""
    @State var isShowingChangeAlert = false
    @State var isShowingConfirmationAlert = false
    
    var body: some View {
        Button(action: {
            changingWord = word.name
            isShowingConfirmationAlert = true
        }, label: {
            Text(word.name)
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color(UIColor.tertiarySystemFill))
                        .frame(width: nil, height: 30)
                )
                .foregroundStyle(Color.primary)
        })
        .opacity(word.hidden ? 0.5 : 1)
        .confirmationDialog("Your word: " + word.name, isPresented: $isShowingConfirmationAlert, titleVisibility: .visible) {
            Button("Change Word") {
                isShowingChangeAlert = true
            }
            Button("Delete Word", role: .destructive) {
                globals.generator.impactOccurred()
                globals.undoSentence.append(globals.sentence)
                withAnimation(.bouncy){
                    globals.sentence.words.removeAll { $0.uuid == word.uuid }
                }
                isShowingChangeAlert = false
            }
            
        }
        .alert("Change the Word", isPresented: $isShowingChangeAlert) {
            TextField("new Word", text: $changingWord)
            Button("Cancel", role: .cancel) {
                isShowingChangeAlert = false
            }
            Button(action: {
                var changed = false
                if(changingWord != word.name){
                    globals.undoSentence.append(globals.sentence)
                    changed = true
                }
                if(changingWord == ""){
                    changingWord = word.name
                    changed = false
                }
                if(changed){
                    globals.generator.impactOccurred()
                }
                globals.sentence.words.insert(SentenceWord(name: changingWord, uuid: UUID()), at: globals.sentence.words.firstIndex { $0.uuid == word.uuid}!)
                globals.sentence.words.removeAll { $0.uuid == word.uuid }
                isShowingChangeAlert = false
            }, label: {
                Text("Safe")
            })
        }
 
    }
}

#Preview {
    ButtonView(word: SentenceWord(name: "Test", uuid: UUID()))
        .environmentObject(Globals())
}
