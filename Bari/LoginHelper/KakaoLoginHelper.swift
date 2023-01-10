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
    
    /// 카카오 로그인 api이다. 로그인 하기전 checkIfSignWithOtherService()함수를 호출해 다른 서비스(애플)로 가입한 이력이 있는지 확인한다.
    /// 가입되어있다면 에러를 completion에 담아 호출한다.
    /// 가입되어있지 않다면 로그인을 시도한다. 각 상황에 맞는 에러 또는 성공 여부를 completion에 담아 호출한다.
    func login(_ completion: @escaping (Result<Bool, LoginError>) -> Void) {
        if checkIfSignInWithOtherService() {
            completion(.failure(.otherPlatformRegistered))
            return
        }
        //카카오톡 앱이 설치되어 있어 카카오톡 앱으로 로그인하는 경우
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(_, error) in
                if error != nil {
                    completion(.failure(.unknown))
                }
            }
        }
        //카카오톡 앱이 설치되지 않아 웹으로 로그인하는 경우
        else {
            UserApi.shared.loginWithKakaoAccount {(_, error) in
                if error != nil {
                    completion(.failure(.unknown))
                }
            }
        }
        //로그인에 성공한 경우
        fetchUserInfo(completion)
    }
    
    /// 카카오 api를 이용해 해당 유저의 정보를 가져온다.
    /// 성공적으로 정보를 가져왔다면 데이터를 상황에 맞게 처리한 뒤, 메인 뷰로 리다이랙션한다.
    /// - Parameter completion: <#completion description#>
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
            //키체인에 데이터를 저장한다.
            KeyChainManager.save(id: String(id), service: "kakao") { result in
                if result {
                    completion(.success(true))
                }else {
                    completion(.failure(.keyChainSaveFailed))
                }
            }
            
        }
    }
    
    /// 카카오 api를 이용해 로그아웃한다.
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
    
    /// 키체인에서 서비스 키를 읽어 애플로 로그인한 이력이 있는지 확인한다.
    /// - Returns: 애플 로그인 이력 여부
    private func checkIfSignInWithOtherService() -> Bool {
        return KeyChainManager.readService() == "apple"
    }
    
    
}
