//
//  MoreView.swift
//  Baobab
//
//  Created by 이정훈 on 6/2/25.
//

import SwiftUI

struct MoreView: View {
    @StateObject private var viewModel: MoreViewModel
    
    init(viewModel: MoreViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar()
                .environmentObject(viewModel)
            
            List {
                
            }
        }
        .task {
            await viewModel.fetchUserInfo()
        }
    }
}

fileprivate struct NavigationBar: View {
    @EnvironmentObject private var viewModel: MoreViewModel
    @State private var isShowingUserInfo: Bool = false
    
    var body: some View {
        HStack {
            Button {
                isShowingUserInfo.toggle()
            } label: {
                Text(viewModel.userInfo?.nickName ?? "Unkown")
                    .bold()
                    .font(.title3)
                    .foregroundStyle(.black)
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "gearshape.fill")
                    .foregroundStyle(.black)
            }
        }
        .frame(height: 44)
        .padding([.leading, .trailing], 16)
        .fullScreenCover(isPresented: $isShowingUserInfo) {
            if let userInfo = viewModel.userInfo {
                NavigationStack {
                    UserInfoView(userInfo: userInfo)
                }
            }
        }
    }
}

#Preview {
    MoreView(viewModel: MoreViewModel())
}
