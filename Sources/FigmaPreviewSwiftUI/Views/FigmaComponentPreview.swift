//
//  FigmaComponentPreview.swift
//  FigmaPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import SwiftUI
import Combine


struct ToastView: View {
    @Binding var message: String?

    init(message: Binding<String?>) {
        _message = message
    }

    private func hide() {
        withAnimation {
            message = nil
        }
    }

    var body: some View {
        if let message = message {
            Text(message)
                .multilineTextAlignment(.center)
                .font(.callout)
                .foregroundColor(Color(UIColor.systemBackground))
                .padding()
                .background(Capsule().fill(Color.primary))
                .padding()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        hide()
                    }
                }
                .onTapGesture {
                    hide()
                }
        } else {
            EmptyView()
        }
    }
}

extension View {
    @ViewBuilder func toast(_ message: Binding<String?>) -> some View {
        overlay(VStack {
            ToastView(message: message)
            Spacer()
        })
    }
}

struct FigmaComponentPreview: View {
    private let figmaComponent: FigmaComponent
    init(figmaComponent: FigmaComponent) {
        self.figmaComponent = figmaComponent
    }

    @State private var toastMessage: String?
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                FigmaView(fileId: figmaComponent.fileId, componentId: figmaComponent.componentId)
                Divider()
                Text(figmaComponent.title)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(figmaComponent.details)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Button {
                        UIPasteboard.general.string = figmaComponent.componentId
                        withAnimation {
                            toastMessage = NSLocalizedString("Component ID is copied to clipboard", bundle: .module, comment: "Component ID is copied to clipboard")
                        }
                    } label: {
                        Image(systemName: "doc.on.doc")
                            .padding()
                    }
                    VStack {
                        Text("Component ID", bundle: .module)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(figmaComponent.componentId)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                }
                HStack {
                    Button {
                        UIPasteboard.general.string = figmaComponent.fileId
                        withAnimation {
                            toastMessage = NSLocalizedString("File ID is copied to clipboard", bundle: .module, comment: "File ID copied to clipboard")
                        }
                    } label: {
                        Image(systemName: "doc.on.doc")
                            .padding()
                    }
                    VStack {
                        Text("File ID", bundle: .module)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(figmaComponent.fileId)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                }
            }.padding()
        }
        .toast($toastMessage)
        .navigationTitle(figmaComponent.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
