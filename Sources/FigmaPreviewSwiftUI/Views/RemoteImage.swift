//
//  RemoteImage.swift
//  FigmaPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import SwiftUI

struct RemoteImage: View {
    let link: String

    @StateObject private var imageLoader = ImageLoader()

    var body: some View {
        if let image = imageLoader.image {
            image
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Image(systemName: "cloud")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .onAppear {
                    imageLoader.fetch(link: link)
                }
        }
    }
}
