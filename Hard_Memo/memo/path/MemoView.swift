//
//  MemoView.swift
//  Hard_Memo
//
//  Created by 하고 싶은 걸 하고 살자 on 10/26/25.
//
import SwiftUI

struct MemoView: View {
    @State private var location: [[CGPoint]] = []
    @State private var lastIndex = 0
    
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
                        if (location.count - 1) < lastIndex {
                            location.append([])
                        }
                        location[self.lastIndex].append(value.location)
                    }
                    .onEnded { _ in
                        lastIndex += 1
                        print("Drawing ended with \(location.count) points")
                    }
            )
            .overlay(alignment: .bottom) {
                Button {
                    if location.count > 0 {
                        location.popLast()
                        lastIndex -= 1
                    }
                } label: {
                    Text("지우개")
                        .foregroundStyle(.green)
                }
            }
        }
    }
}
