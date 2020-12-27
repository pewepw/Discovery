//
//  PopularDestinationsView.swift
//  Discovery
//
//  Created by Harry on 26/12/2020.
//

import SwiftUI

struct PopularDestinationsView: View {
    let destinations: [Destination] = [
        .init(name: "Paris", country: "France", imageName: "eiffel_tower"),
        .init(name: "Tokyo", country: "Japan", imageName: "japan"),
        .init(name: "New York", country: "USx", imageName: "new_york")
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Popular Destination")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Text("See all")
                    .font(.system(size: 12, weight: .semibold))
            }.padding(.horizontal)
            .padding(.top)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(destinations, id: \.self) { destination in
                        NavigationLink(
                            destination: NavigationLazyView(PopularDestinationDetailView(destination: destination)),
                            label: {
                                PopularDestinationTile(destination: destination)
                            })
                    }
                }.padding(.horizontal)
            }
        }
    }
}

struct PopularDestinationDetailView: View {
    
    let destination: Destination
    
    var body: some View {
        ScrollView {
            Image(destination.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()
            VStack(alignment: .leading) {
                Text(destination.name)
                    .font(.system(size: 18, weight: .bold))
                Text(destination.country)
                HStack {
                    ForEach(0..<5, id: \.self) { num in
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                    }
                }.padding(.top, 2)
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                    .padding(.top, 4)
                HStack { Spacer() }
            }
            .padding(.horizontal)
        }.navigationBarTitle(destination.name, displayMode: .inline)
    }
}

struct PopularDestinationTile: View {
    
    let destination: Destination
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(destination.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 125, height: 125)
                .cornerRadius(5)
                .padding(.horizontal, 6)
                .padding(.vertical, 6)
            Text(destination.name)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(.label))
                .padding(.horizontal, 12)
            Text(destination.country)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(.label))
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
        }
        .asTile()
        .padding(.top, 4)
        .padding(.bottom)
    }
}

struct PopularDestinationsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PopularDestinationDetailView(destination: .init(name: "Paris", country: "France", imageName: "eiffel_tower"))
        }
        PopularDestinationsView()
    }
}
