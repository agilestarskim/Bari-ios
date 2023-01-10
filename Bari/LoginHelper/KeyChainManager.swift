//
//  KeychainManager.swift
//  Bari
//
//  Created by 김민성 on 2023/01/04.
//

import Foundation
import KeychainAccess

class KeyChainManager {
    static private let keyChain = Keychain(service: "com.bari")
    static private let idKey = "id"
    static private let serviceKey = "service"
    
    
    /// 입력받은 데이터를 키체인에 영구 저장한다. 값이 중복일 경우 기존 값을 덮어쓰고 completion(true)를 호출한다.
    /// - Parameters:
    ///   - id: 회원 고유 ID
    ///   - service: 로그인 api 제공 서비스 (카카오, 애플)
    ///   - completion: 성공 또는 실패 시 호출되는 핸들러
    static func save(id: String, service: String, _ completion: @escaping (Bool) -> Void) {
        do {
            try keyChain
                .set(id, key: self.idKey)
            try keyChain
                .set(service, key: self.serviceKey)
            print("키체인 저장 성공: \(keyChain)")
            completion(true)
        } catch let error {
            print(error)
            completion(false)
        }
    }
    
    
    /// 키체인에서 id키로 값을 가져온다.
    /// - Returns: 가져온 문자열 id. 값이 없을 시 nil 반환
    static func readID() -> String? {
        do {
            return try keyChain.getString(self.idKey)
        } catch let error{
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// 키체인에서 service키로 값을 가져온다.
    /// - Returns: 가져온 서비스 문자열. 값이 없을 시 nil 반환.
    static func readService() -> String? {
        do {
            return try keyChain.getString(self.serviceKey)
        } catch let error{
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// 키체인에서 id 를 삭제한다.
    static func deleteID(_ completion: @escaping (Bool) -> Void) {
        do {
            try keyChain.remove(self.idKey)
            completion(true)
        } catch let error {
            print("error: \(error)")
            completion(false)
        }
    }
    
    /// 테스트를 위해 id service 데이터 전부 삭제한다.
    static func deleteAllForTesting() {
        do {
            try keyChain.removeAll()
            print("키체인 전체 삭제 완료")
        } catch {
            print("키체인 삭제 실패")
        }        
    }
}
