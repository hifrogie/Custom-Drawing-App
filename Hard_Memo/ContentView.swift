//
//  ContentView.swift
//  Hard_Memo
//
//  Created by 하고 싶은 걸 하고 살자 on 10/26/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MemoView()
                .frame(width:.infinity, height: .infinity)
//            DrawView()
        }.background(Color.red)
    }
}

#Preview {
    ContentView()
}
