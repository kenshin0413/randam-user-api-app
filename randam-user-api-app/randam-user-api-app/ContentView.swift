//
//  ContentView.swift
//  randam-user-api-app
//
//  Created by miyamotokenshin on R 7/07/01.
//

import SwiftUI

struct ContentView: View {
    @State var result: [Result] = []
    
    var body: some View {
        List {
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
            guard let url = URL(string: "https://randomuser.me/api/?results=10") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(APIResponse.self, from: data)
            result = decodedData.results
        } catch {}
    }
}

#Preview {
    ContentView()
}
