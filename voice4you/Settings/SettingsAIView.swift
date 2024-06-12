//
//  SettingsAIView.swift
//  voice4you
//
//  Created by Benedikt Krische on 25.05.24.
//

import SwiftUI
import Security

struct SettingsAIView: View {
    @EnvironmentObject var globals: Globals
    @State var apiRequests: Int = 0
    @State var completionTokens: Int = 0
    @State var promtTokens: Int = 0
    @State var totalTokens: Int = 0
    @State var isAPIKeyAdding: Bool = false
    @State var key: String = ""
    
    var body: some View {
        List{
            Section {
                Toggle("AI enabled", isOn: $globals.isAIEnabled)
            }
            Section {
                Toggle("Always remake sentence", isOn: $globals.alwaysRemakeSentence)
            } footer: {
                Text("If enabled, the AI will automaticly remake the sentence")
            }
            Section {
                if (globals.openAIAPIKey == nil){
                    Button(){
                        withAnimation(.bouncy){
                            key = ""
                            isAPIKeyAdding.toggle()
                        }
                    } label: {
                        HStack{
                            Image(systemName: "key.fill")
                            Text("Add API Key")
                        }
                    }
                    .foregroundStyle(Color("tabBar"))
                    if(isAPIKeyAdding){
                        HStack{
                            TextField("API Key", text: $key)
                                .keyboardType(.asciiCapable)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .onSubmit {
                                    saveAPIKey()
                                }
                            Button("Submit"){
                                saveAPIKey()
                            }
                            .foregroundStyle(Color("tabBar"))
                        }
                    }
                }else{
                    HStack{
                        Label {
                            Text("Your API key is set")
                        } icon: {
                            Image(systemName: "checkmark.circle")
                                .foregroundStyle(.green)
                        }
                        Spacer()
                        Button("Reset"){
                            globals.openAIAPIKey = nil
                        }
                        .foregroundStyle(Color("tabBar"))
                    }
                }
            } header: {
                Text("API Key")
                    .foregroundStyle(.primary)
            } footer: {
                    Text("The API key is required to access the OpenAI API. If you don't have one, you can get one at [openai.com](https://openai.com).")
            }
            Section {
                HStack{
                    Text("Free API requests available")
                        .foregroundStyle(.primary)
                    Spacer()
                    Text("\(globals.openAIFreeRequests)")
                        .foregroundStyle(Color(UIColor(.secondary)))
                }
                HStack{
                    Text("Total API requests")
                        .foregroundStyle(.primary)
                    Spacer()
                    Text("\(apiRequests)")
                        .foregroundStyle(Color(UIColor(.secondary)))
                }
                HStack{
                    Text("Completion tokens")
                        .foregroundStyle(.primary)
                    Spacer()
                    Text("\(completionTokens)")
                        .foregroundStyle(Color(UIColor(.secondary)))
                }
                HStack{
                    Text("Prompt tokens")
                        .foregroundStyle(.primary)
                    Spacer()
                    Text("\(promtTokens)")
                        .foregroundStyle(Color(UIColor(.secondary)))
                }
                HStack{
                    Text("Total tokens")
                        .foregroundStyle(.primary)
                    Spacer()
                    Text("\(totalTokens)")
                        .foregroundStyle(Color(UIColor(.secondary)))
                }
            } header: {
                Text("API Usage")
                    .foregroundStyle(.primary)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("bgd"))
        .navigationTitle("AI Settings")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color("tabBar"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .task() {
            apiRequests = 0
            completionTokens = 0
            promtTokens = 0
            totalTokens = 0
            for result in globals.openAIChatResults{
                apiRequests += 1
                completionTokens += result.usage?.completionTokens ?? 0
                promtTokens += result.usage?.promptTokens ?? 0
                totalTokens += result.usage?.totalTokens ?? 0
            }
        }
    }
    func saveAPIKey(){
        if key != ""{
            print(key)
            let ai = OpenAICaller.init(openAIAPIKey: key, freeOpenAIAPIKey: nil, openAIFreeRequests: .constant(30)) {chatResult in
            }
            Task(){
                if(await ai.testKey()){
                    globals.openAIAPIKey = key
                    globals.generatorSoft.impactOccurred()
                }
                else{
                    print("key error accured")
                    globals.generatorError.impactOccurred()
                }
            }
        }
        withAnimation(.bouncy){
            isAPIKeyAdding.toggle()
        }
    }
}

#Preview {
    SettingsAIView()
        .environmentObject(Globals())
}
