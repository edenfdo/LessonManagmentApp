//
//  LeaderboardView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 10/9/2026.
//

import SwiftUI

struct LeaderboardView: View {

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

            Text("Leaderboard")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Student rankings will appear here.")
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
    }
}

#Preview {

    @Previewable @State var showMenu = false

    LeaderboardView(
        showMenu: $showMenu
    )
}
