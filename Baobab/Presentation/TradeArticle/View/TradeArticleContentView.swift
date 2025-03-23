//
//  TradeArticleContentView.swift
//  Baobab
//
//  Created by 이정훈 on 3/20/25.
//

import SwiftUI
import SkeletonUI
import Kingfisher

struct TradeArticleContentView: View {
    @StateObject private var viewModel: TradeArticleContentViewModel
    @Environment(\.dismiss) private var dismiss
    let article: TradeArticle
    
    init(viewModel: TradeArticleContentViewModel, article: TradeArticle) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.article = article
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                ImageTabView(imagesData: $viewModel.imagesData)
                    .padding(.bottom)
                
                VStack(alignment: .leading) {
                    SimpleUserProfile(userInfo: article.simpleUserInfo)
                    
                    Divider()
                        .padding([.top, .bottom])
                    
                    Text(article.title)
                        .bold()
                        .font(.title2)
                    
                    Text(article.registeredAt ?? "")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.bottom)
                    
                    Text(article.content)
                }
                .padding([.leading, .trailing, .bottom])
            }
            .scrollIndicators(.hidden)
            .edgesIgnoringSafeArea(.top)
            
            VStack(spacing: 0) {
                Divider()
                
                HStack(spacing: 1) {
                    Text("\(article.price)")
                        .bold()
                        .foregroundStyle(.accent)
                    
                    Text("원")
                        .bold()
                    
                    Spacer()
                    
                    Button("판매자와 채팅하기") {
                        
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                }
            }
        }
    }
}

fileprivate struct SimpleUserProfile: View {
    let userInfo: SimpleUserInfo
    
    var body: some View {
        HStack {
            KFImage(userInfo.profileURL)
                .placeholder {
                    Color.clear
                        .skeleton(with: true)
                }
                .resizable()
                .frame(width: 50, height: 50)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(25)
            
            Text(userInfo.nickName)
        }
    }
}

fileprivate struct ImageTabView: View {
    @Binding private var imagesData: [Data]?
    
    init(imagesData: Binding<[Data]?>) {
        self._imagesData = imagesData
    }
    
    var body: some View {
        TabView {
            if let imagesData = imagesData {
                
            } else {
                ForEach(0..<6) { _ in
                    Color.clear
                        .skeleton(with: true,
                                  size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                }
            }
        }
        .tabViewStyle(.page)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        TradeArticleContentView(viewModel: TradeArticleContentViewModel(),
                                article: TradeArticle.sampleData)
    }
}
#endif
