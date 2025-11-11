//
//  MemoView.swift
//  Hard_Memo
//
//  Created by 하고 싶은 걸 하고 살자 on 10/26/25.
//
import SwiftUI
import Foundation
import CoreGraphics

struct NewMemoView: View {
    @State private var location: [[CGPoint]] = []
    @State private var currentlocation: [CGPoint] = []
    @State private var shapeLocation: [CGPoint] = []
    @State private var mode = 0
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
                            if shapeLocation.count == 0 {
                                shapeLocation.append(value.location)
                            }
                        }
                    }
                    .onEnded { value in
                        if mode == 0 {
                            location.append(currentlocation)
                            currentlocation = []
                        } else if mode == 2 {
                            shapeLocation.append(value.location)
//                            makeCircle()
                            makeSquare()
                            shapeLocation = []
                            currentlocation = []
                        } else if mode == 3 {
                            shapeLocation.append(value.location)
                            makeSquare()
                            shapeLocation = []
                            currentlocation = []
                            
                        }
                        print("mode = \(mode)")
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
    
    func makeRect() {
        let startPoint = shapeLocation[0]
        let lastPoint = shapeLocation.last ?? .zero
        let leftBottomP = CGPoint(x: startPoint.x, y: lastPoint.y)
        let rightTopP = CGPoint(x: lastPoint.x, y: startPoint.y)
        
        
    }
    
//    func makeRowPoints(startPoint:CGPoint, endPoint:CGPoint) -> [CGPoint] {
//        let diffX = (endPoint.x - startPoint.x)
//        let diffY = (endPoint.y - startPoint.y)
//        
//        let distance = sqrt( (diffX * diffX) + (diffY * diffY))
//        
//        if startPoint.x > endPoint.x {
//            for i in Int(distance / 10) {
//                
//            }
//        }
//        
//    }
    func makeCircle() {
        let startPoint = shapeLocation[0]
        let lastPoint = shapeLocation.last ?? .zero
        let midPoint = CGPoint(x: (startPoint.x + lastPoint.x) / 2, y: (startPoint.y + lastPoint.y) / 2)
        let rx = startPoint.x - midPoint.x
        let ry = startPoint.y - midPoint.y
        let r = sqrt( (rx * rx) + (ry * ry))
        
        for index in 1...37 {
                let degree = Double(index) * 10
                let p = point(onCircleWith: midPoint,
                              radius: r,
                              degree: degree)
                currentlocation.append(p)
                
        }
        location.append(currentlocation)
    }
    
    func makeSquare() {
        let startPoint = shapeLocation[0]
        let lastPoint = shapeLocation.last ?? .zero
        
        let rx = startPoint.x
        let ry = startPoint.y
        let zx = lastPoint.x
        let zy = lastPoint.y
        
        let divNum = 10
        let partX = (zx - rx) / CGFloat(divNum)
        let partY = (zy - ry) / CGFloat(divNum)
        
        for i in 0...divNum {
            let topX = rx + (partX * CGFloat(i))
            currentlocation.append(CGPoint(x: topX, y: ry))
        }
        
        for i in 0...divNum {
            let leftY = ry + (partY * CGFloat(i))
            currentlocation.append(CGPoint(x: zx, y: leftY))
        }
        
        for i in 0...divNum {
            let bottomX = zx - (partX * CGFloat(i))
            currentlocation.append(CGPoint(x: bottomX, y: zy))
        }
        
        for i in 0...divNum {
            let leftY = zy - (partY * CGFloat(i))
            currentlocation.append(CGPoint(x: rx, y: leftY))
        }
        
        location.append(currentlocation)
    }
    func point(onCircleWith center: CGPoint, radius: CGFloat, degree: Double) -> CGPoint {
        let nDegree = degree > 360 ? degree - 360 : degree
        let rad = nDegree * .pi / 180
        return CGPoint(x: center.x + radius * cos(rad),
                       y: center.y + radius * sin(rad))
    }
}
