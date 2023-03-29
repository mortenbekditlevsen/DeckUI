//
//  PresenterView.swift
//  Demo
//
//  Created by Zachary Brass on 1/17/23.
//

import SwiftUI
public struct PresenterNotesView: View {
    @ObservedObject private var presentationState: PresentationState
    public var body: some View {
        Text(presentationState.deck.slides()[presentationState.slideIndex].comment ?? "No notes")
        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
    }
    public init(state: PresentationState? = nil) {
        presentationState = state ?? .shared
    }
        
    
}
#if canImport(AppKit)
@available(macOS 13.0, *)
public struct PresenterNotes: Scene {
    private let state: PresentationState
    public init(state: PresentationState? = nil) {
        self.state = state ?? .shared
    }
    public var body: some Scene {
        Window("Presenter Notes", id: "notes") {
            PresenterNotesView(state: state)
                .toolbar {
                    SlideNavigationToolbarButtons(state: state)
                }
        }.keyboardShortcut("1")

    }
}
#endif
