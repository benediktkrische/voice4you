//
//  CategoryList.swift
//  voice4you
//
//  Created by Benedikt Krische on 25.02.24.
//

import SwiftUI
import SwiftData

@available(iOS 17, *)
struct CategoryList: View {
    @EnvironmentObject var globals: Globals
    @State var categories: [Category]
    @Query(filter: #Predicate<Word> {$0.categoryId != 1000}, sort: [SortDescriptor(\Word.name)])
    private var words: [Word]
    
    var searchResultsCategory: [Category] {
        if globals.searchText.isEmpty {
            return categories
        } else {
            return categories.filter { $0.name.lowercased().contains(globals.searchText.lowercased()) }
        }
    }
    
    var searchResultsWord: [Word] {
        if globals.searchText.isEmpty {
            return words
        } else {
            return words.filter { $0.name.lowercased().contains(globals.searchText.lowercased()) }
        }
    }
    
    var body: some View {
        List{
            Section("Choose a category"){
                if searchResultsCategory.isEmpty{
                    Text("No categories found")
                }
                else{
                    ForEach(searchResultsCategory, id: \.name){ category in
                        NavigationLink(value: category) {
                            Label(category.name, systemImage: category.sfSymbolName)
                                .foregroundStyle(Color.black)
                                .labelStyle(DetailedLabelStyle(description: category.labelDescription))
                        }
                    }
                }
            }
            if !globals.searchText.isEmpty {
                Section("Choose a word"){
                    if searchResultsWord.isEmpty{
                        Text("No words found")
                    }
                    else{
                        ForEach(searchResultsWord, id: \.name){ word in
                            Label(word.name, systemImage: "")
                                .labelStyle(LabelWithStar(word: word))
                                .onTapGesture(perform: {
                                    globals.sentence.words.append(
                                        SentenceWord(name: word.name, uuid: UUID()))
                                    globals.searchText = ""
                                })
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CategoryList(categories: [])
        .environmentObject(Globals())
}
