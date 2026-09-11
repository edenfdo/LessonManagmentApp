//
//  SettingsView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 10/9/2026.
//

import SwiftUI

struct SettingsView: View {

    @Binding var showMenu: Bool

    let onLogout: () -> Void

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

                settingsSectionTitle("Account")

                settingsRow(
                    icon: "person.circle",
                    title: "Profile",
                    subtitle: "View and manage your account details"
                )

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
    }

    // MARK: - Section Title

    private func settingsSectionTitle(
        _ title: String
    ) -> some View {

        Text(title)
            .font(.headline)
            .foregroundStyle(.secondary)
            .padding(.top, 4)
    }

    // MARK: - Settings Row

    private func settingsRow(
        icon: String,
        title: String,
        subtitle: String
    ) -> some View {

        Button {

            print("Open \(title)")

        } label: {

            HStack(spacing: 14) {

                Image(systemName: icon)
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

                    Text(title)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)

                    Text(subtitle)
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
    }
}

#Preview {

    @Previewable
    @State var showMenu = false

    SettingsView(
        showMenu: $showMenu,
        onLogout: {
            print("Logged out")
        }
    )
}
