//
//  screen1.swift
//  voice4you
//
//  Created by Benedikt Krische on 06.12.23.
//

import SwiftUI
import SwiftData

@available(iOS 17.0, *)
struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var globals: Globals
    @State var isShowingConfirmationAlert = false
    let saveAction: () -> Void
    
    var body: some View {
        NavigationStack(path: $globals.path){
            VStack{
                ZStack{
                    TabView(selection: $globals.selectedTab,
                            content:  {
                        TabPage0()
                            .tag(Tab.nouns)
                        TabPage1()
                            .tag(Tab.verbs)
                        TabPage2()
                            .tag(Tab.adjectives)
                        TabPage3()
                            .tag(Tab.bubble)
                        TabPage4()
                            .tag(Tab.bookmark)
                    })
                    
                    VStack{
                        Spacer()
                        LinearGradient(stops: [
                            Gradient.Stop(color: .init(white: 1, opacity: 0), location: 0),
                            Gradient.Stop(color: Color("bgd"), location: 1),
                        ], startPoint: .top, endPoint: .bottom)
                        .frame(height: 20)
                    }
                     
                    
                }
                
                .tabViewStyle(.page(indexDisplayMode: .never))
                TabBar()
                    .padding(.bottom)
            }
            .background(Color("bgd"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            //Items toolbar
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        globals.isShowingSettings.toggle()
                    }, label: {
                        Label("Settings", systemImage: "gear")
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        globals.generator.impactOccurred()
                        withAnimation(.bouncy){
                            globals.sentence = globals.undoSentence.removeLast()
                        }
                    }, label: {
                        Label("Undo", systemImage: "arrow.uturn.backward")
                    })
                    .disabled(globals.undoSentence == [])
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        globals.generator.impactOccurred()
                        isShowingConfirmationAlert = true
                    }, label: {
                        Label("Delete all", systemImage: "trash")
                    })
                }
            }
            .confirmationDialog("Do you really want to delete all words?", isPresented: $isShowingConfirmationAlert, titleVisibility: .visible) {
                Button("Delete all", role: .destructive) {
                    globals.generator.impactOccurred()
                    globals.undoSentence.append(globals.sentence)
                    withAnimation(.bouncy){
                        globals.sentence = Sentence(words: [])
                    }
                    isShowingConfirmationAlert = false
                }
                Button("Cancel", role: .cancel) {
                    isShowingConfirmationAlert = false
                }
            }
            //disable dark mode
            .preferredColorScheme(.light)
            //Color toolbar
            .toolbarBackground(Color("tabBar"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            //Color Stack
            .background(Color("bgd"))
            .scrollContentBackground(.hidden)
            .ignoresSafeArea(edges: .bottom)
            .navigationDestination(for: Category.self){ category in
                CategoryView(tab: globals.selectedTab, category: category)
            }
            .fullScreenCover(isPresented: $globals.isPresentedFinalText) {
                FinalText()
            }
            .sheet(isPresented: $globals.isShowingSettings, content: {
                SettingsView()
            })
            .onChange(of: scenePhase) {_, newPhase in
                if newPhase == .inactive || newPhase == .background {
                    saveAction()
                }
            }
            .searchable(text: $globals.searchText)
        }
    }
}

#Preview {
    MainView(saveAction: {})
        .environmentObject(Globals())
        .modelContainer(voice4youApp().sharedModelContainer)
}
