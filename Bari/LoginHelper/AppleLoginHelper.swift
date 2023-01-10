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
    
    /// 애플에서 제공한 UIButton에서 클릭 이벤트로 리턴 받은 result값으로 인증을 여부를 검사하고
    /// 성공일 경우 회원 정보를 가져와 데이터 처리 후, 메인 뷰로 리다이랙션한다.
    /// userID는 요청할 때마다 제공되지만 그 외 다른 데이터는 최초 1회만 제공된다.
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
                //키체인에 데이터를 저장한다.
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
