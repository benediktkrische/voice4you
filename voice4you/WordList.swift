//
//  WordList.swift
//  voice4you
//
//  Created by Benedikt Krische on 24.02.24.
//

import SwiftUI
import SwiftData

@available(iOS 17.0, *)
struct WordList: View {
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var globals: Globals
    @Query private var words: [Word]
    @State var searchText = ""
    
    var searchResults: [Word] {
        if searchText.isEmpty {
            return words
        } else {
            return words.filter { $0.name.contains(searchText) }
        }
    }
    
    init(categoryId: Int = -1){
        if(categoryId != -1){
            let filter: Predicate = #Predicate<Word> {$0.categoryId == categoryId}
            _words = Query(filter: filter, sort: [SortDescriptor(\Word.name)])
        }else{
            let filter: Predicate = #Predicate<Word> {$0.isStarred == true}
            _words = Query(filter: filter, sort: [SortDescriptor(\Word.name)])
        }
    }
    
    var body: some View {
        Group{
            if words.isEmpty{
                List{
                    Text("No words found")
                }
            }
            else{
                List{
                    ForEach(searchResults, id: \.name){ word in
                        Button(action:{
                            globals.undoSentence.append(globals.sentence)
                            globals.sentence.words.append(
                                SentenceWord(name: word.name, uuid: UUID()))
                            if (globals.selectedTab != .bookmark){
                                globals.path.removeLast()
                            }
                            globals.generator.impactOccurred()
                        }, label:{
                            Label(word.name, systemImage: "")
                                .labelStyle(LabelWithStar(word: word))
                                .foregroundStyle(Color.primary)
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    WordList(categoryId: 0)
}
