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


struct MemeDetailView: View {
    let meme: Meme
    
    var body: some View {
        VStack {
            Text(meme.name)
                .font(.title)
                .padding()
            
            AsyncImage(url: URL(string: meme.url)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
        }
        .padding()
    }
}


struct ContentView: View {
    
    @State private var memes: [Meme] = []
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            List(memes) { meme in
                
                // 👇 CLICKABLE ROW
                NavigationLink(destination: MemeDetailView(meme: meme)) {
                    VStack(alignment: .leading) {
                        Text(meme.name)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Memes")
            .onAppear {
                loadData()
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
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
                        self.showError = true
                    }
                }
            }
        }.resume()
    }
}
#Preview {
    ContentView()
}
