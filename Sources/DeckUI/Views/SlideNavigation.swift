//
//  SlideNavigation.swift
//  
//
//  Created by Zachary Brass on 3/18/23.
//

import SwiftUI

public struct SlideNavigationToolbarButtons: View {
    @ObservedObject var state: PresentationState
    public var body: some View {
        Group {
            Text("\(state.mySlideIndex + 1) / \(state.slideCount)")

            Button {
                withAnimation {
                    state.previousSlide()
                }
            } label: {
                Label("Previous", systemImage: "arrow.left")
            }.keyboardShortcut(.leftArrow, modifiers: [])
            
            Button {
                withAnimation {
                    state.nextSlide()
                }
            } label: {
                Label("Next", systemImage: "arrow.right")
            }.keyboardShortcut(.rightArrow, modifiers: [])
            
            Button {
                NotificationCenter.default.post(name: .keyDown, object: nil)
            } label: {
                Label("Down", systemImage: "arrow.down")
            }.keyboardShortcut(.downArrow, modifiers: [])
            
            Button {
                NotificationCenter.default.post(name: .keyUp, object: nil)
            } label: {
                Label("Up", systemImage: "arrow.up")
            }.keyboardShortcut(.upArrow, modifiers: [])
        }
    }
    public init(state: PresentationState) {
        self.state = state
    }
}
