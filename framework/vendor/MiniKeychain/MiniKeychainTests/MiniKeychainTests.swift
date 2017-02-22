//
//  MiniKeychainTests.swift
//  MiniKeychainTests
//
//  Created by sonson on 2016/08/18.
//  Copyright © 2016年 sonson. All rights reserved.
//

import XCTest
@testable import MiniKeychain

class MiniKeychainTests: XCTestCase {
    var keychain: MiniKeychain!

    override func setUp() {
        super.setUp()
        keychain = MiniKeychain(service: "com.sonson.MiniKeychain")
        keychain.clear()
    }

    override func tearDown() {
        super.tearDown()
        keychain.clear()
    }

    func test() {
        let test_data = [
            ("account1", "password1"),
            ("account2", "password2"),
            ("account3", "password3")
        ]

        test_data.forEach { (account, password) in
            if let data = password.data(using: .utf8) {
                do {
                    try keychain.save(key: account, data: data)
                } catch {
                    XCTFail("Can not save password. \(error).")
                }
            } else { XCTFail("Can not create binary from password.") }
        }

        do {
            let data = try keychain.data(of: "account1")
            let password = String(data: data, encoding: .utf8)
            XCTAssert(password == "password1")
        } catch {
            XCTFail("\(error)")
        }

        do {
            let keys = try keychain.keys()
            print(keys)
            XCTAssert(keys == ["account1", "account2", "account3"])
        } catch {
            XCTFail("\(error)")
        }

        let r = keychain.delete(key: "account1")
        XCTAssert(r)

        do {
            let _ = try keychain.data(of: "account1")
            XCTFail("Error - account1 has not been deleted.")
        } catch {
            print(error)
        }

        do {
            let keys = try keychain.keys()
            print(keys)
            XCTAssert(keys == ["account2", "account3"])
        } catch {
            XCTFail("\(error)")
        }

        do {
            keychain.clear()
            let keys = try keychain.keys()
            XCTAssert(keys.count == 0)
        } catch {
            XCTFail("\(error)")
        }
    }
}
