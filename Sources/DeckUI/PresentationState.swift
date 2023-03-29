//
//  PresentationState.swift
//  
//
//  Created by Zachary Brass on 3/12/23.
//

import SwiftUI

open class PresentationState: ObservableObject {
    public init() {}
    static let shared = PresentationState()
    @Published var slideIndex = 0
    
    var loop = false
    var slideTransition: SlideTransition? = .horizontal
    
    @Published var activeTransition: AnyTransition = .slideFromTrailing
    
    // Putting in sample Deck in case the user doesn't assign one. It instructs the user on how to add a Deck of their own
    open var deck: Deck = Deck(title: "DeckUI Example") {
            Slide(alignment: .center, comment: "Presenter notes are passed into the comment argument in the init method each of Slide") {
                Title("DeckUI Example")
            }
            
            Slide(alignment: .center) {
                Title("Getting Started")
                Columns {
                    Column {
                        Code(.swift) {
                        """
                        import SwiftUI
                        import DeckUI
                        
                        struct ContentView: View {
                            var body: some View {
                                Presenter(deck: self.deck)
                            }
                        }

                        extension ContentView {
                            var deck: Deck {
                                Deck(title: "SomeConf 2023") {
                                    Slide(alignment: .center) {
                                        Title("Welcome to DeckUI")
                                    }
                        
                                    Slide {
                                        Title("Slide 1")
                                        Words("Some useful content")
                                    }
                                }
                            }
                        }
                        """
                        }
                    }
                    
                    Column {
                        Bullets(style: .bullet) {
                            Words("Create a `Deck` with multiple `Slide` ")
                            Words("Create `Presenter` and give a deck")
                            Words("`Presenter` is a SwiftUI View to present a `Deck`")
                        }
                    }
                }
            }
        }
    public func nextSlide() {
        let slides = self.deck.slides()
        var newSlideIndex = slideIndex
        if slideIndex >= (slides.count - 1) {
            if self.loop {
                newSlideIndex = 0
            }
        } else {
            newSlideIndex += 1
        }
        
        let nextSlide = slides[newSlideIndex]
        
        self.activeTransition = (nextSlide.transition ?? self.slideTransition).next
        Task { @MainActor [newSlideIndex] in
            try await Task.sleep(nanoseconds: 1_000)
            withAnimation {
                self.slideIndex = newSlideIndex
            }
        }
        NotificationCenter.default.post(name: .slideChanged, object: nextSlide)
    }

    public var slideCount: Int { self.deck.slides().count }

    public var mySlideIndex: Int {
        set {
            let slides = self.deck.slides()
            if newValue >= (slides.count - 1) {
                if self.loop {
                    slideIndex = 0
                }
            } else {
                slideIndex = newValue
            }

            let nextSlide = slides[slideIndex]

            self.activeTransition = (nextSlide.transition ?? self.slideTransition).next
        }
        get {
            slideIndex
        }
    }

    public func previousSlide() {
        let slides = self.deck.slides()

        let currentSlide = slides[slideIndex]

        var newSlideIndex = slideIndex
        if slideIndex <= 0 {
            if self.loop {
                newSlideIndex = slides.count - 1
            }
        } else {
            newSlideIndex -= 1
        }

        let previousSlide = slides[newSlideIndex]
        
        self.activeTransition = (currentSlide.transition ?? self.slideTransition).previous

        Task { @MainActor [newSlideIndex] in
            try await Task.sleep(nanoseconds: 1_000)
            withAnimation {
                self.slideIndex = newSlideIndex
            }
        }

        NotificationCenter.default.post(name: .slideChanged, object: previousSlide)

    }
}
