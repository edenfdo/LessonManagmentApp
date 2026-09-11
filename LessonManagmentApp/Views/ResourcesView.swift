//
//  ResourcesView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 10/9/2026.
//

import SwiftUI

struct ResourcesView: View {

    @Binding var showMenu: Bool

    @State private var searchText = ""
    @State private var sortNewestFirst = true

    @State private var selectedResource: Resource?

    private let resources: [Resource] = [

        Resource(
            id: UUID(),
            title: "C Major Scale Sheet Music",
            teacherName: "Daniel",
            datePosted: Date().addingTimeInterval(-86400),
            fileName: "C-Major-Scale.png",
            fileType: .image
        ),

        Resource(
            id: UUID(),
            title: "Rhythm Practice Exercise",
            teacherName: "Daniel",
            datePosted: Date().addingTimeInterval(-172800),
            fileName: "Rhythm-Practice.png",
            fileType: .image
        ),

        Resource(
            id: UUID(),
            title: "Lesson Notes - Week 3",
            teacherName: "Daniel",
            datePosted: Date().addingTimeInterval(-259200),
            fileName: "Lesson-Notes.pdf",
            fileType: .pdf
        )
    ]

    private var filteredResources: [Resource] {

        let filtered = resources.filter { resource in

            searchText.isEmpty ||
            resource.title.localizedCaseInsensitiveContains(searchText) ||
            resource.teacherName.localizedCaseInsensitiveContains(searchText)
        }

        return filtered.sorted {

            if sortNewestFirst {
                return $0.datePosted > $1.datePosted
            } else {
                return $0.datePosted < $1.datePosted
            }
        }
    }

    var body: some View {

        ZStack {

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

                    Text("Resources")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    // MARK: - Search Bar

                    HStack(spacing: 10) {

                        Image(
                            systemName: "magnifyingglass"
                        )
                        .foregroundStyle(.secondary)

                        TextField(
                            "Search resources",
                            text: $searchText
                        )
                    }
                    .padding(12)
                    .background(
                        .gray.opacity(0.12)
                    )
                    .cornerRadius(12)

                    // MARK: - Resources Header

                    HStack {

                        Text("Resources Available")
                            .font(.headline)

                        Spacer()

                        Menu {

                            Button("Newest First") {
                                sortNewestFirst = true
                            }

                            Button("Oldest First") {
                                sortNewestFirst = false
                            }

                        } label: {

                            HStack(spacing: 5) {

                                Image(
                                    systemName:
                                        "arrow.up.arrow.down"
                                )

                                Text(
                                    sortNewestFirst
                                    ? "Newest"
                                    : "Oldest"
                                )
                            }
                            .font(.subheadline)
                        }
                    }

                    // MARK: - Resource Cards

                    ForEach(filteredResources) { resource in

                        Button {

                            selectedResource = resource

                        } label: {

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

                                    Text(resource.title)
                                        .font(.headline)
                                        .foregroundStyle(.primary)

                                    Text(
                                        "From \(resource.teacherName)"
                                    )
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                                    Text(
                                        "Posted \(resource.datePosted, style: .date)"
                                    )
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                    HStack {

                                        Text(resource.fileName)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(1)

                                        Spacer()

                                        HStack(spacing: 4) {

                                            Text("View")

                                            Image(
                                                systemName:
                                                    "chevron.right"
                                            )
                                            .font(.caption)
                                        }
                                        .font(.caption)
                                        .foregroundStyle(.blue)
                                    }
                                }
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
                        .buttonStyle(.plain)
                    }

                    Spacer()
                }
                .padding()
            }

            // MARK: - Resource Popup

            if let resource = selectedResource {

                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedResource = nil
                    }

                VStack(
                    alignment: .leading,
                    spacing: 14
                ) {

                    // Popup Header

                    HStack {

                        VStack(
                            alignment: .leading,
                            spacing: 3
                        ) {

                            Text(resource.title)
                                .font(.headline)

                            Text(
                                "From \(resource.teacherName)"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Button {
                            selectedResource = nil
                        } label: {
                            Image(
                                systemName: "xmark"
                            )
                            .font(.headline)
                        }
                    }

                    Divider()

                    // MARK: - File Viewer

                    if resource.fileType == .pdf {

                        PDFResourceView(
                            fileName: resource.fileName
                        )
                        .frame(height: 430)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 10
                            )
                        )

                    } else {

                        Image(
                            resource.fileNameWithoutExtension
                        )
                        .resizable()
                        .scaledToFit()
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: 430
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 10
                            )
                        )
                    }

                    Divider()

                    HStack {

                        Image(
                            systemName:
                                resource.fileType == .pdf
                                ? "doc.fill"
                                : "photo.fill"
                        )

                        Text(resource.fileName)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Spacer()
                    }
                }
                .padding()
                .frame(maxWidth: 360)
                .background(
                    Color(.systemBackground)
                )
                .cornerRadius(18)
                .shadow(radius: 12)
                .padding()
            }
        }
    }
}

#Preview {

    @Previewable
    @State var showMenu = false

    ResourcesView(
        showMenu: $showMenu
    )
}
