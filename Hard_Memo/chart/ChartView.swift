//
//  ChartView.swift
//  Hard_Memo
//
//  Created by 하고 싶은 걸 하고 살자 on 11/11/25.
//
import SwiftUI

struct ChartView: View {
    @State var toggleOn = false
    @State var number: [CGFloat] = []
    let xNum = 40
    let yNum: CGFloat = 100
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let graphH = height / 2.5
            VStack {
                ZStack {
                    if toggleOn {
                        ForEach(1..<number.count, id: \.self) { i in
                            Path { path in
                                var newIndex = i
                                let y = calcY(value: number[i], graphH: graphH)
                                let sWidth = width / CGFloat(xNum)
                                let lastX = sWidth * CGFloat(i-1)
                                let x = sWidth * CGFloat(newIndex)
                                let lastY = calcY(value: number[i-1], graphH: graphH)
                                let midX = (x + lastX) / 2
                        
                                path.move(to: CGPoint(x:lastX, y:lastY))
                                if (i - 2) < 0 || (i + 2) > number.count {
                                    path.addCurve(to: CGPoint(x:x, y:y), control1: CGPoint(x: midX, y: lastY), control2: CGPoint(x: midX, y: y))
                                } else {
                                    path = makePath(i:i, width: width, graphH: graphH, p: path)
                                }
                            }.stroke(Color.blue, lineWidth: 6)
                        }
                    } else {
                        Path { path in
                            
                        }
                    }
                }.frame(width: width, height: graphH)
                Toggle(isOn: $toggleOn) {
                    Text("선")
                }
            }.onAppear {
                for i in 0..<xNum {
                    number.append(CGFloat.random(in: 1...yNum))
                }
            }
        }
    }
    
    private func calcY(value: CGFloat, graphH: CGFloat) -> CGFloat {
        return graphH * (value / yNum)
    }
    
    private func makePath(i: Int, width: CGFloat, graphH: CGFloat, p: Path ) -> Path {
        var newIndex = i
        var path = p
        let sWidth = width / CGFloat(xNum)
        let x = sWidth * CGFloat(newIndex)
        let y = calcY(value: number[i], graphH: graphH)
        let lastX = sWidth * CGFloat(i-1)
        let lastY = calcY(value: number[i-1], graphH: graphH)
        let midX = (x + lastX) / 2
        let midY = (y + lastY) / 2
        
        if number.count > (i + 1) {
            let nextY = calcY(value: number[i + 1], graphH: graphH)
            let lastY2 = calcY(value: number[i - 2], graphH: graphH)
            
            if lastY < y { // 하강
                if nextY > y {
                    if lastY >= lastY2 {
                        path.addQuadCurve(to: CGPoint(x: x, y: y), control: CGPoint(x: midX, y: midY))
                    } else {
                        path.addQuadCurve(to: CGPoint(x: x, y: y), control: CGPoint(x: midX, y: lastY ))
                    }
                } else if nextY == y {
                    path.addQuadCurve(to: CGPoint(x: x, y: y), control: CGPoint(x: midX, y: midY))
                } else {
                    if lastY >= lastY2 {
                        path.addQuadCurve(to: CGPoint(x: x, y: y), control: CGPoint(x: midX, y: y )) // x
                    } else {
                        path.addCurve(to: CGPoint(x: x, y: y), control1: CGPoint(x: midX, y: lastY), control2: CGPoint(x: midX, y: y))
                    }
                }
            } else if lastY == y {
                path.addQuadCurve(to: CGPoint(x: x, y: y), control: CGPoint(x: midX, y: midY))
            } else {
                if nextY < y {
                    if lastY <= lastY2 {
                        path.addQuadCurve(to: CGPoint(x: x, y: y), control: CGPoint(x: midX, y: midY))
                    } else {
                        path.addQuadCurve(to: CGPoint(x: x, y: y), control: CGPoint(x: midX, y: lastY ))
                    }
                } else if nextY == y {
                    path.addQuadCurve(to: CGPoint(x: x, y: y), control: CGPoint(x: midX, y: midY))
                } else {
                    if lastY <= lastY2 {
                        path.addQuadCurve(to: CGPoint(x: x, y: y), control: CGPoint(x: midX, y: y ))
                    } else {
                        path.addCurve(to: CGPoint(x: x, y: y), control1: CGPoint(x: midX, y: lastY), control2: CGPoint(x: midX, y: y))
                    }
                }
            }
        }
        return path
    }
}
