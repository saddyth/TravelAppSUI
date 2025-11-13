//
//  ContentView.swift
//  TravelAppSwiftUI
//
//  Created by pulino4ka on 14.10.2025.
//


import SwiftUI

struct ContentView: View {
    @State private var path: [Screen] = []
    @State var discoverVM = DiscoverViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geo in
                VStack() {
                    Image(.main)
                        .resizable()
                        .scaledToFill()
                        .frame(height: geo.size.height * 0.5)
                        .clipped()
                        .overlay {
                            Image(.main)
                                .resizable()
                                .scaledToFill()
                                .frame(height: geo.size.height * 0.6)
                                .clipShape(RoundedRectangle(cornerRadius: 37))
                        }
                    MainViewContent(path: $path)
                        .padding(.top, geo.size.height * 0.044)
                }
                .ignoresSafeArea()
                .navigationDestination(for: Screen.self) { page in
                    switch page {
                    case .discover:
                        DiscoverView(discoverVM: discoverVM, path: $path)
                    case .detail(let productIndex):
                        ProductDetailView(discoverVM: discoverVM, product: $discoverVM.products[productIndex])
                    case .logIn:
                        LoginView(path: $path)
                    case .registration:
                        RegistrationView()
                    case .profile:
                        ProfileView()
                    }
                }
                .onChange(of: authViewModel.userSession) { oldValue, newValue in
                    if newValue != nil {
                        path = [.profile]
                    } else {
                        path = [.logIn]
                    }
                }
            }
            
        }
       
    }
}

struct MainViewContent: View {
    @Binding var path: [Screen]
    var body: some View {
        GeometryReader { geo in
            VStack{
                VStack(spacing: geo.size.height * 0.08) {
                    Text("Winter \nVacation Trips")
                        .merriweather(type: .bold, size: 36)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 38)
                        .padding(.top, 30)
                    Text("Enjoy your winter vacations with warmth\nand amazing sightseeing on the mountains.\nEnjoy the best experience with us!")
                        .sourceSans3(type: .regular, size: 16)
                        .minimumScaleFactor(0.7)
                        .lineSpacing(4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 38)
                }
                
                HStack{
                    Button(action: {
                        path.append(.discover)
                    }, label: {
                        HStack(spacing: 12) {
                            Text("Let's Go")
                                .merriweather(type: .regular, size: 16)
                                .foregroundStyle(.white)
                            Image(.rightArrowWhite)
                        }
                        .frame(width: geo.size.width * 0.43, height: 50)
                    })
                    .background(.main)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding(.leading, 38)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, geo.size.height * 0.08)
            }
        }
    }
}

#Preview {
    ContentView()
}

