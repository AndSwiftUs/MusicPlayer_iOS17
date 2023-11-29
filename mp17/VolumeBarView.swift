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
    let barHeightTouched: CGFloat = 14.0

    @State private var startProgress: Double = 0.0

    @State private var isPressed: Bool = false
    @GestureState private var isDragging: Bool = false

    @State private var scaleLeft: CGFloat = 1.0
    @State private var scaleRight: CGFloat = 1.0

    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "volume.fill")
                .padding(.trailing)
                .symbolEffect(.bounce, value: scaleLeft > 1.01)

            GeometryReader { geo in
                let barWidth = geo.size.width

                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundStyle(.ultraThinMaterial)
                        .frame(height: isPressed ? barHeightTouched : barHeight)

                    Rectangle()
                        .fill(.white)
                        .frame(width: volume * barWidth, height: isPressed ? barHeightTouched : barHeight)
                }
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .global)
                        .updating($isDragging) { value, state, transaction in
                            state = true
                        }
                        .onChanged { gestureValue in
                            if !isPressed {
                                startProgress = volume
                            }

                            isPressed = true

                            let tempProgress = startProgress + (gestureValue.translation.width / barWidth)

                            volume = min(max(0, tempProgress), 1)

                            switch tempProgress {
                                case ...0:
                                    scaleLeft = sqrt(sqrt(sqrt(1 - tempProgress)))
                                case 1...:
                                    scaleRight = sqrt(sqrt(sqrt(tempProgress)))
                                default:
                                    scaleLeft = 1
                                    scaleRight = 1
                            }
                        }
                        .onEnded { _ in
                            isPressed = false
                            withAnimation {
                                startProgress = 0
                                scaleLeft = 1
                                scaleRight = 1
                            }
                        }
                )
            }
            .frame(height: isPressed ? barHeight * 2 : barHeight)

            Image(systemName: "volume.3.fill")
                .padding(.leading)
                .symbolEffect(.bounce, value: scaleRight > 1.01)
        }
        // небольшое расширение по Х при нажатии
        .scaleEffect(x: isPressed ? 1.02 : 1)

        // расширение влево/вправо при заезде за габариты
        .scaleEffect(x: scaleLeft, anchor: .trailing)
        .scaleEffect(x: scaleRight, anchor: .leading)

        .foregroundStyle(isPressed ? .white : .fadeGray)
        .animation(.default, value: isPressed)
    }
}

#Preview {
    ContentView()
}
