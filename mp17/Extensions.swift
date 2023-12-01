//
//  Extensions.swift
//  mp17
//
//  Created by Andrew Us on 21.11.23.
//

import SwiftUI

public extension Color {
    static var lightGray: Color { Color.white.opacity(0.6) }
    static var fadeGray: Color { Color.white.opacity(0.3) }
}

extension Double {
    func formatMmSs() -> String {
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}

extension UITabBarController {
    var height: CGFloat {
        return self.tabBar.frame.size.height
    }

    var width: CGFloat {
        return self.tabBar.frame.size.width
    }
}

/// round only specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    //  Kavsoft: https://www.youtube.com/watch?v=UETjgKWWB1I
    @ViewBuilder
    func shine(_ toggle: Bool, duration: CGFloat = 0.5, clipShape: some Shape = .rect, rightToLeft: Bool = false) -> some View {
        self
            .overlay {
                GeometryReader {
                    let size = $0.size
                    let moddedDuration = max(0.3, duration)

                    Rectangle()
                        .fill(.linearGradient(
                            colors: [
                                .clear,
                                .clear,
                                .white.opacity(0.1),
                                .white.opacity(0.5),
                                .white.opacity(1),
                                .white.opacity(0.5),
                                .white.opacity(0.1),
                                .clear,
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing)
                        )
                        .scaleEffect(y: 8)
                        .keyframeAnimator(initialValue: 0.0, trigger: toggle, content: { content, progress in
                            content
                                .offset(x: -size.width + (progress * size.width * 2))
                        }, keyframes: { _ in
                            CubicKeyframe(.zero, duration: 0.1)
                            CubicKeyframe(1, duration: moddedDuration)
                        })
                        .rotationEffect(.init(degrees: 45))
                        .scaleEffect(x: rightToLeft ? -1 : 1)
                }
            }
            .clipShape(clipShape)
    }
}
