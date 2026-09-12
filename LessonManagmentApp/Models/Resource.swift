//
//  Resource.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 11/9/2026.
//

import Foundation
import SwiftData

@Model
final class Resource: Identifiable {

    @Attribute(.unique)
    var id: UUID

    var lessonID: UUID?
    
    var title: String
    var teacherID: UUID
    var studentID: UUID

    var teacherName: String
    var datePosted: Date

    var fileName: String
    var fileTypeRawValue: String

    var fileType: ResourceFileType {
        get {
            ResourceFileType(
                rawValue: fileTypeRawValue
            ) ?? .pdf
        }

        set {
            fileTypeRawValue = newValue.rawValue
        }
    }

    init(
        id: UUID,
        title: String,
        teacherID: UUID,
        studentID: UUID,
        lessonID: UUID?,
        teacherName: String,
        datePosted: Date,
        fileName: String,
        fileType: ResourceFileType
    ) {
        self.id = id
        self.title = title
        self.teacherID = teacherID
        self.studentID = studentID
        self.lessonID = lessonID
        self.teacherName = teacherName
        self.datePosted = datePosted
        self.fileName = fileName
        self.fileTypeRawValue = fileType.rawValue
    }
}

enum ResourceFileType: String {
    case pdf
    case image
}

extension Resource {

    var fileNameWithoutExtension: String {

        let components =
            fileName.split(separator: ".")

        return components
            .dropLast()
            .joined(separator: ".")
    }
}


extension Resource {

    var localFileURL: URL {

        ResourceFileStorage.fileURL(
            resourceID: id,
            fileName: fileName
        )
    }
}
