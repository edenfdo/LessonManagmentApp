//
//  PDFResourceView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 11/9/2026.
//

import SwiftUI
import PDFKit

struct PDFResourceView: UIViewRepresentable {

    let fileURL: URL

    func makeUIView(
        context: Context
    ) -> PDFView {

        let pdfView = PDFView()

        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical

        if let document =
            PDFDocument(
                url: fileURL
            ) {

            pdfView.document =
                document
        }

        return pdfView
    }

    func updateUIView(
        _ uiView: PDFView,
        context: Context
    ) {

        if uiView.document?.documentURL
            != fileURL {

            uiView.document =
                PDFDocument(
                    url: fileURL
                )
        }
    }
}
