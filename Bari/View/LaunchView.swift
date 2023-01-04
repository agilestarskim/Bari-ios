//
//  LaunchView.swift
//  Bari
//
//  Created by 김민성 on 2023/01/03.
//

import SwiftUI
import LinkNavigator

struct LaunchView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var vm: LaunchViewModel
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: colorScheme == .light ? .white : .black)
                    .ignoresSafeArea()
                Text("Bari")
                    .font(.largeTitle)
            }
            .onAppear {
                Task {
                    await vm.checkValidToken()
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct LaunchRouteBuilder: RouteBuilder {
  var matchPath: String { "launch" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController? {
    { navigator, items, dependency in
      return WrappingController(matchingKey: matchPath) {
          LaunchView(vm: LaunchViewModel(navigator: navigator) )
      }
    }
  }
}
