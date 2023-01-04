//
//  MainViewModel.swift
//  Bari
//
//  Created by 김민성 on 2022/12/30.
//

import SwiftUI
import LinkNavigator

final class MainViewModel: ObservableObject {
    let navigator: LinkNavigatorType
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
    }
    enum Sheet { case friends, message, profile }
    @Published var showingSheet = false
    var selectedSheet: Sheet = .friends {
        didSet {
            showingSheet = true
        }
    }
    
    func goToOption(){
        self.navigator.next(paths: ["option"], items: [:], isAnimated: true)
    }
}

