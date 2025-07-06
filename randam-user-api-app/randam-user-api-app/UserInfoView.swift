//
//  UserInfoView.swift
//  randam-user-api-app
//
//  Created by miyamotokenshin on R 7/07/04.
//

import SwiftUI

struct UserInfoView: View {
    let person: ContentView.Result
    var body: some View {
        Form {
            Section(header: Text("NAME")) {
                Text(person.fullname)
            }
            
            Section(header: Text("LOCTION")) {
                LabeledContent {
                    Text(person.location.country)
                } label: {
                    Text("country")
                }
                
                LabeledContent {
                    Text(person.location.state)
                } label: {
                    Text("state")
                }
                
                LabeledContent {
                    Text(person.location.city)
                } label: {
                    Text("city")
                }
            }
            
            Section(header: Text("EMAIL")) {
                Text(person.email)
            }
        }
    }
}

#Preview {
    UserInfoView(person: ContentView.Result(
        name: ContentView.Name(title: "", first: "", last: ""),
        location: ContentView.Location(country: "", state: "", city: ""),
        email: ""))
}
