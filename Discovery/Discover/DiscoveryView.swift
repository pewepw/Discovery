//
//  DiscoveryView.swift
//  Discovery
//
//  Created by Harry on 25/12/2020.
//

import SwiftUI

extension Color {
    static let discoverBackground = Color(.init(white: 0.95, alpha: 1))
    static let defaultBackground = Color("defaultBackground")
    static let tileBackground = Color("tileBackground")
}

struct DiscoveryView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)), Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                Color.discoverBackground
                    .offset(y: 400)
                ScrollView {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("where do you want to go?")
                        Spacer()
                    }.font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.init(white: 1, alpha: 0.3)))
                    .cornerRadius(10)
                    .padding(16)
                    
                    DiscoverCategoriesView()
                    
                    VStack {
                        PopularDestinationsView()
                        PopularRestaurantsView()
                        TrendingCreatorsView()
                    }
                    .background(Color.defaultBackground)
                    //.background(colorScheme == .light ? Color.white : Color.black)
                    .cornerRadius(16)
                    .padding(.top, 32)
                }
            }
            .navigationTitle("Discover")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveryView()
            .colorScheme(.dark)
        DiscoveryView()
            .colorScheme(.light)
    }
}
