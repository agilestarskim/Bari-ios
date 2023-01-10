//
//  LaunchViewModel.swift
//  Bari
//
//  Created by 김민성 on 2023/01/03.
//

import Foundation
import LinkNavigator


final class LaunchViewModel: ObservableObject {

    let navigator: LinkNavigatorType
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
    }
    func checkValidToken() async {
        DispatchQueue.main.async { [weak self] in
            Task{
                if await TokenHelper.shared.checkToken() {
                    //TODO: 서버에서 유저데이터 가져옴
                    self?.navigator.next(paths: ["main"], items: [:], isAnimated: true)
                }else {
                    self?.navigator.next(paths: ["login"], items: [:], isAnimated: true)
                }
            }
        }
    }
    
    private func fetchUserData(){
        
    }
}

