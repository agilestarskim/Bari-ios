//
//  LoginView.swift
//  Bari
//
//  Created by 김민성 on 2022/12/20.
//
import SwiftUI
import AuthenticationServices
import LinkNavigator

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var vm: LoginViewModel
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            Text("Bari")
                .font(.largeTitle)
            Spacer()
            Button {
                vm.kakaoLogin()
            } label: {
                HStack {
                    Image("kakao_symbol")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 19)
                    Text("카카오 로그인")
                        .foregroundColor(.black)
                        .font(.system(size: 19, weight: .medium))
                    
                }
                .frame(maxWidth: 375)
                .frame(height: 50)
                .background(Color.kakaoContainer)
                .cornerRadius(6)
            }
            
            
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.email, .fullName]
            } onCompletion: { result in
                vm.appleLogin(result: result)
            }
            .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
            .frame(maxWidth: 375)
            .frame(height: 50)


        }
        .padding()
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }
}

struct LoginRouteBuilder: RouteBuilder {
  var matchPath: String { "login" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController? {
    { navigator, items, dependency in
      return WrappingController(matchingKey: matchPath) {
          LoginView(vm: LoginViewModel(navigator: navigator) )
      }
    }
  }
}



