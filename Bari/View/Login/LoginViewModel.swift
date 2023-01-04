//
//  LoginViewModel.swift
//  Bari
//
//  Created by 김민성 on 2023/01/03.
//

import SwiftUI
import LinkNavigator
import AuthenticationServices

final class LoginViewModel: ObservableObject {
    let navigator: LinkNavigatorType
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
    }
    func kakaoLogin() {
        KakaoLoginHelper.shared.login { result in
            switch result {
            case .success:
                self.navigator.next(paths: ["main"], items: [:], isAnimated: true)
            case .failure(let failure):
                self.navigator.alert(target: .default, model: Alert(title:  failure == .otherPlatformRegistered ? "애플로 로그인 해주세요" : "로그인 실패",
                                                                    message: failure.rawValue,
                                                                    buttons: [.init(title: "확인", style: .default, action: { })],
                                                                    flagType: .error))
                
            }
        }
    }
    
    func appleLogin(result: Result<ASAuthorization, Error>) {
        AppleLoginHelper.shared.login(result: result) { result in
            switch result {
            case .success:
                self.navigator.next(paths: ["main"], items: [:], isAnimated: true)
            case .failure(let failure):
                self.navigator.alert(target: .default, model: Alert(title: failure == .otherPlatformRegistered ? "카카오로 로그인 해주세요" : "로그인 실패",
                                                                    message: failure.rawValue,
                                                                    buttons: [.init(title: "확인", style: .default, action: { })],
                                                                    flagType: .error))
                    
                
            }
        }
    
        
    }
}


