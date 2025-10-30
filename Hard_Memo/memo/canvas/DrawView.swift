//
//  DrawView.swift
//  Hard_Memo
//
//  Created by 하고 싶은 걸 하고 살자 on 10/29/25.
//
import SwiftUI

struct DrawView: View {
    @State var location: [DrawData] = []
    @State var penColor: Color = .black
    @State private var lastIndex = 0
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    penColor = .black
                } label: {
                    Text("Black")
                        .foregroundStyle(.black)
                }
                
                Button {
                    penColor = .clear
                } label: {
                    Text("Black")
                        .foregroundStyle(.black)
                }
            }
            Canvas { context, size in
                for pArray in location {
                    let firstP = pArray.points.first ?? .zero
                    var path = Path()
                    path.move(to: firstP)
                    for p in pArray.points {
                        path.addLine(to: p)
                    }
                    if penColor != .clear {
                        context.stroke(path, with: .color(penColor), lineWidth: 4)
                    } else {
                        context.blendMode = .clear
                        context.stroke(path, with: .color(penColor), lineWidth: 4)
                    }
                }
            }
            .frame(width: .infinity, height: .infinity)
        }
        .background(.white.opacity(0.001))
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
//                    location.append(value.location)
                }
                .onEnded { _ in
                        
                    print("Drawing ended with \(location.count) points")
                }
        )
        
    }
}
