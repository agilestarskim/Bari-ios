//
//  OptionViewModel.swift
//  Bari
//
//  Created by 김민성 on 2023/01/03.
//

import Foundation
import LinkNavigator

final class OptionViewModel: ObservableObject {
    let navigator: LinkNavigatorType
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
    }
    func logout() {
        //TODO: 어떤 서비스인지 판단 후 해당 서비스로 로그아웃
        let service = KeyChainManager.readService()
        switch service {
        case "apple":
            AppleLoginHelper.shared.logout { result in
                if result {
                    self.navigator.backOrNext(path: "login", items: [:], isAnimated: true)
                } else {
                    //로그아웃 실패 알람 띄우기
                    self.navigator.alert(target: .default, model: Alert(title: "로그아웃 실패",
                                                                        message: "로그아웃에 실패했습니다.",
                                                                        buttons: [.init(title: "확인", style: .default, action: { })],
                                                                        flagType: .error))
                }
            }
            self.navigator.backOrNext(path: "login", items: [:], isAnimated: true)
        case "kakao":
            KakaoLoginHelper.shared.logout { result in
                if result {
                    // 루트뷰로 이동
                    self.navigator.backOrNext(path: "login", items: [:], isAnimated: true)
                } else {
                    //로그아웃 실패 알람 띄우기
                    self.navigator.alert(target: .default, model: Alert(title: "로그아웃 실패",
                                                                        message: "로그아웃에 실패했습니다.",
                                                                        buttons: [.init(title: "확인", style: .default, action: { })],
                                                                        flagType: .error))
                }
            }
        default:
            //서비스가 nil일 수는 없음 에러 처리 어떻게??
            self.navigator.backOrNext(path: "login", items: [:], isAnimated: true)
        }
    }
}

