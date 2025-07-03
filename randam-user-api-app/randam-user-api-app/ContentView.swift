//
//  ContentView.swift
//  randam-user-api-app
//
//  Created by miyamotokenshin on R 7/07/01.
//

import SwiftUI

struct ContentView: View {
    @State var result: [Result] = []
    @State var userCount: Int = 1
    func incrementStep() {
        userCount += 1
        Task {
            await getData()
        }
    }
    
    func decrementStep() {
        if 0 < userCount {
            userCount -= 1
            result.removeLast()
        }
    }
    
    var body: some View {
        List {
            Stepper(onIncrement: incrementStep,
                    onDecrement: decrementStep) {
                Text("取得するユーザー数: \(userCount)")
            }
            // resultの中の要素を1つずつpersonとして受け取る
            ForEach(result) { person in
                LabeledContent {
                    Text(person.fullname)
                } label: {
                    Text("name")
                }
            }
        }
        .task {
            await getData()
        }
    }
    
    struct APIResponse: Codable {
        // "results": [値] apiがこの形 だから[Result]
        let results: [Result]
    }
    // IdentifiableはList,ForEachなどでidを省略できる
    struct Result: Codable, Identifiable {
        // let だと警告が出る
        var id = UUID()
        let name: Name
        private enum CodingKeys: CodingKey {
            case name  // ← id を除外する
        }
        var fullname: String {
            "\(name.title) \(name.first) \(name.last)"
        }
    }
    
    struct Name: Codable {
        let title, first, last: String
    }
    
    func getData() async {
        do {
            guard let url = URL(string: "https://randomuser.me/api/?results=\(userCount)") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            let decode = try JSONDecoder().decode(APIResponse.self, from: data)
            result = decode.results
        } catch {}
    }
}

#Preview {
    ContentView()
}
