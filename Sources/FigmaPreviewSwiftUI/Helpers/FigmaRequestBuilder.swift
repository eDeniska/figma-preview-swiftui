//
//  FigmaRequestBuilder.swift
//  FigmaPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import SwiftUI

struct FigmaRequestBuilder {
    private static let baseURL = "https://api.figma.com/v1"
    private init() {
    }

    static func imageRequest(accessToken: String, fileId: String, componentId: String, scale: CGFloat? = nil) -> URLRequest {
        let scaleModifier = scale.map { "&scale=\(max(1, Int($0)))" } ?? ""
        guard let url = URL(string: "\(baseURL)/images/\(fileId)?ids=\(componentId)&format=png\(scaleModifier)") else {
            fatalError("could not construct Figma Image request URL for file: \(fileId), component: \(componentId)")
        }
        var request = URLRequest(url: url)
        request.setValue(accessToken, forHTTPHeaderField: "X-Figma-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }

    static func componentsRequest(accessToken: String, fileId: String) -> URLRequest {
        guard let url = URL(string: "\(baseURL)/files/\(fileId)/components") else {
            fatalError("could not construct Figma Components request URL for file: \(fileId)")
        }
        var request = URLRequest(url: url)
        request.setValue(accessToken, forHTTPHeaderField: "X-Figma-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }
}
