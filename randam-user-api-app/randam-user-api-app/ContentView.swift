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
    @State var showErrorAlert = false
    @State var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            List {
                Stepper(value: $userCount, step: 1) {
                    Text("取得するユーザー数: \(userCount)")
                }
                .onChange(of: userCount) {
                    Task {
                        await getData()
                    }
                }
                
                ForEach(result) { person in
                    NavigationLink(destination: UserInfoView(person: person)) {
                        LabeledContent {
                            Text(person.fullname)
                        } label: {
                            Text("name")
                        }
                    }
                }
            }
            .task {
                await getData()
            }
            .alert("エラー", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    struct APIResponse: Codable {
        let results: [Result]
    }
    
    func getData() async {
        do {
            guard let url = URL(string: "https://randomuser.me/api/?results=\(userCount)") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            let decode = try JSONDecoder().decode(APIResponse.self, from: data)
            result = decode.results
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }
}
// IdentifiableはList,ForEachなどでidを省略できる
struct Result: Codable, Identifiable {
    // let だと警告が出る
    var id = UUID()
    let name: Name
    let location: Location
    let email: String
    
    private enum CodingKeys: CodingKey {
        case name, location, email  // ← id を除外する
    }
    
    var fullname: String {
        "\(name.title) \(name.first) \(name.last)"
    }
}

struct Name: Codable {
    let title, first, last: String
}

struct Location: Codable {
    let country: String
    let state: String
    let city: String
}

#Preview {
    ContentView()
}
