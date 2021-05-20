//
//  FigmaImageProvider.swift
//  FigmaPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import Foundation
import Combine
import SwiftUI

struct FigmaImageResponse: Decodable {
    let images: [String: String]

    func imageURL(for componentId: String) -> URL? {
        guard let link = images[componentId] else {
            return nil
        }
        return URL(string: link)
    }
}

enum FigmaImageError: Error {
    case noImageURL
    case badImageData
}

final class FigmaImageProvider: ObservableObject {

    private static var imageCache = ImageCache(size: 32 * 1024 * 1024)

    private static func key(fileId: String, componentId: String) -> String {
        "\(fileId)/\(componentId)"
    }

    @Published private(set) var image: Image?

    private var cancellable: AnyCancellable?

    func fetch(accessToken: String, fileId: String, componentId: String, scale: CGFloat? = nil) {
        let figmaFileId = fileId.removingPercentEncoding ?? fileId
        let figmaComponentId = componentId.removingPercentEncoding ?? componentId

        guard image == nil else {
            return
        }

        if let image = Self.imageCache[Self.key(fileId: figmaFileId, componentId: figmaComponentId)] {
            self.image = Image(uiImage: image)
            return
        }

        cancellable?.cancel()

        cancellable = URLSession.shared.dataTaskPublisher(for: FigmaRequestBuilder.imageRequest(accessToken: accessToken, fileId: figmaFileId, componentId: figmaComponentId, scale: scale))
            .mapError { $0 as Error }
            .map { $0.data }
            .decode(type: FigmaImageResponse.self, decoder: JSONDecoder())
            .flatMap { figmaResponse -> AnyPublisher<UIImage, Error> in
                guard let imageURL = figmaResponse.imageURL(for: figmaComponentId) else {
                    return Fail<UIImage, Error>(error: FigmaImageError.noImageURL).eraseToAnyPublisher()
                }

                return URLSession.shared.dataTaskPublisher(for: imageURL)
                    .mapError { $0 as Error }
                    .map { $0.data }
                    .tryMap { data in
                        guard let image = UIImage(data: data) else {
                            throw FigmaImageError.badImageData
                        }

                        return image
                    }
                    .eraseToAnyPublisher()
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
                Self.imageCache[Self.key(fileId: figmaFileId, componentId: figmaComponentId)] = image
            }
    }

}
