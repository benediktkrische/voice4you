//
//  APICaller.swift
//  voice4you
//
//  Created by Benedikt Krische on 23.05.24.
//

import Foundation
import OpenAI
import SwiftUI


public class OpenAICaller{
    private let openAI: OpenAI?
    let saveResult: (_ chatResult: ChatResult) -> Void
    
    init(openAIAPIKey: String?, freeOpenAIAPIKey: String?, openAIFreeRequests: Binding<Int>, saveResult: @escaping (_ chatResult: ChatResult) -> Void){
        
        if openAIAPIKey != nil{
            self.openAI = OpenAI(apiToken: openAIAPIKey!)
        }else {
            if(freeOpenAIAPIKey != nil){
                self.openAI = OpenAI(apiToken: freeOpenAIAPIKey!)
                openAIFreeRequests.wrappedValue -= 1
            }else{
                self.openAI = nil
            }
        }
        self.saveResult = saveResult
    }
    
    public func processPrompt(prompt: String) async -> String? {
        if openAI == nil{
            print("openai = nil")
            return nil
        }
        var resultString: String?
        let query = ChatQuery(messages: [.init(role: .system, content: "You are a language assistant. You will receive a sentence, that is made of words, that are not particularly grammatically correct. Please correct the grammar and spelling and give me a logical sentence, that for the most part the identical words.")!, .init(role: .user, content: prompt)!], model: .gpt3_5Turbo)
        do{
            let result = try await openAI!.chats(query: query)
            saveResult(result)
            resultString = result.choices[0].message.content?.string
        }catch{
            print("error: ")
            print(query)
            print(resultString ?? "")
        }
        return resultString
    }
    
    public func testKey() async -> Bool {
        if openAI == nil{
            return false
        }
        let query = ChatQuery(messages: [.init(role: .system, content: "Test")!], model: .gpt3_5Turbo)
        do{
            let result = try await openAI!.chats(query: query)
            if (result.usage != nil){
                if (result.usage!.totalTokens >= 1){
                    return true
                }
            }
        }catch{
            return false
        }
        return false
    }
}
