//
//  StartStopView.swift
//  WaterRemover
//
//  Created by Иван Знак on 25/07/2025.
//

import SwiftUI

struct StartStopView: View {
    
    @Binding var isActive: Bool
    var body: some View {
        Text(isActive ? "Stop" : "Start")
            .foregroundStyle(Color.white)
            .font(.anekLatin(size: 18, weight: .bold))
            .frame(width: 200, height: 54)
            .background(Color.customBlue)
            .clipShape(.rect(cornerRadius: 30))
    }
}

