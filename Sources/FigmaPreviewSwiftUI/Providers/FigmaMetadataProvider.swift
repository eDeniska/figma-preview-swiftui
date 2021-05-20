//
//  FigmaMetadataProvider.swift
//  FigmaPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import Foundation
import Combine

struct FigmaMeta: Decodable {
    let components: [FigmaComponent]
}

struct FigmaMetadataResponse: Decodable {
    let meta: FigmaMeta
}

final class FigmaMetadataProvider: ObservableObject {

    @Published private(set) var components: [FigmaComponent]?

    private var cancellable: AnyCancellable?

    func fetch(accessToken: String, fileId: String) {
        let figmaFileId = fileId.removingPercentEncoding ?? fileId

        guard components == nil else {
            return
        }
        cancellable?.cancel()

        cancellable = URLSession.shared.dataTaskPublisher(for: FigmaRequestBuilder.componentsRequest(accessToken: accessToken, fileId: figmaFileId))
            .map { $0.data }
            .decode(type: FigmaMetadataResponse.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break

                case .failure(let error):
                    print("FigmaMetadataProvider error: \(error)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else {
                    return
                }
                self.components = response.meta.components
            }
    }

}

