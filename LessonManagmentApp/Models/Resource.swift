//
//  Resource.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 11/9/2026.
//

import Foundation

struct Resource: Identifiable {

    let id: UUID

    let title: String
    let teacherName: String
    let datePosted: Date

    let fileName: String
    let fileType: ResourceFileType
}

enum ResourceFileType {
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
