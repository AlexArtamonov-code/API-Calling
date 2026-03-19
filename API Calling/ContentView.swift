//
//  ContentView.swift
//  API Calling
//
//  Created by Alex Artamonov on 3/19/26.
//

import SwiftUI


struct MemeResponse: Codable {
    let data: MemeData
}

struct MemeData: Codable {
    let memes: [Meme]
}

struct Meme: Codable, Identifiable {
    let id: String
    let name: String
    let url: String
}


struct ContentView: View {
    var body: some View {
        Text("Hello World")
    }
}
#Preview {
    ContentView()
}
