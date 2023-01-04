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
    
    static func save(id: String, service: String, _ completion: @escaping (Bool) -> Void) {
        do {
            try keyChain
                .set(id, key: self.idKey)
            try keyChain
                .set(service, key: self.serviceKey)
            //중복되도 성공으로 뜸
            print("키체인 저장 성공: \(keyChain)")
            completion(true)
        } catch let error {
            print(error)
            completion(false)
        }
    }
    
    static func readID() -> String? {
        do {
            return try keyChain.getString(self.idKey)
        } catch let error{
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func readService() -> String? {
        do {
            return try keyChain.getString(self.serviceKey)
        } catch let error{
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func deleteID(_ completion: @escaping (Bool) -> Void) {
        do {
            try keyChain.remove(self.idKey)
            completion(true)
        } catch let error {
            print("error: \(error)")
            completion(false)
        }
    }
    
    static func deleteAllForTesting() {
        do {
            try keyChain.removeAll()
            print("키체인 전체 삭제 완료")
        } catch {
            print("키체인 삭제 실패")
        }
        
    }
}
