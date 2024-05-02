//
//  ScrollSentence.swift
//  voice4you
//
//  Created by Benedikt Krische on 29.04.24.
//

import SwiftUI

struct ScrollSentence: View {
    @EnvironmentObject var globals: Globals
    @State var isShowingChangeAlert = false
    @State var changingWord = ""
    @State var index: Int? = 0
    @State var beforeDragging: Sentence?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            LazyHGrid(rows: [GridItem(.fixed(20))], content: {
                ForEach(globals.sentence.words, id:\.uuid){ word in
                    ButtonView(word: word)
                        .draggable(word){
                            ButtonView(word: word)
                                .onAppear(perform: {
                                    globals.draggingItem = word
                                    beforeDragging = globals.sentence
                                    globals.generator.impactOccurred()
                                })
                        }                        
                        .dropDestination(for: SentenceWord.self, action: { droppedSentenceWords, location in
                            if(beforeDragging != globals.sentence){
                                globals.undoSentence.append(beforeDragging!)
                            }
                            globals.draggingItem = nil
                            globals.generator.impactOccurred()
                            return true
                        }, isTargeted: { status in
                            if let _ = globals.draggingItem, status, globals.draggingItem!.uuid != word.uuid{
                                if let sourceIndex = globals.sentence.words.firstIndex(where: { $0.uuid == globals.draggingItem!.uuid }){
                                    let destinationIndex = globals.sentence.words.firstIndex ( where: { $0.uuid == word.uuid })
                                    withAnimation(.bouncy){
                                        unhideAll()
                                        var sourceItem = globals.sentence.words.remove(at: sourceIndex)
                                        sourceItem.hidden = true
                                        globals.sentence.words.insert(sourceItem, at: destinationIndex!)
                                        globals.generator.impactOccurred()
                                    }
                                }
                            }
                        }
                        )
                }
                CustomWordButton()
            }
            )
            .frame(width: nil, height: 30)
            .padding(.horizontal)
        }
    }
    func unhideAll(){
        for i in 0...globals.sentence.words.count-1{
            globals.sentence.words[i].hidden = false
        }
    }
}
#Preview {
    ScrollSentence()
        .environmentObject(Globals())
}
