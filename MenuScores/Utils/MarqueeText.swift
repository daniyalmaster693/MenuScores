//
//  MarqueeText.swift
//  boringNotch
//
//  Created by Richard Kunkli on 08/08/2024.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct MeasureSizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background(GeometryReader { geometry in
            Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
        })
    }
}

struct MarqueeText: View {
    @Binding var text: String
    let font: Font
    let nsFont: NSFont.TextStyle
    let textColor: Color
    let backgroundColor: Color
    let minDuration: Double
    let frameWidth: CGFloat

    @State private var animate = false
    @State private var textSize: CGSize = .zero
    @State private var offset: CGFloat = 0
    @State private var configuredText = ""
    @State private var configuredFrameWidth: CGFloat = 0

    init(_ text: Binding<String>, font: Font = .body, nsFont: NSFont.TextStyle = .body, textColor: Color = .primary, backgroundColor: Color = .clear, minDuration: Double = 3.0, frameWidth: CGFloat = 300) {
        _text = text
        self.font = font
        self.nsFont = nsFont
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.minDuration = minDuration
        self.frameWidth = frameWidth
    }

    private var needsScrolling: Bool {
        textSize.width > frameWidth
    }

    var body: some View {
        GeometryReader { _ in
            ZStack(alignment: .leading) {
                HStack(spacing: 20) {
                    Text(text)
                    Text(text)
                        .opacity(needsScrolling ? 1 : 0)
                }
                .id(text)
                .font(font)
                .foregroundColor(textColor)
                .fixedSize(horizontal: true, vertical: false)
                .offset(x: animate ? offset : 0)
                .animation(
                    animate ?
                        .linear(duration: Double(textSize.width / 40))
                        .delay(minDuration)
                        .repeatForever(autoreverses: false) : .none,
                    value: animate
                )
                .background(backgroundColor)
                .modifier(MeasureSizeModifier())
                .onPreferenceChange(SizePreferenceKey.self) { size in
                    let measuredWidth = size.width / 2
                    let measuredHeight = NSFont.preferredFont(forTextStyle: nsFont).pointSize
                    let newSize = CGSize(width: measuredWidth, height: measuredHeight)

                    guard measuredWidth > 0 else { return }

                    let widthDelta = abs(measuredWidth - textSize.width)
                    let frameChanged = abs(frameWidth - configuredFrameWidth) > 0.5
                    let textChanged = text != configuredText

                    guard widthDelta > 0.5 || frameChanged || textChanged || textSize == .zero else { return }

                    textSize = newSize
                    updateScrollingState(forceRestart: textChanged || frameChanged)
                }
            }
            .frame(width: frameWidth, alignment: .leading)
            .clipped()
        }
        .frame(height: textSize.height * 1.3)
        .onChange(of: text) { _ in
            updateScrollingState(forceRestart: true)
        }
        .onChange(of: frameWidth) { _ in
            updateScrollingState(forceRestart: true)
        }
    }

    private func updateScrollingState(forceRestart: Bool) {
        configuredText = text
        configuredFrameWidth = frameWidth

        guard needsScrolling else {
            animate = false
            offset = 0
            return
        }

        let targetOffset = -(textSize.width + 10)
        if forceRestart || !animate || offset != targetOffset {
            animate = false
            offset = 0
            animate = true
            offset = targetOffset
        }
    }
}
