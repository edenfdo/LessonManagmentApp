//
//  Attendance.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 30/8/2026.
//

import Foundation

/// Represents the attendance status of a student for a scheduled music lesson.
///
/// Attendance allows teachers to record whether a student attended
/// their scheduled lesson.
///
/// Business Rules:
/// - Attendance must be linked to an existing lesson.
/// - Attendance should be recorded by a teacher.
/// - Each lesson should only have one attendance record.
struct Attendance: Identifiable, Codable {

    let id: UUID
    let lessonID: UUID
    let studentID: UUID
    let teacherID: UUID

    var status: AttendanceStatus
}

enum AttendanceStatus: String, Codable {
    case attended
    case absent
}
