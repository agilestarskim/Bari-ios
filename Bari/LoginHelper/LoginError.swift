//
//  LoginError.swift
//  Bari
//
//  Created by 김민성 on 2023/01/04.
//

import Foundation

enum LoginError: String, Error {
    case otherPlatformRegistered = "다른 서비스로 가입하신 기록이 있습니다."
    case fetchFailed = "데이터를 서버로부터 가져오는데 실패했습니다."
    case unknown = "알 수 없는 에러"
    case keyChainSaveFailed = "로그인에 성공했지만 키체인에 데이터를 저장할 수 없습니다."
}
