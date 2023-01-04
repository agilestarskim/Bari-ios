//
//  AppleLoginHelper.swift
//  Bari
//
//  Created by 김민성 on 2023/01/02.
//

import Foundation
import AuthenticationServices


class AppleLoginHelper {
    static let shared = AppleLoginHelper()
    private init() { }
    
    func login(result: Result<ASAuthorization, Error>,_ completion: @escaping (Result<Bool, LoginError>) -> Void) {
        if checkIfSignInWithOtherService() {
            completion(.failure(.otherPlatformRegistered))
            return
        }
        switch result {
        case .success(let auth):
            switch auth.credential {
            case let credential as ASAuthorizationAppleIDCredential:
                let userID = credential.user
                let _ = credential.fullName
                //TODO: id를 서버로 보내 처리 (서버: id를 통해 기존유저인지 신규유저인지 확인 후 처리)
                KeyChainManager.save(id: userID, service: "apple"){ result in
                    if result {
                        completion(.success(true))
                    }else {
                        completion(.failure(.keyChainSaveFailed))
                    }
                }
            default:
                break
            }
        case .failure:
            completion(.failure(.fetchFailed))
        }
    }
    
    func logout(_ completion: @escaping (Bool) -> Void) {
        KeyChainManager.deleteID { result in
            if result {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    private func checkIfSignInWithOtherService() -> Bool {
        return KeyChainManager.readService() == "kakao"
    }
}
