//
//  FigmaView.swift
//  FigmaPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import SwiftUI

public struct FigmaView: View {
    private let passedFileId: String?
    private let componentId: String

    private var fileId: String {
        passedFileId ?? figmaFileId
    }

    @Environment(\.figmaAccessToken) private var figmaAccessToken
    @Environment(\.figmaFileId) private var figmaFileId
    @Environment(\.displayScale) private var displayScale
    @StateObject private var imageProvider = FigmaImageProvider()

    public init(link: String) {
        let parser = FigmaLinkParser(link: link)
        componentId = parser.componentId ?? ""
        passedFileId = parser.fileId
    }

    public init(fileId: String? = nil, componentId: String) {
        self.passedFileId = fileId
        self.componentId = componentId
    }

    public var body: some View {
        if let image = imageProvider.image {
            image
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .onAppear {
                    imageProvider.fetch(accessToken: figmaAccessToken, fileId: fileId, componentId: componentId, scale: displayScale)
                }
        }
    }
}
