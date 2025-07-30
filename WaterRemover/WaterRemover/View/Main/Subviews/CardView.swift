//
//  CardView.swift
//  WaterRemover
//
//  Created by Иван Знак on 17/07/2025.
//

import SwiftUI

struct CardView: View {
    
    let image: Image
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            //Images
            HStack(alignment: .top, spacing: 0) {
                image
                    .resizable()
                    .frame(width: 42, height: 42)
                Spacer()
                Image(.arrow)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .padding(.all, 10)
            //Titles
            
            Text(title)
                .foregroundStyle(Color.text)
                .font(.gilroy(size: 16, weight: .bold))
                .padding(.leading, 10)
            
            Text(subtitle)
                .foregroundStyle(Color.text.opacity(0.5))
                .font(.gilroy(size: 14, weight: .medium))
                .padding(.leading, 10)
                .padding(.top, 1)
        }
        .frame( height: 115)
        .background(.white)
        .clipShape(.rect(cornerRadius: 20))
    }
}

