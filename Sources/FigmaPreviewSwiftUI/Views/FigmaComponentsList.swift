//
//  FigmaComponentsList.swift
//  FigmaPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import SwiftUI

extension FigmaComponent: Identifiable { }

public struct FigmaComponentsList: View {

    private let passedFileId: String?

    private var fileId: String {
        passedFileId ?? figmaFileId
    }

    @Environment(\.figmaAccessToken) private var figmaAccessToken
    @Environment(\.figmaFileId) private var figmaFileId
    @StateObject private var metadataProvider = FigmaMetadataProvider()

    public init() {
        passedFileId = nil
    }

    public init(fileId: String) {
        passedFileId = fileId
    }

    public init(link: String) {
        passedFileId = FigmaLinkParser(link: link).fileId
    }

    public var body: some View {
        NavigationView {
            Group {
            if let components = metadataProvider.components {
                if components.isEmpty {
                    // empty view state
                    Text("No components found", bundle: .module).font(.headline)
                } else {
                    List(components) { component in
                        NavigationLink(destination: FigmaComponentPreview(figmaComponent: component)) {
                            HStack {
                                RemoteImage(link: component.thumbnailLink)
                                    .frame(width: 64, height: 64, alignment: .center)
                                Text(component.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }

            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .onAppear {
                        metadataProvider.fetch(accessToken: figmaAccessToken, fileId: fileId)
                    }
            }
            }.navigationTitle(Text("Components", bundle: .module))
        }
    }
}
