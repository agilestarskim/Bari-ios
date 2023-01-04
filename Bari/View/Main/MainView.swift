//
//  MainView.swift
//  Bari
//
//  Created by 김민성 on 2022/12/20.
//

import SwiftUI
import CoreLocation
import LinkNavigator

struct MainView: View {
    
    @StateObject var vm: MainViewModel
    @StateObject var mapVm = MapViewModel()
    
    var body: some View {
        VStack{
            GeometryReader{ proxy in
                MapView(vm: mapVm)
                    .environment(\.mainWindowSize, proxy.size)
            }
        }
        .sheet(isPresented: $vm.showingSheet) {
            switch vm.selectedSheet {
            case .friends:
                FriendsView()
            case .message:
                MessageView()
            case .profile:
                ProfileView(mapVm: mapVm)
            }
        }
        .ignoresSafeArea()
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 30) {
                Button {
                    vm.selectedSheet = .friends
                } label: {
                    Image(systemName: "person.2.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.primary)
                        .frame(width: 40, height: 40)
                        .modifier(ConvexGlassView())
                }
   
                Button{
                    vm.selectedSheet = .message
                } label: {
                    Image(systemName: "message.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.primary)
                        .frame(width: 40, height: 40)
                        .modifier(ConvexGlassView())
                }
                
                
                Button{
                    vm.selectedSheet = .profile
                } label: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.primary)
                        .frame(width: 40, height: 40)
                        .modifier(ConvexGlassView())
                }
                
            }
            .padding()
        }
        .safeAreaInset(edge: .top){
            HStack(alignment: .top) {
                Text("\(mapVm.place["city", default: ""])")
                    .underline()
                    .tracking(5)
                    .padding(30)
                    .font(.largeTitle.bold())
                
                Spacer()
                
                VStack {
                    Button {
                        vm.goToOption()
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .frame(width: 44, height: 44)
                            .background(.bar)
                            .cornerRadius(8)
                    }
                    
                    NavigationLink(destination: ModeView()){
                        Image(systemName: "eye.slash")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .frame(width: 44, height: 44)
                            .background(.bar)
                            .cornerRadius(8)
                    }
                    
                    Button {
                        mapVm.cameraModeToggle()
                    } label: {
                        Image(systemName: mapVm.cameraMode == .tracking ? "paperplane.fill" : "paperplane")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .frame(width: 44, height: 44)
                            .background(.bar)
                            .cornerRadius(8)
                    }
                    .disabled(mapVm.cameraMode == .tracking)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 30)
            }
        }
        .alert("Permission Denied", isPresented: $mapVm.permissionDenied, actions: {
            Button("Goto Settings") {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }, message: {
            Text("Please Enable Permission In App Settings")
        })
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        
    }
}

struct MainRouteBuilder: RouteBuilder {
  var matchPath: String { "main" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController? {
    { navigator, items, dependency in
      return WrappingController(matchingKey: matchPath) {
          MainView(vm: MainViewModel(navigator: navigator) )
      }
    }
  }
}
