//
//  LoginView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 10/9/2026.
//

import SwiftUI

struct LoginView: View {

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""

    let sampleStudent: User
    let sampleTeacher: User

    let onLogin: (User) -> Void

    var body: some View {

        VStack(spacing: 24) {

            Spacer()

            Text("Music Lesson Hub")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Sign in to continue")
                .foregroundStyle(.secondary)

            VStack(spacing: 16) {

                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.go)
                    .onSubmit {
                        login()
                    }
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.caption)
            }

            Button {
                login()
            } label: {
                Text("Sign In")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
            }

            Spacer()
        }
        .padding()
    }

    private func login() {

        errorMessage = ""

        if email == sampleStudent.email
            && password == "student123" {

            onLogin(sampleStudent)

        } else if email == sampleTeacher.email
                    && password == "teacher123" {

            onLogin(sampleTeacher)

        } else {

            errorMessage =
                "Email or password is incorrect. Please check your details and try again."
        }
    }
}

#Preview {

    let student = User(
        id: UUID(),
        name: "Mia",
        email: "mia@email.com",
        role: .student
    )

    let teacher = User(
        id: UUID(),
        name: "Daniel",
        email: "daniel@email.com",
        role: .teacher
    )

    return LoginView(
        sampleStudent: student,
        sampleTeacher: teacher
    ) { user in
        print(user.name)
    }
}
