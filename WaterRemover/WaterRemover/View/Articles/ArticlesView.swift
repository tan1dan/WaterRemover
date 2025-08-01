
import SwiftUI

struct ArticlesView: View {
    
    @State private var isArticleView = false
    
    var items: [ArticleItem] = [
        ArticleItem(text: "Removing water", subtext: "Simple tips to save your device"),
        ArticleItem(text: "Sound frequency", subtext: "Use of sound in everyday life"),
        ArticleItem(text: "Noise level", subtext: "How the sounds around affect us"),
        ArticleItem(text: "Speakers Check", subtext: "How to check sound quality"),
        ArticleItem(text: "Vibration mode", subtext: "Does it affect the cleaning result?"),
    ]
    
    @State private var indexOfArticle: IndexItem?
    
    var body: some View {
        LinearGradient(colors: [Color.topGradient, Color.bottomGradient], startPoint: .top, endPoint: .bottom)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
            .overlay(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 0) {
                   list()
                        .padding(.horizontal, 20)
                        .padding(.top, Constants.topPadding)
                   Spacer()
               }
                .frame(height: UIScreen.main.bounds.height - 100)
                .frame(maxWidth: .infinity)
                .background(Color.background)
                .clipShape(Constants.highDipShape)
                .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: -1)
            }
            .overlay(alignment: .top) {
                HeaderView(title: "Articles")
                    .padding(.top, 62)
                    .padding(.horizontal, 20)
            }
            .fullScreenCover(item: $indexOfArticle) { indexItem in
                ArticleView(title: items[indexItem.index].text, subTitle: items[indexItem.index].subtext, indexItem: indexItem)
            }
    }
    
    func list() -> some View {
        VStack(spacing: 14) {
            Group {
                ForEach(items.indices, id: \.self) { index in
                    HapticButton {
                        indexOfArticle = IndexItem(index: index)
                    } label: {
                        ArticleCell(title: items[index].text, subtitle: items[index].subtext)
                    }
                }
            }
        }
    }
    
    
    
}

