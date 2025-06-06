//
//  UserInfoEditForm.swift
//  Baobab
//
//  Created by 이정훈 on 6/3/25.
//

import Kingfisher
import SwiftUI

struct UserInfoEditForm: View {
    @StateObject private var viewModel: UserInfoEditViewModel
    @State private var isShowingAddressSearchView: Bool = false
    @State private var isShowingCarrierPicker: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: UserInfoEditViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Form {
            ProfileEditView(profileImage: $viewModel.proFileImage)
                .listRowBackground(Color.clear)
            
            Section {
                TextField("닉네임을 입력하세요.", text: $viewModel.nickName)
            } header: {
                SectionHeader(title: "닉네임")
            }
            
            Section {
                TextField("전화번호를 입력하세요.", text: $viewModel.phoneNumber)
                
                Button {
                    isShowingCarrierPicker.toggle()
                } label: {
                    HStack {
                        Text(viewModel.carrierType.rawValue)
                            .font(.subheadline)
                            .foregroundStyle(viewModel.carrierType == .none ? .gray : colorScheme == .light ? .black : .white)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.gray)
                    }
                }
            } header: {
                SectionHeader(title: "전화번호")
            }
            .alignmentGuide(.listRowSeparatorLeading) { _ in
                return -20
            }
            
            Section {
                Button {
                    isShowingAddressSearchView.toggle()
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(viewModel.postCode)
                                .foregroundStyle(.accent)
                            
                            Text(viewModel.address)
                                .foregroundStyle(.black)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.gray)
                    }
                }
                
                TextField("상세주소를 입력해 주세요.", text: $viewModel.detailAddress)
            } header: {
                SectionHeader(title: "주소")
            }
            .alignmentGuide(.listRowSeparatorLeading) { _ in
                return -20
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("내 정보 수정")
        .sheet(isPresented: $isShowingAddressSearchView) {
            NavigationStack {
                PostCodeSearchWebView(roadAddress: $viewModel.address, postCode: $viewModel.postCode)
                    .edgesIgnoringSafeArea(.bottom)
                    .navigationTitle("주소검색")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                isShowingAddressSearchView.toggle()
                            } label: {
                                Text("닫기")
                            }
                        }
                    }
            }
        }
        .sheet(isPresented: $isShowingCarrierPicker) {
            NavigationStack {
                CarrierPickerSheet(carrierType: $viewModel.carrierType)
                    .presentationDetents([.height(UIScreen.main.bounds.width * 0.5)])
                    .interactiveDismissDisabled(true)
                    .fork { this in
                        if #available(iOS 16.4, *) {
                            this.presentationBackground(.thinMaterial)
                        } else {
                            this
                        }
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Text("저장")
                }
            }
        }
    }
}

fileprivate struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .bold()
            .offset(x: -15)
    }
}

fileprivate struct ProfileEditView: View {
    @Binding var profileImage: ProfileImage
    
    var body: some View {
        Button {
            
        } label: {
            ZStack {
                KFImage(URL(string: profileImage.imageURL))
                    .placeholder {
                        Color.clear
                            .skeleton(with: true)
                    }
                    .resizable()
                    .frame(width: 70, height: 70)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(25)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Image(systemName: "camera.fill")
                    .font(.subheadline)
                    .padding(10)
                    .background(.white)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke()
                    }
                    .foregroundStyle(.black)
                    .offset(x: 30, y: 20)
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        UserInfoEditForm(viewModel: UserInfoEditViewModel(userInfo: UserInfo.sampleData))
    }
}
#endif
