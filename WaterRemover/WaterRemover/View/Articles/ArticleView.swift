
import SwiftUI

struct ArticleView: View {
    
    @State private var isArticleView = false
    
    let title: String
    let subTitle: String
    let indexItem: IndexItem
    
    var body: some View {
        LinearGradient(colors: [Color.topGradient, Color.bottomGradient], startPoint: .top, endPoint: .bottom)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
            .overlay(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 0) {
                   scrollText()
                        .padding(.horizontal, 20)
                   Spacer()
               }
                .frame(height: UIScreen.main.bounds.height - 100)
                .frame(maxWidth: .infinity)
                .background(Color.background)
                .clipShape(Constants.highDipShape)
                .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: -1)
            }
            .overlay(alignment: .top) {
                HeaderView(title: title)
                    .padding(.top, 62)
                    .padding(.horizontal, 20)
            }
    }
    
    private func scrollText() -> some View {
        ScrollView {
            VStack(alignment: .center, spacing: 22) {
                Text(subTitle)
                    .font(.gilroy(size: 16, weight: .bold))
                    .foregroundStyle(Color.text)
                    .padding(.top, Constants.topPadding)
                Text(Constants.articles[indexItem.index])
                    .font(.gilroy(size: 14, weight: .medium))
                    .foregroundStyle(Color.text)
                    .padding(.bottom, 100)
            }
        }
        .scrollIndicators(.hidden)
        .mask(
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.background, location: 0.0),
                    .init(color: Color.background, location: 0.8),
                    .init(color: .clear, location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            ))
    }
}

