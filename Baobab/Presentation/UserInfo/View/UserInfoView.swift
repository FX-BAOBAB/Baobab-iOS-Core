//
//  UserInfoView.swift
//  Baobab
//
//  Created by 이정훈 on 6/3/25.
//

import Kingfisher
import SwiftUI

struct UserInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingEditForm: Bool = false
    let userInfo: UserInfo
    
    var body: some View {
        ScrollView {
            ProfileView(
                nickName: userInfo.nickName,
                profileImage: userInfo.profileImage
            )
            
            Color.gray0
            
            BasicInfoView(
                name: userInfo.name,
                phoneNumber: userInfo.phoneInfo.number,
                email: userInfo.email
            )
            
            Divider()
            
            AddressInfoView(address: userInfo.address)
            
            Divider()
            
            Button {
                isShowingEditForm.toggle()
            } label: {
                Text("수정하기")
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                            .foregroundStyle(.gray)
                    }
            }
            .padding([.leading, .trailing])
            .padding(.top, 50)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("내 정보")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                }
            }
        }
        .navigationDestination(isPresented: $isShowingEditForm) {
            UserInfoEditForm(viewModel: UserInfoEditViewModel(userInfo: userInfo))
        }
    }
}

fileprivate struct ProfileView: View {
    let nickName: String
    let profileImage: ProfileImage
    
    var body: some View {
        VStack {
            KFImage(URL(string: profileImage.imageURL))
                .placeholder {
                    Color.clear
                        .skeleton(with: true)
                }
                .resizable()
                .frame(width: 70, height: 70)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(25)
                .padding(.top)
            
            Text(nickName)
                .font(.headline)
                .padding()
        }
    }
}

fileprivate struct BasicInfoView: View {
    let name: String
    let phoneNumber: String
    let email: String
    
    var body: some View {
        VStack(spacing: 20) {
            ContentView(key: "이름", value: name)
            
            ContentView(key: "전화번호", value: phoneNumber)
            
            ContentView(key: "이메일", value: email)
        }
        .headline("기본정보")
    }
}

fileprivate struct AddressInfoView: View {
    let address: UserAddress
    
    var body: some View {
        VStack(spacing: 20) {
            ContentView(key: "주소", value: address.address)
            
            ContentView(key: "상세주소", value: address.detailAddress)
            
            ContentView(key: "우편번호", value: address.postCode)
        }
        .headline("주소정보")
    }
}

fileprivate struct ContentView: View {
    let key: String
    let value: String
    
    var body: some View {
        HStack {
            Text(key)
                .foregroundStyle(.gray)
            
            Spacer()
            
            Text(value)
        }
    }
}

fileprivate struct HeadlineViewModifier: ViewModifier {
    let title: String
    
    func body(content: Content) -> some View {
        VStack(spacing: 30) {
            Text(title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            content
        }
        .padding()
    }
}

fileprivate extension View {
    func headline(_ title: String) -> some View {
        modifier(HeadlineViewModifier(title: title))
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        UserInfoView(userInfo: UserInfo.sampleData)
    }
}
#endif
