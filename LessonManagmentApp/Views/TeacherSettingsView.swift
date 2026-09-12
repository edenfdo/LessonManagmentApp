//
//  TeacherSettingsView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import SwiftUI

struct TeacherSettingsView: View {

    @Binding var showMenu: Bool

    let teacherName: String
    let teacherEmail: String
    let onLogout: () -> Void

    @State private var showProfileSheet = false

    var body: some View {

        ScrollView {

            VStack(
                alignment: .leading,
                spacing: 20
            ) {

                // MARK: - Header

                HStack {

                    Text("Logo")
                        .font(.title)
                        .fontWeight(.bold)

                    Spacer()

                    Button {
                        showMenu = true
                    } label: {

                        Image(
                            systemName: "line.3.horizontal"
                        )
                        .font(.title)
                    }
                }

                // MARK: - Page Title

                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // MARK: - Account

                Text("Account")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)

                Button {

                    showProfileSheet = true

                } label: {

                    HStack(spacing: 14) {

                        Image(systemName: "person.circle")
                            .font(.title3)
                            .frame(
                                width: 36,
                                height: 36
                            )
                            .background(
                                .blue.opacity(0.10)
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 9
                                )
                            )

                        VStack(
                            alignment: .leading,
                            spacing: 4
                        ) {

                            Text("Profile")
                                .fontWeight(.medium)
                                .foregroundStyle(.primary)

                            Text("View your account details")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(
                            systemName: "chevron.right"
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(
                        .gray.opacity(0.10)
                    )
                    .cornerRadius(14)
                }
                .buttonStyle(.plain)

                // MARK: - Log Out

                Button {

                    onLogout()

                } label: {

                    HStack {

                        Image(
                            systemName:
                                "rectangle.portrait.and.arrow.right"
                        )

                        Text("Log Out")
                            .fontWeight(.semibold)

                        Spacer()
                    }
                    .padding()
                    .foregroundStyle(.red)
                    .background(
                        .red.opacity(0.08)
                    )
                    .cornerRadius(14)
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding()
        }

        .sheet(
            isPresented: $showProfileSheet
        ) {

            TeacherProfileDetailsView(
                name: teacherName,
                email: teacherEmail
            )
        }
    }
}

#Preview {

    @Previewable
    @State var showMenu = false

    TeacherSettingsView(
        showMenu: $showMenu,
        teacherName: "Daniel",
        teacherEmail: "daniel@email.com",
        onLogout: {
            print("Logged out")
        }
    )
}
