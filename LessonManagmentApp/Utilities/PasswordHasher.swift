//
//  PasswordHasher.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import Foundation
import CryptoKit

enum PasswordHasher {

    static func hash(
        _ password: String
    ) -> String {

        let data =
            Data(password.utf8)

        let digest =
            SHA256.hash(
                data: data
            )

        return digest.map {
            String(
                format: "%02x",
                $0
            )
        }
        .joined()
    }

    static func verify(
        password: String,
        hash: String
    ) -> Bool {

        hashPassword(password)
            == hash
    }

    private static func hashPassword(
        _ password: String
    ) -> String {

        hash(password)
    }
}
