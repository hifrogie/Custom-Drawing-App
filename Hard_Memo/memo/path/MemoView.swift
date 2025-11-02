//
//  MemoView.swift
//  Hard_Memo
//
//  Created by 하고 싶은 걸 하고 살자 on 10/26/25.
//
import SwiftUI

struct MemoView: View {
    @State private var location: [[CGPoint]] = []
    @State private var currentlocation: [CGPoint] = []
    @State private var lastIndex = 0
    
    @State private var mode = 0
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            ZStack {
                ForEach(0..<location.count, id: \.self) { i in
                    Path { path in
                        let pArray = location[i]
                        guard let firstPoint = pArray.first else { return }
                        path.move(to: firstPoint)
                        for (i, p) in pArray.enumerated() {
                            if i != 0 {
                                path.addLine(to: p)
                                print("Point \(p.x) \(p.y)")
                            }
                        }
                    }
                    .stroke(Color.blue, lineWidth: 6)
                    .frame(width: width, height: height)
                    .background(.white.opacity(0.001))
                }
            }
            .frame(width: width, height: height)
            .background(Color.black)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        // 터치 중인 좌표를 계속 추가
                        
                        if mode == 0 {
                            currentlocation.append(value.location)
                        } else if mode == 1 {
                            let radius: CGFloat = 10
                            var newPaths: [[CGPoint]] = []
                            for path in location {
                                var currentSegment: [CGPoint] = []
                                for point in path {
                                    let distance = hypot(point.x - value.location.x, point.y - value.location.y)
                                    if distance > radius {
                                        currentSegment.append(point)
                                    } else {
                                        if currentSegment.count >= 2 {
                                            newPaths.append(currentSegment)
                                        }
                                        currentSegment = []
                                    }
                                }
                                if currentSegment.count >= 2 {
                                    newPaths.append(currentSegment)
                                }
                            }
                            location = newPaths
                        }
                    }
                    .onEnded { _ in
                        if mode != 1 {
                            location.append(currentlocation)
                            currentlocation = []
                        }
                        lastIndex += 1
                        print("Drawing ended with \(location.count) points")
                    }
            )
            .overlay(alignment: .bottom) {
                Button {
                    if mode == 0 {
                        mode = 1
                    } else if mode == 1 {
                        mode = 0
                    }
                } label: {
                    
                        if mode == 0 {
                            Text("지우개")
                                .foregroundStyle(.green)
                        } else if mode == 1 {
                            Text("펜")
                                .foregroundStyle(.green)
                        }
                }
            }
        }
    }
}
