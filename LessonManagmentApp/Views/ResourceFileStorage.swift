//
//  ResourceFileStorage.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import Foundation

enum ResourceFileStorage {

    static func saveFile(
        from sourceURL: URL,
        resourceID: UUID
    ) throws -> String {

        let fileManager = FileManager.default

        let documentsURL =
            fileManager.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first!

        let resourcesFolder =
            documentsURL
                .appendingPathComponent(
                    "Resources",
                    isDirectory: true
                )

        if !fileManager.fileExists(
            atPath: resourcesFolder.path
        ) {

            try fileManager.createDirectory(
                at: resourcesFolder,
                withIntermediateDirectories: true
            )
        }

        let resourceFolder =
            resourcesFolder
                .appendingPathComponent(
                    resourceID.uuidString,
                    isDirectory: true
                )

        if !fileManager.fileExists(
            atPath: resourceFolder.path
        ) {

            try fileManager.createDirectory(
                at: resourceFolder,
                withIntermediateDirectories: true
            )
        }

        let destinationURL =
            resourceFolder
                .appendingPathComponent(
                    sourceURL.lastPathComponent
                )

        if fileManager.fileExists(
            atPath: destinationURL.path
        ) {

            try fileManager.removeItem(
                at: destinationURL
            )
        }

        try fileManager.copyItem(
            at: sourceURL,
            to: destinationURL
        )

        return sourceURL.lastPathComponent
    }


    static func fileURL(
        resourceID: UUID,
        fileName: String
    ) -> URL {

        let documentsURL =
            FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first!

        return documentsURL
            .appendingPathComponent(
                "Resources"
            )
            .appendingPathComponent(
                resourceID.uuidString
            )
            .appendingPathComponent(
                fileName
            )
    }
}
