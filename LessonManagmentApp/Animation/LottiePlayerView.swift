//
//  LottieAnimationView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 10/9/2026.
//
import SwiftUI
import Lottie

struct LottiePlayerView: UIViewRepresentable {

    let name: String

    func makeUIView(context: Context) -> UIView {

        let containerView = UIView()

        let animationView = Lottie.LottieAnimationView(
            name: name
        )

        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce

        animationView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(animationView)

        NSLayoutConstraint.activate([

            animationView.widthAnchor.constraint(
                equalTo: containerView.widthAnchor
            ),

            animationView.heightAnchor.constraint(
                equalTo: containerView.heightAnchor
            ),

            animationView.centerXAnchor.constraint(
                equalTo: containerView.centerXAnchor
            ),

            animationView.centerYAnchor.constraint(
                equalTo: containerView.centerYAnchor
            )
        ])

        animationView.play()

        return containerView
    }

    func updateUIView(
        _ uiView: UIView,
        context: Context
    ) {
    }
}
