//
//  MemoView.swift
//  Hard_Memo
//
//  Created by 하고 싶은 걸 하고 살자 on 10/26/25.
//
import SwiftUI
import Foundation
import CoreGraphics

struct MemoView: View {
    @State private var location: [[CGPoint]] = []
    @State private var currentlocation: [CGPoint] = []
    @State private var rectLocation: [ShapeData] = []
    @State private var circleLocation: [ShapeData] = []
    
    @State private var mode = 0
    @State private var shape: ShapeData?
    @State private var shpaeType: Shape = .circle
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
                
                ForEach(0..<rectLocation.count, id: \.self) { i in
                    Path { path in
                        let shape = rectLocation[i]
                        path.move(to: shape.points[0])
                        //                        path.addRect(CGRect(origin: shape.points[0], size: CGSize(width: (shape.points.last?.x ?? 0) - shape.points[0].x, height: (shape.points.last?.y ?? 0) - shape.points[0].y)))
                        let lastP = shape.points.last ?? .zero
                        path.addLine(to: CGPoint(x: lastP.x, y: shape.points[0].y))
                        path.addLine(to: lastP)
                        path.addLine(to: CGPoint(x: shape.points[0].x, y: lastP.y))
                        path.addLine(to: shape.points[0])
                    }
                    .stroke(Color.blue, lineWidth: 6)
                    .frame(width: width, height: height)
                    .background(.white.opacity(0.001))
                }
                //
                ForEach(0..<circleLocation.count, id: \.self) { i in
                    let shape = circleLocation[i]
                    let startPoint = shape.points[0]
                    let lastPoint = shape.points.last ?? .zero
                    let midPoint = CGPoint(x: (startPoint.x + lastPoint.x) / 2, y: (startPoint.y + lastPoint.y) / 2)
                    let rx = shape.points[0].x - midPoint.x
                    let ry = shape.points[0].y - midPoint.y
                    let r = sqrt( (rx * rx) + (ry * ry))
                    Path { path in
                        path.move(to: startPoint)
                        
                        for index in 24..<60 {
                            let degree = Double(index) * 10
                            let p = point(onCircleWith: midPoint,
                                          radius: r,
                                          degree: degree)
                            path.addLine(to: p)
                        }
                    }
                    .stroke(Color.blue, lineWidth: 1)
                    .frame(width: width, height: height)
                    .background(.white.opacity(0.001))
                    //                        path.addEllipse(in: CGRect(origin: shape.points[0], size: CGSize(width: (shape.points.last?.x ?? 0) - shape.points[0].x, height: (shape.points.last?.y ?? 0) - shape.points[0].y)))
                }
            }
            .frame(width: width, height: height)
            .background(Color.black)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
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
                        } else if mode == 2 {
                            if shape == nil {
                                shape = ShapeData(points: [value.location])
                                return
                            }
                            shape?.points.append(value.location)
                        }
                    }
                    .onEnded { _ in
                        if mode == 0 {
                            location.append(currentlocation)
                            currentlocation = []
                        } else if mode == 2, let shape = self.shape {
                            switch self.shpaeType {
                            case .circle:
                                circleLocation.append(shape)
                            case .rectangle:
                                rectLocation.append(shape)
                            }
                            self.shape = nil
                        }
                        print("Drawing ended with \(location.count) points")
                    }
            )
            .overlay(alignment: .bottom) {
                Button {
                    if mode == 0 {
                        mode = 1
                    } else if mode == 1 {
                        mode = 2
                    } else if mode == 2 {
                        mode = 0
                    }
                } label: {
                    if mode == 0 {
                        Text("펜")
                            .foregroundStyle(.green)
                    } else if mode == 1 {
                        Text("지우개")
                            .foregroundStyle(.green)
                    } else if mode == 2 {
                        Text("도형")
                            .foregroundStyle(.green)
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                Menu("도형 선택") {
                    Button {
                        shpaeType = .rectangle
                    } label: {
                        Text("정사각형")
                            .foregroundStyle(.green)
                    }
                    
                    Button {
                        shpaeType = .circle
                    } label: {
                        Text("원")
                            .foregroundStyle(.green)
                    }
                }
            }
        }
    }
    
    func point(onCircleWith center: CGPoint, radius: CGFloat, degree: Double) -> CGPoint {
        let nDegree = degree > 360 ? degree - 360 : degree
        let rad = nDegree * .pi / 180
        return CGPoint(x: center.x + radius * cos(rad),
                       y: center.y + radius * sin(rad))
    }
}
