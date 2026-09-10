//
//  LocalAttendanceRepository.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 30/8/2026.
//

import Foundation

/// Stores and retrieves attendance records locally
/// while the application is running.
class LocalAttendanceRepository: AttendanceRepository {

    private var attendanceRecords: [Attendance] = []

    func getAllAttendanceRecords() -> [Attendance] {
        return attendanceRecords
    }

    func getAttendance(forLessonID lessonID: UUID) -> Attendance? {
        return attendanceRecords.first { attendance in
            attendance.lessonID == lessonID
        }
    }

    func addAttendance(_ attendance: Attendance) {
        attendanceRecords.append(attendance)
    }

    func updateAttendance(_ attendance: Attendance) {

        if let index = attendanceRecords.firstIndex(
            where: { $0.id == attendance.id }
        ) {
            attendanceRecords[index] = attendance
        }
    }
}

