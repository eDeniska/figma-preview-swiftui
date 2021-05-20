//
//  FigmaLinkParser.swift
//  FigmaPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import Foundation

struct FigmaLinkParser {
    let fileId: String?
    let componentId: String?

    init(link: String) {
        // https://www.figma.com/file/<..fileId..>/<...>?node-id=<..componentId..>
        if let components = URLComponents(string: link), components.host?.hasSuffix("figma.com") ?? false {
            let nodeId = components.queryItems?.first { $0.name == "node-id"}?.value
            componentId = nodeId
            let pathComponents = components.path.split(separator: "/", maxSplits: 3, omittingEmptySubsequences: true)
            if pathComponents.count > 2, pathComponents.first == "file" {
                fileId = String(pathComponents[1])
            } else {
                fileId = nil
            }
        } else {
            componentId = nil
            fileId = nil
        }
    }
}
