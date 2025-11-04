//
//  ShapeData.swift
//  Hard_Memo
//
//  Created by 하고 싶은 걸 하고 살자 on 11/3/25.
//

import Foundation

struct ShapeData: Identifiable {
    let id = UUID()
    var points: [CGPoint]
}

enum Shape {
    case rectangle
    case circle
}
