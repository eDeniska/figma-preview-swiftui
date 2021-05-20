//
//  ImageLoader.swift
//  FigmaPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import Foundation
import Combine
import SwiftUI

final class ImageLoader: ObservableObject {

    private static var imageCache = ImageCache(size: 16 * 1024 * 1024)

    @Published private(set) var image: Image?

    private var cancellable: AnyCancellable?

    func fetch(link: String) {
        guard image == nil, let url = URL(string: link) else {
            return
        }

        if let image = Self.imageCache[link] {
            self.image = Image(uiImage: image)
            return
        }

        cancellable?.cancel()

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .tryMap { data -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw FigmaImageError.badImageData
                }

                return image
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else {
                    return
                }
                switch completion {
                case .finished:
                    break

                case .failure(let error):
                    print("FigmaImageProvider error: \(error)")
                    self.image = Image(systemName: "rectangle.badge.xmark")
                }
            } receiveValue: { [weak self] image in
                guard let self = self else {
                    return
                }
                self.image = Image(uiImage: image)
                Self.imageCache[link] = image
            }
    }

}
