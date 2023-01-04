//
//  KakaoLoginHelper.swift
//  Bari
//
//  Created by 김민성 on 2023/01/02.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

class KakaoLoginHelper {
    static let shared = KakaoLoginHelper()
    private init() { }
    
    func login(_ completion: @escaping (Result<Bool, LoginError>) -> Void) {
        if checkIfSignInWithOtherService() {
            completion(.failure(.otherPlatformRegistered))
            return
        }
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(_, error) in
                if error != nil {
                    completion(.failure(.unknown))
                }
                else {
                    self.fetchUserInfo(completion)
                }
            }
            
        }
        //카카오톡 앱이 설치되지 않아 웹으로 로그인하는 경우
        else {
            UserApi.shared.loginWithKakaoAccount {(_, error) in
                if error != nil {
                    completion(.failure(.unknown))
                }
                else {
                    self.fetchUserInfo(completion)
                }
            }
        }
    }
    
    private func fetchUserInfo(_ completion: @escaping (Result<Bool, LoginError>) -> Void) {
        UserApi.shared.me { user, error in
            guard let user = user else {
                completion(.failure(.fetchFailed))
                return
            }
            guard let id = user.id else {
                completion(.failure(.fetchFailed))
                return
            }
            
            let name: String = user.kakaoAccount?.profile?.nickname ?? "이름없음"
            //TODO: id를 서버로 보내 처리 (서버: id를 통해 기존유저인지 신규유저인지 확인 후 처리)
            print("user ID: \(id)")
            print("user Name: \(name)")
            //입장 (메인뷰로 리다이렉션)
            KeyChainManager.save(id: String(id), service: "kakao") { result in
                if result {
                    completion(.success(true))
                }else {
                    completion(.failure(.keyChainSaveFailed))
                }
            }
            
        }
    }
    
    func logout(_ completion: @escaping (Bool) -> Void) {
        UserApi.shared.logout {(error) in
            if error != nil {
                completion(false)
            }
            else {
                print("logout() success.")
                completion(true)
            }
        }
    }
    
    private func checkIfSignInWithOtherService() -> Bool {
        return KeyChainManager.readService() == "apple"
    }
    
    
}
