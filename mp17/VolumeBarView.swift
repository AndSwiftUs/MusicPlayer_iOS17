//
//  VolumeBarView.swift
//  mp17
//
//  Created by Andrew Us on 23.11.23.
//

import SwiftUI

struct VolumeBarView: View {
    @Binding var volume: Double

    let barHeight: CGFloat = 8.0
    let barHeightDragg: CGFloat = 12.0

    @State private var progress: Double = 0.0
    @State private var tempProgress: Double = 0.0

    // при нажатии/перетаскивании
    @State private var isDragging = false
    @State private var isPressed = false

    // если затянули за левый край
    @State private var isLeft: CGFloat = .zero
    // если затянули за правый край
    @State private var isRight: CGFloat = .zero

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Image(systemName: "volume.fill")
                    .padding(.trailing)
                    .symbolEffect(.bounce, value: isLeft == 0.0)

                GeometryReader { geo in
                    let barWidth = geo.size.width

                    RoundedRectangle(cornerRadius: isPressed ? barHeight : barHeight / 2)
                        .foregroundStyle(.ultraThinMaterial)
                        .frame(height: isPressed ? barHeightDragg : barHeight)
                        .overlay(alignment: .leading) {
                            RoundedRectangle(
                                cornerRadius: isPressed ? barHeight : barHeight / 2
                            )
                            .fill(.white)
                            .frame(width: tempProgress * barWidth, height: isPressed ? barHeightDragg : barHeight)
                        }
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                .onChanged { gestureValue in
                                    isPressed = true
                                    tempProgress = volume

                                    if abs(gestureValue.translation.width) > 0.01 {
                                        isDragging = true

                                        let activeWidth = gestureValue.startLocation.x - gestureValue.location.x

                                        progress = activeWidth / barWidth

                                        switch tempProgress - progress {
                                            case ...0:
                                                withAnimation {
                                                    isLeft = max(progress, -0.05)
                                                }
                                                tempProgress = 0
                                            case 1...:
                                                withAnimation {
                                                    isRight = -min(progress, 1.05)
                                                }
                                                tempProgress = 1
                                            default:
                                                isLeft = 0.0
                                                isRight = 0.0
                                                tempProgress -= progress
                                        }
                                    }
                                }
                                .onEnded { _ in
                                    volume = tempProgress
                                    progress = 0
                                    isDragging = false
                                    isPressed = false
                                    isLeft = 0.0
                                    isRight = 0.0
                                }
                        )
                }
                .frame(height: isDragging || isPressed ? barHeight * 2 : barHeight)
                .animation(.default, value: isDragging)

                Image(systemName: "volume.3.fill")
                    .padding(.leading)
                    .symbolEffect(.bounce, value: isRight > 0.0)
            }

            // небольшое расширение по Х при нажатии
            .scaleEffect(x: isPressed ? 1.05 : 1)

            // расширение влево при заезде за габариты
            .scaleEffect(x: isLeft != 0
                ? 1.02
                : 1,
                anchor: .trailing)
            // вправо
            .scaleEffect(x: isRight != 0
                ? 1.02
                : 1,
                anchor: .leading)

            .foregroundStyle(isPressed ? .white : .fadeGray)
            .animation(.default, value: isPressed)

            VStack(spacing: 0) {
                Text("Progress: \(progress) - Volume: \(volume)")
                Text("TempProgress\(tempProgress)")
                Text("Left: \(isLeft) - Right: \(isRight)")
                    .foregroundStyle(isPressed ? .white : .black)
            }
        }
    }
}

#Preview {
    ContentView()
}
