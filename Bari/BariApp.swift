//
//  BariApp.swift
//  Bari
//
//  Created by 김민성 on 2022/12/20.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import LinkNavigator

@main
struct BariApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    init() {
        // Kakao SDK 초기화
        initKakaoAppkey()
    }
    
    var navigator: LinkNavigator {
        appDelegate.navigator
    }
    
    var body: some Scene {
        WindowGroup {
            navigator
                .launch(paths: ["launch"], items: [:])
                .onOpenURL(perform: { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                })
                .ignoresSafeArea()
            
        }
           
        
    }
    
    private func initKakaoAppkey() {
        let kakaoNativeAppKey: String = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as! String
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
    }
}
