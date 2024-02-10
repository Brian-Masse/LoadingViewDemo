//
//  ContentView.swift
//  LoadingViewDemo
//
//  Created by Brian Masse on 2/10/24.
//

import SwiftUI
import SwiftData
import UIUniversals

struct ContentView: View {
    
    
    init() {
        Constants.UIDefaultCornerRadius = 20
        
        Colors.setColors(baseLight:         .init(255, 255, 255),
                         secondaryLight:    .init(245, 245, 245),
                         baseDark:          .init(0, 0, 0),
                         secondaryDark:     .init(25.5, 25.5, 25.5),
                         lightAccent:       .init(66, 122, 69),
                         darkAccent:        .init(95, 255, 135))
    }
    
    var body: some View {
        CollectionLoadingView(count: 3, height: 100)
            .padding(.horizontal)
    }
}

//MARK: LoadingView
struct LoadingView: View {
    
    @Environment( \.colorScheme ) var colorScheme
    
    static let width: CGFloat = 450
    static let blur: CGFloat = 35
    
    let height: CGFloat
    
    @State var offset: CGFloat = LoadingView.startingOffset
    @State var shouldAnimate: Bool = true
    
//    MARK: Class Methods
    private func beginAnimation(_ width: CGFloat) {
        self.offset = LoadingView.startingOffset
        withAnimation { self.offset = width }
    }
    
    private static var startingOffset: CGFloat {
        -LoadingView.width - (LoadingView.blur * 2)
    }
    
    private var secondaryStyle: UniversalStyle {
        colorScheme == .dark ? .transparent : .primary
    }
    
    private var highlightColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
//    MARK: ViewBuilders
    @ViewBuilder
    private func makeGradient(facingRight: Bool) -> some View {
        LinearGradient(stops: [.init(color: highlightColor.opacity(0.2), location: 0.55),
                               .init(color: .clear, location: 1)],
                       startPoint: facingRight ? .leading : .trailing,
                       endPoint: facingRight ? .trailing : .leading)
    }
    
    @ViewBuilder
    private func makeBlur() -> some View {
        HStack(spacing: 0) {
            makeGradient(facingRight: false)
            makeGradient(facingRight: true)
        }
        .blur(radius: LoadingView.blur)
        .scaleEffect(x: 0.9)
    }

//    MARK: Body
    var body: some View {
            HStack(alignment: .top) {
                UniversalText("Hello, this is a secret message",
                              size: Constants.UIDefaultTextSize, wrap: false)
                .foregroundStyle(.clear)
                .rectangularBackground(7, style: secondaryStyle, cornerRadius: 10)
                
                UniversalText("hi :)",
                              size: Constants.UIDefaultTextSize, wrap: false)
                .foregroundStyle(.clear)
                .rectangularBackground(7, style: secondaryStyle, cornerRadius: 10)
                
                Spacer()
                
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(width: 10, height: height - 30)
                
                UniversalText("hello",
                              size: Constants.UIDefaultTextSize, wrap: false)
                .foregroundStyle(.clear)
                .rectangularBackground(7, style: secondaryStyle, cornerRadius: 10)
            }
            .padding()
            .overlay { GeometryReader { geo in
                makeBlur()
                    .frame(width: LoadingView.width)
                    .offset(x: offset)
                    .opacity(0.5)
                    .animation(Animation
                        .easeInOut(duration: 2)
                        .delay(0.6)
                        .repeatForever(autoreverses: false),
                               value: offset)
                    .onAppear { beginAnimation(UIScreen.main.bounds.width + LoadingView.blur + 15) }
            }}
        .rectangularBackground(0, style: .secondary)
    }
}

//MARK: CollectionLoadingView
struct CollectionLoadingView: View {
    let count: Int
    let height: CGFloat
    
    var body: some View {
        VStack {
            ForEach( 0..<count, id: \.self ) { _ in
                LoadingView(height: height)
            }
        }
    }
}


#Preview {
    ContentView()
}
