//
//  OptionView.swift
//  Bari
//
//  Created by 김민성 on 2022/12/20.
//

import SwiftUI
import LinkNavigator

struct OptionView: View {
    @StateObject var vm: OptionViewModel
    var body: some View {
        Form {
            Section {
                Text("공지사항")
            }
            Section("기본설정") {
            
            }
            
            Section("정보") {
                Text("개인정보처리방침")
                Text("이용 약관")
                Text("오픈소스 라이브러리")
            }
            
            Section("계정") {
                Button("로그아웃"){
                    vm.logout()
                }
                Button("계정탈퇴"){}
            }
        }
        .toolbar(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden(false)
    }
}

struct OptionRouteBuilder: RouteBuilder {
  var matchPath: String { "option" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController? {
    { navigator, items, dependency in
      return WrappingController(matchingKey: matchPath) {
          OptionView(vm: OptionViewModel(navigator: navigator) )
      }
    }
  }
}
