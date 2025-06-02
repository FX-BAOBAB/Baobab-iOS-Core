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
            NavigationBar(nickName: Binding(
                get: {
                    viewModel.userInfo?.nickName ?? "Unkown"
                }, set: { _ in })
            )
            
            List {
                
            }
        }
        .task {
            await viewModel.fetchUserInfo()
        }
    }
}

fileprivate struct NavigationBar: View {
    @Binding var nickName: String
    
    var body: some View {
        HStack {
            NavigationLink {
                
            } label: {
                Text(nickName)
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
    }
}

#Preview {
    MoreView(viewModel: MoreViewModel())
}
