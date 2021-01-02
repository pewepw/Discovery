//
//  PopularDestinationsView.swift
//  Discovery
//
//  Created by Harry on 26/12/2020.
//

import SwiftUI
import MapKit

struct PopularDestinationsView: View {
    let destinations: [Destination] = [
        .init(name: "Paris", country: "France", imageName: "eiffel_tower", latitude: 48.859565, longitude: 2.353235),
        .init(name: "Tokyo", country: "Japan", imageName: "japan", latitude: 35.679653, longitude: 139.771913),
        .init(name: "New York", country: "USx", imageName: "new_york", latitude: 0, longitude: 0)
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

struct DestinationDetails: Decodable {
    let description: String
    let photos: [String]
}

class DestinationDetailsViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var destinationDetails: DestinationDetails?
    
    init(name: String) {
        let urlString = "https://travel.letsbuildthatapp.com/travel_discovery/destination?name=\(name.lowercased())".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: urlString) else {
            self.isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let data = data else { return }
                print(String(data: data, encoding: String.Encoding.utf8))
                
                do {
                    let details = try JSONDecoder().decode(DestinationDetails.self, from: data)
                    self.destinationDetails = details
                } catch {
                    
                }
            }
            
        }.resume()
    }
}

struct PopularDestinationDetailView: View {
    
    @ObservedObject var vm: DestinationDetailsViewModel
    
    let destination: Destination
    
    //@State var region = MKCoordinateRegion(center: .init(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    @State var region: MKCoordinateRegion
    @State var isShowingAttractions = true
    
    let attractions: [Attraction] = [
        .init(name: "Eiffel Tower", imageName: "eiffel_tower", latitude: 48.859565, longitude: 2.353235),
        .init(name: "Champs-Elysees", imageName: "new_york", latitude: 48.866867, longitude: 2.311780),
        .init(name: "Louvre Museum", imageName: "japan", latitude: 48.860288, longitude: 2.337789)
    ]
    
    init(destination: Destination) {
        self.destination = destination
        self._region = State(initialValue: MKCoordinateRegion(center: .init(latitude: destination.latitude, longitude: destination.longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        self.vm = .init(name: destination.name)
    }
    
    let imageUrlStrings = ["https://letsbuildthatapp-videos.s3.us-west-2.amazonaws.com/7156c3c6-945e-4284-a796-915afdc158b5",
                                  "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/b1642068-5624-41cf-83f1-3f6dff8c1702",
                                  "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/6982cc9d-3104-4a54-98d7-45ee5d117531",
                                  "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/2240d474-2237-4cd3-9919-562cd1bb439e"]
    
    var body: some View {
        ScrollView {
            /*
             TabView {
                 Text("first")
                 Text("second")
                 Text("third")
             }
             .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
             .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
             .frame(height: 250)
             */
            
            if let photos = vm.destinationDetails?.photos {
                DestinationHeaderContainer(imageUrlStrings: photos)
                     .frame(height: 250)
            }
            
            
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
                
                HStack {
                    Text(vm.destinationDetails?.description ?? "")
                        .padding(.top, 4)
                        .font(.system(size: 14))
                    Spacer()
                }
            }
            .padding(.horizontal)
            
            HStack {
                Text("Location")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                Button(action: {
                    isShowingAttractions.toggle()
                }, label: {
                    Text("\(isShowingAttractions ? "Hide" : "Show") Attractions")
                        .font(.system(size: 14, weight: .semibold))
                })
                Toggle("", isOn: $isShowingAttractions)
                    .labelsHidden()
            }.padding(.horizontal)
            Map(coordinateRegion: $region, annotationItems: isShowingAttractions ? attractions : [], annotationContent: { attraction in
                //MapMarker(coordinate: .init(latitude: attraction.latitude, longitude: attraction.longitude), tint: .blue)
                MapAnnotation(coordinate: .init(latitude: attraction.latitude, longitude: attraction.longitude)) {
                    CustomMapAnnotation(attraction: attraction)
                }
            })
            .frame(height: 400)
            
        }.navigationBarTitle(destination.name, displayMode: .inline)
    }
}

struct CustomMapAnnotation: View {
    
    let attraction: Attraction
    
    var body: some View {
        VStack {
            Image(attraction.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 60)
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.blue))
            Text(attraction.name)
                .font(.system(size: 14, weight: .semibold))
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.blue))
        }.shadow(radius: 5)
    }
}

struct Attraction : Identifiable {
    var id = UUID().uuidString
    
    let name, imageName: String
    let latitude, longitude: Double
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
            PopularDestinationDetailView(destination: .init(name: "Paris", country: "France", imageName: "eiffel_tower", latitude: 48.859565, longitude: 2.353235))
        }
        PopularDestinationsView()
    }
}
