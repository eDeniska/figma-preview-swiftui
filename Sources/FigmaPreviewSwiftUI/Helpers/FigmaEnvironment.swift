//
//  FigmaEnvironment.swift
//  FigmaPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import SwiftUI

struct FigmaAccessTokenKey: EnvironmentKey {
    static var defaultValue = ""
}

struct FigmaFileIDKey: EnvironmentKey {
    static var defaultValue = ""
}

public extension EnvironmentValues {
    var figmaFileId: String {
        get {
            self[FigmaFileIDKey.self]
        }
        set {
            self[FigmaFileIDKey.self] = newValue
        }
    }
    
    var figmaAccessToken: String {
        get {
            self[FigmaAccessTokenKey.self]
        }
        set {
            self[FigmaAccessTokenKey.self] = newValue
        }
    }
}
