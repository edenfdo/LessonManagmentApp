//
//  AddStudentView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import SwiftUI

struct AddStudentView: View {

    @State private var password = ""
    
    @ObservedObject var viewModel: TeacherStudentsViewModel

    

    @Environment(\.dismiss)
    private var dismiss

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""

    var body: some View {

        NavigationStack {

            Form {

                Section("Student Details") {

                    TextField(
                        "First name",
                        text: $firstName
                    )

                    TextField(
                        "Last name",
                        text: $lastName
                    )

                    TextField(
                        "Email",
                        text: $email
                    )
                    .textInputAutocapitalization(
                        .never
                    )
                    .keyboardType(
                        .emailAddress
                    )
                    
                    SecureField(
                        "Password",
                        text: $password
                    )
                }

                Section {

                    Button {

                        addStudent()

                    } label: {

                        Text("Add Student")
                            .fontWeight(
                                .semibold
                            )
                            .frame(
                                maxWidth:
                                    .infinity
                            )
                    }
                    .disabled(
                        firstName
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                            .isEmpty
                        ||
                        email
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                            .isEmpty
                        ||
                        password
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                            .isEmpty
                    )
                }
            }
            .navigationTitle(
                "Add Student"
            )
            .navigationBarTitleDisplayMode(
                .inline
            )
            .toolbar {

                ToolbarItem(
                    placement:
                        .topBarLeading
                ) {

                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func addStudent() {

            viewModel.addStudent(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password
            )

            dismiss()
        }
}
