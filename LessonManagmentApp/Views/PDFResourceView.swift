//
//  PDFResourceView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 11/9/2026.
//

import SwiftUI
import PDFKit

struct PDFResourceView: UIViewRepresentable {

    let fileName: String

    func makeUIView(context: Context) -> PDFView {

        let pdfView = PDFView()

        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical

        if let url = Bundle.main.url(
            forResource: fileNameWithoutExtension,
            withExtension: "pdf"
        ) {

            pdfView.document = PDFDocument(url: url)
        }

        return pdfView
    }

    func updateUIView(
        _ uiView: PDFView,
        context: Context
    ) {
    }

    private var fileNameWithoutExtension: String {

        fileName.replacingOccurrences(
            of: ".pdf",
            with: ""
        )
    }
}
