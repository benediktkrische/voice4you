//
//  AISection.swift
//  voice4you
//
//  Created by Benedikt Krische on 25.05.24.
//

import SwiftUI

struct AISection: View {
    @EnvironmentObject var globals: Globals
    @Binding var isAIselected: Bool
    @Binding var apiAnswer: String
    @State var apiAnswerCharacters = ""
    @State var isAPICalling = false
    @Binding var isAlertPresented: Bool
    let timer = Timer.publish(every: 0.03, tolerance: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Section {
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        globals.generator.impactOccurred()
                        if(globals.openAIFreeRequests >= 1 || globals.openAIAPIKey != nil){
                            apiAnswer = ""
                            apiAnswerCharacters = ""
                            isAIselected = true
                            callAI()
                        }else{
                            isAlertPresented = true
                        }
                    }, label:{
                        HStack{
                            Image(systemName: "square.and.pencil")
                                .font(.title2)
                            Text("remake")
                                .font(.headline)
                        }
                        .padding()
                        .foregroundColor(Color("tabBar"))
                    })
                    Spacer()
                }
                if(isAPICalling || apiAnswer != ""){
                    Divider()
                    if(isAPICalling){
                        ProgressView()
                            .progressViewStyle(.circular)
                            .padding(.vertical)
                    }
                    if(apiAnswer != ""){
                        Text(apiAnswerCharacters)
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .padding()
                            .bold(isAIselected)
                            .foregroundStyle(!isAIselected ? .black : Color("tabBar"))
                            .onTapGesture {
                                globals.generator.impactOccurred()
                                isAIselected = true
                            }
                            .onReceive(timer) { _ in
                                if apiAnswerCharacters.count < apiAnswer.count {
                                    let index = apiAnswer.index(apiAnswer.startIndex, offsetBy: apiAnswerCharacters.count)
                                    apiAnswerCharacters.append(apiAnswer[index])
                                    if (apiAnswerCharacters.last == " ") {
                                        globals.generatorSoft.impactOccurred()
                                    }
                                    
                                }
                            }
                    }
                }
            }
        } header: {
            HStack{
                Image(systemName: "sparkles")
                Text("ai")
                Spacer()
                if (globals.openAIAPIKey == nil){
                    if (globals.openAIFreeRequests <= 0) {
                        Text("set OpenAI-Key")
                    }else{
                        Text("\(globals.openAIFreeRequests) free requests")
                    }
                }
            }
        } footer: {
            if(apiAnswer == "" && !isAPICalling){
                Text("Let AI remake your sentence")
            }else{
                Button("Clear AI answer"){
                    apiAnswer = ""
                    apiAnswerCharacters = ""
                    isAIselected = true
                }
                .font(.callout)
                .foregroundStyle(Color("tabBar"))
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .onAppear(perform: {
            if(globals.alwaysRemakeSentence){
                if(globals.openAIFreeRequests >= 1 || globals.openAIAPIKey != nil){
                    apiAnswer = ""
                    apiAnswerCharacters = ""
                    isAIselected = true
                    callAI()
                }
            }
        })
    }
    
    func callAI() {
        isAPICalling = true
        let openAICaller = OpenAICaller(openAIAPIKey: globals.openAIAPIKey, freeOpenAIAPIKey: globals.freeOpenAPIKey, openAIFreeRequests: $globals.openAIFreeRequests){ chatResult in
            DispatchQueue.main.async {
                globals.openAIChatResults.append(chatResult)
            }
        }
        Task(){
            apiAnswer = await openAICaller.processPrompt(prompt: globals.sentence.wordsAsString.joined(separator: " ")) ?? "some error"
            if (apiAnswer == "some error") {
                apiAnswer = ""
            }
            isAPICalling = false
        }
    }
}

#Preview {
    FinalText()
        .environmentObject(Globals())
}
