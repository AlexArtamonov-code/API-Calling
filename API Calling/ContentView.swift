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
    
    @State private var memes: [Meme] = []
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            List(memes) { meme in
                VStack(alignment: .leading) {
                    Text(meme.name)
                    Text(meme.url).font(.caption)
                }
            }
            .navigationTitle("Memes")
            .onAppear {
                loadData()
            }
        }
    }
    
    func loadData() {
        guard let url = URL(string: "https://api.imgflip.com/get_memes") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(MemeResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.memes = decoded.data.memes
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to decode data"
                    }
                }
            }
        }.resume()
    }
}
#Preview {
    ContentView()
}
