//
//  CheckTokenHelper.swift
//  Bari
//
//  Created by 김민성 on 2023/01/02.
//

import Foundation
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import AuthenticationServices


class TokenHelper {
    static let shared = TokenHelper()
    
    private init() { }
    
    /// 키체인에서 서비스 키를 가져와 가입되어있는 서비스의 토큰을 검사한다.
    /// - Returns: 토큰 유효 여부
    func checkToken() async -> Bool {
        let service: String? = KeyChainManager.readService()
        switch service {
        case "apple":
            return await checkAppleToken()
        case "kakao":
            return await checkKakaoToken()
        default:
            return false
        }
        
    }
    
    /// 카카오 서비스를 이용하여 토큰을 검사한다.
    /// completion handler를 continuation으로 변경해 async 함수를 구현했다.
    /// - Returns: 카카오 토큰 유효 여부
    private func checkKakaoToken() async -> Bool {
        return await withCheckedContinuation { continuation in
            if (AuthApi.hasToken()) {
                UserApi.shared.accessTokenInfo { (_, error) in
                    if let error = error {
                        if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                            //로그인 필요
                            continuation.resume(returning: false)
                        }
                        else {
                            //기타 에러
                            continuation.resume(returning: false)
                        }
                    }
                    else {
                        //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                        //TODO: 서버에서 사용자 정보를 가져옴
                        print("카카오 토큰 체크 성공")
                        continuation.resume(returning: true)
                    }
                }
            } else {
                continuation.resume(returning: false)
            }
        }
    }
    
    /// 키체인에 저장되어 있는 아이디를 가져와 애플 로그인으로 가입한 이력을 검사한다.
    /// - Returns: 애플 아이디 유효 여부
    private func checkAppleToken() async -> Bool {
        return await withCheckedContinuation { continuation in
            let appleIDProvider = ASAuthorizationAppleIDProvider()

            appleIDProvider.getCredentialState(forUserID: KeyChainManager.readID() ?? "") { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    //TODO: 토큰체크는 아니고 가입여부만 판단하므로 추후 기능 개발 필요
                    print("애플 토큰 체크 성공")
                    continuation.resume(returning: true)
                case .revoked, .notFound:
                    continuation.resume(returning: false)

                default:
                    continuation.resume(returning: false)
                }
            }
        }
    }
}

