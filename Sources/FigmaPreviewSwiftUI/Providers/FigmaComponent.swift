//
//  FigmaComponent.swift
//  FigmaPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import Foundation
import SwiftUI
import Combine

struct FigmaComponent: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "key"
        case fileId = "file_key"
        case componentId = "node_id"
        case title = "name"
        case details = "description"
        case thumbnailLink = "thumbnail_url"

    }
    let id: String
    let fileId: String
    let componentId: String
    let title: String
    let details: String
    let thumbnailLink: String
}
