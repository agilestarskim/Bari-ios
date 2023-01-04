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
    
    private func checkAppleToken() async -> Bool {
        return await withCheckedContinuation { continuation in
            let appleIDProvider = ASAuthorizationAppleIDProvider()

            appleIDProvider.getCredentialState(forUserID: KeyChainManager.readID() ?? "") { (credentialState, error) in
                switch credentialState {
                case .authorized:
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

