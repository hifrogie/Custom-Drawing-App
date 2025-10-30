//
//  MemoData.swift
//  Hard_Memo
//
//  Created by 하고 싶은 걸 하고 살자 on 10/27/25.
//

import SwiftUICore

struct DrawData: Identifiable {
    let id = UUID()
    var color: Color
    var points: [CGPoint]
}
