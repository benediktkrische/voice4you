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
    @State var uuid: UUID?
    
    var body: some View {
        Button(action: {
            uuid = word.uuid
            changingWord = word.name
            isShowingChangeAlert = true
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
        .alert("Change the Word", isPresented: $isShowingChangeAlert) {
            TextField("new Word", text: $changingWord)
            Button("Cancel") {
                isShowingChangeAlert = false
            }
            Button(action: {
                globals.generator.impactOccurred()
                globals.undoSentence.append(globals.sentence)
                withAnimation(.bouncy){
                    globals.sentence.words.removeAll { $0.uuid == uuid }
                }
                isShowingChangeAlert = false
            }, label: {
                Text("Delete")
            })
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
                globals.sentence.words.insert(SentenceWord(name: changingWord, uuid: UUID()), at: globals.sentence.words.firstIndex { $0.uuid == uuid}!)
                globals.sentence.words.removeAll { $0.uuid == uuid }
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
