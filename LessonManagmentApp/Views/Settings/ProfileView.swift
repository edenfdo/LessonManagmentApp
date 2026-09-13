//
//  ProfileView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import SwiftUI

struct ProfileView: View {

    let user: User

    @Environment(\.dismiss)
    private var dismiss

    var body: some View {

        NavigationStack {

            VStack(
                alignment: .leading,
                spacing: 20
            ) {

                // MARK: - Profile Icon

                HStack {

                    Spacer()

                    Image(
                        systemName: "person.circle.fill"
                    )
                    .font(.system(size: 80))
                    .foregroundStyle(.blue)

                    Spacer()
                }

                // MARK: - Account Details

                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {

                    profileRow(
                        title: "Name",
                        value: user.name
                    )

                    Divider()

                    profileRow(
                        title: "Email",
                        value: user.email
                    )

                    Divider()

                    profileRow(
                        title: "Role",
                        value: user.role.rawValue.capitalized
                    )
                }
                .padding()
                .background(
                    .gray.opacity(0.10)
                )
                .cornerRadius(14)

                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(
                .inline
            )
            .toolbar {

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: - Profile Row

    private func profileRow(
        title: String,
        value: String
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 4
        ) {

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .fontWeight(.medium)
        }
    }
}
