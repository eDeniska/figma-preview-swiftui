# FigmaPreviewSwiftUI

A Figma component preview for your SwiftUI views.
You can use Figma components instead of real views within your app until you implement them.

## The Purpose

To speed up prototype development and test design choices before full-featured implementation.

Project is heavily inspired by [flutter_figma_preview](https://github.com/vvsevolodovich/flutter_figma_preview) and [jetpack-compose-figma-preview](https://github.com/vvsevolodovich/jetpack-compose-figma-preview).

## Requirements

FigmaPreviewSwiftUI uses SwiftUI features of macOS 11, iOS 14, tvOS 14, watchOS 7.

## Setup

Add FigmaPreviewSwiftUI to your project via Swift Package Manager.

Create personal access token in account settings. 

<img width="426" alt="figma-access-token" src="https://user-images.githubusercontent.com/950994/119125124-19e15780-ba3a-11eb-842b-e550ca6439b7.png">

Then pass this Figma access token via `Environment`.
```swift
struct FigmaPreviewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.figmaAccessToken, "<figma-access-token>")
        }
    }
}
```

## Usage

If you're using single Figma file for all designs, you can also pass it via `Environment`, so you won't need to specify it for each individual component (file id could be taken from Figma share link – typically, it goes after `/file/`).
```swift
struct FigmaPreviewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.figmaAccessToken, "<figma-access-token>")
                .environment(\.figmaFileId, "<default-file-id>")
        }
    }
}
```
When you need to insert your Figma component, you can use two ways. Either you can specify component ID and optionally file ID directly.
```swift
struct ContentView: View {
    var body: some View {
        FigmaView(fileId: "<file-id>", componentId: "<component-id>")
    }
}
```
Alternatively, you can simply pass share link for the component.
```swift
struct ContentView: View {
    var body: some View {
        FigmaView(link: "https://www.figma.com/file/<12123123>/Name?node-id=<123123%3A3232131>")
    }
}
```
`FigmaView` will maintain its `aspectRatio`, but you'll need to control its `frame` when needed.

## Component list to get component IDs

When you need to get component IDs for the elements, you can use `FigmaComponentsList` view (it comes with `NavigationView`, so you could put somewhere in developer menu of your app on early stages, or use separate app to browse components).
Please note that only published components will be listed (this requires paid Figma subscription to publish these).
Alternatively, you could still use share links of components from Figma.
You can use share link, or file id to set up `FigmaComponentsList` view. Or, `FigmaComponentsList` could use file id passed via `Environment`.
```swift
struct ContentView: View {
    var body: some View {
        FigmaComponentsList()
    }
}
```

## Reuse and contribution

You could use FigmaPreviewSwiftUI in any way you want. If you would like to contribute to the projects – contact me.
Any ideas, suggestions, pull requests are welcome.

Anyway, ping me at [@edeniska](https://twitter.com/edeniska). :)

## See also

If you use Zeplin for designs – check [zeplin-preview-swiftui](https://github.com/eDeniska/zeplin-preview-swiftui).

## Roadmap

At the moment, there are couple of ideas of features to be added:
- ability to overlay view with Figma representation to check the pixel-perfect differences
- add UIKit version

## License

FigmaPreviewSwiftUI is available under the MIT license. See the LICENSE file for more info.
