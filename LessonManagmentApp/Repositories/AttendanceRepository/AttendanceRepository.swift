//
//  AttendanceRepository.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 30/8/2026.
//

import Foundation

/// Defines the operations required for accessing attendance data
/// in the music lesson management system.
protocol AttendanceRepository {

    func getAllAttendanceRecords() -> [Attendance]

    func getAttendance(forLessonID lessonID: UUID) -> Attendance?

    func addAttendance(_ attendance: Attendance)

    func updateAttendance(_ attendance: Attendance)
}
