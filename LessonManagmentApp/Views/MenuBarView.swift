//
//  MenuBarView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import SwiftUI

struct MenuBarView: View {

    @Binding var showMenu: Bool

    var body: some View {

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
    }
}
