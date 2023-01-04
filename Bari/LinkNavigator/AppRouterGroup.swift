//
//  AppRouterGroup.swift
//  Bari
//
//  Created by 김민성 on 2023/01/03.
//

import Foundation
import LinkNavigator

struct AppRouterGroup {
  var routers: [RouteBuilder] {
    [
        LaunchRouteBuilder(),
        LoginRouteBuilder(),
        MainRouteBuilder(),
        OptionRouteBuilder()
    ]
  }
}
