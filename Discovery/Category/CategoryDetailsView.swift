//
//  CategoryDetailsView.swift
//  Discovery
//
//  Created by Harry on 27/12/2020.
//

import SwiftUI
import KingfisherSwiftUI
import SDWebImageSwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

class CategoryDetailsViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var places = [Place]()
    @Published var errorMessage = ""
    
    init(name: String) {
        let urlString = "https://travel.letsbuildthatapp.com/travel_discovery/category?name=\(name.lowercased())".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: urlString) else {
            self.isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 400 {
                    self.isLoading = false
                    self.errorMessage = "Bad status: \(statusCode)"
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    self.places = try JSONDecoder().decode([Place].self, from: data)
                } catch {
                    print("Failed to decode JSON:", error)
                    self.errorMessage = error.localizedDescription
                }
                
                self.isLoading = false
            }
            
        }.resume()
        
    }
}

struct CategoryDetailsView: View {
    
    let name: String
    @ObservedObject private var vm:  CategoryDetailsViewModel
    
    init(name: String) {
        self.name = name
        self.vm = .init(name: name)
    }
    
    //let name: String
    //@ObservedObject var vm = CategoryDetailsViewModel()
    
    var body: some View {
        ZStack {
            if vm.isLoading {
                VStack {
                    ActivityIndicatorView()
                    Text("Loading...")
                        .foregroundColor(Color.white)
                        .font(.system(size: 16, weight: .semibold))
                }.padding()
                .background(Color.black)
                .cornerRadius(8)
            } else {
                if !vm.errorMessage.isEmpty {
                    VStack {
                        Image(systemName: "xmark.octagon.fill")
                            .font(.system(size: 64, weight: .semibold))
                            .foregroundColor(.red)
                        Text(vm.errorMessage)
                    }
                }
                
                ScrollView {
                    ForEach(vm.places, id: \.self) { place in
                        VStack(alignment: .leading, spacing: 0) {
                            WebImage(url: URL(string: place.thumbnail))
                                .resizable()
                                .indicator(.activity)
                                .transition(.fade(duration: 1))
                                .scaledToFill()
                            Text(place.name)
                                .font(.system(size: 12, weight: .semibold))
                                .padding()
                        }.asTile()
                        .padding()
                    }
                }
            }
        }.navigationBarTitle(name, displayMode: .inline)
    }
}

struct CategoryDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoryDetailsView(name: "TITLE")
        }
    }
}
