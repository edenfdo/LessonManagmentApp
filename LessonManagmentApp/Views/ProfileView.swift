//
//  ProfileView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 10/9/2026.
//

import SwiftUI

struct ProfileView: View {

    let studentName: String

    @Binding var showMenu: Bool

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {

            HStack {

                Text("Logo")
                    .font(.title)
                    .fontWeight(.bold)

                Spacer()

                Button {
                    showMenu = true
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.title)
                }
            }

            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(studentName)
                .font(.title2)

            Spacer()
        }
        .padding()
    }
}

#Preview {

    @Previewable @State var showMenu = false

    ProfileView(
        studentName: "Mia",
        showMenu: $showMenu
    )
}
