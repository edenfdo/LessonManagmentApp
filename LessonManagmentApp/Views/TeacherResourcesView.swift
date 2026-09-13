//
//  TeacherResourcesView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

//
//  TeacherResourcesView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import SwiftUI

struct TeacherResourcesView: View {

    @Binding var showMenu: Bool

    let teacher: User

    @StateObject var viewModel: TeacherResourcesViewModel

    @State private var showAddResourceSheet = false
    @State private var selectedResource: Resource?

    var body: some View {

        ZStack {

            ScrollView {

                VStack(
                    alignment: .leading,
                    spacing: 20
                ) {

                    // MARK: - Header

                    MenuBarView(
                        showMenu: $showMenu
                    )

                    // MARK: - Page Title

                    Text("Resources")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(
                        "Share learning resources with your students."
                    )
                    .foregroundStyle(.secondary)

                    // MARK: - Add Resource

                    Button {

                        showAddResourceSheet = true

                    } label: {

                        HStack {

                            Image(
                                systemName: "plus"
                            )

                            Text("Add Resource")
                                .fontWeight(.semibold)

                            Spacer()
                        }
                        .padding()
                        .foregroundStyle(.white)
                        .background(.blue)
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)

                    // MARK: - Shared Resources

                    Text("Shared Resources")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 4)

                    if viewModel.resources.isEmpty {

                        Text(
                            "No resources shared yet."
                        )
                        .foregroundStyle(.secondary)

                    } else {

                        ForEach(
                            viewModel.resources,
                            id: \.id
                        ) { resource in

                            Button {

                                selectedResource =
                                    resource

                            } label: {

                                resourceCard(
                                    resource
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Spacer()
                }
                .padding()
            }

            // MARK: - Resource Popup

            if let resource =
                selectedResource {

                Color.black
                    .opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture {

                        selectedResource =
                            nil
                    }

                ResourcePreviewView(
                    resource: resource,
                    subtitle:
                        popupSubtitle(
                            for: resource
                        ),
                    onClose: {

                        selectedResource =
                            nil
                    }
                )
            }
        }

        .onAppear {

            viewModel.loadData(
                teacherID: teacher.id
            )
        }

        .sheet(
            isPresented:
                $showAddResourceSheet
        ) {

            AddResourceView(
                teacher: teacher,
                viewModel: viewModel
            )
        }
    }

    // MARK: - Resource Card

    private func resourceCard(
        _ resource: Resource
    ) -> some View {

        HStack(
            alignment: .top,
            spacing: 14
        ) {

            Image(
                systemName:
                    resource.fileType == .pdf
                    ? "doc.fill"
                    : "photo.fill"
            )
            .font(.title2)
            .foregroundStyle(.blue)
            .frame(
                width: 44,
                height: 44
            )
            .background(
                .blue.opacity(0.12)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 10
                )
            )

            VStack(
                alignment: .leading,
                spacing: 6
            ) {

                Text(
                    resource.title
                )
                .font(.headline)
                .foregroundStyle(.primary)

                if let student =
                    viewModel.studentForResource(
                        resource
                    ) {

                    Text(
                        "Student: \(student.name)"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }

                if let lessonID =
                    resource.lessonID,
                   let lesson =
                    viewModel.lessons.first(
                        where: {
                            $0.id == lessonID
                        }
                    ) {

                    Text(
                        "Lesson: \(lesson.title)"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)

                } else {

                    Text(
                        "General resource"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }

                Text(
                    "Shared \(resource.datePosted, style: .date)"
                )
                .font(.caption)
                .foregroundStyle(.secondary)

                HStack {

                    Text(
                        resource.fileName
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                    Spacer()

                    HStack(
                        spacing: 4
                    ) {

                        Text("View")

                        Image(
                            systemName:
                                "chevron.right"
                        )
                        .font(.caption)
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
                }
            }

            Spacer()
        }
        .padding()
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(
            .gray.opacity(0.12)
        )
        .cornerRadius(14)
    }

    // MARK: - Popup Subtitle

    private func popupSubtitle(
        for resource: Resource
    ) -> String {

        if let student =
            viewModel.studentForResource(
                resource
            ) {

            return "Shared with \(student.name)"
        }

        return "Shared resource"
    }
}
