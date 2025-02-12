//
//  SignupForm.swift
//  Baobab
//
//  Created by 이정훈 on 2/5/25.
//

import SwiftUI

struct SignupForm: View {
    @StateObject private var viewModel: SignupFormViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var isShowingSheet: Bool = false
    
    init(viewModel: SignupFormViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                TextForm(
                    text: $viewModel.email,
                    placeholder: "ex: baobab@baobab.com"
                )
                .title("이메일")
                
                TextForm(
                    text: $viewModel.password,
                    placeholder: "대소문자, 특수문자 포함 최소 8자리 이상",
                    isSecureText: true
                )
                .title("비밀번호")
                
                TextForm(
                    text: $viewModel.confirmPassword,
                    placeholder: "비밀번호를 다시 한번 입력해 주세요",
                    isSecureText: true
                )
                .title("비밀번호 확인")
                
                TextForm(
                    text: $viewModel.nickName,
                    placeholder: "닉네임을 입력해 주세요."
                )
                .title("닉네임")
                
                TextForm(
                    text: $viewModel.name,
                    placeholder: "본명을 입력해 주세요."
                )
                .title("이름")
                
                TextForm(
                    text: $viewModel.birthDate,
                    placeholder: "생년월일 8자리 ex: 19001031"
                )
                .title("생년월일")
                .keyboardType(.numberPad)
                
                GenderPicker(genderType: $viewModel.genderType)
                
                NationalityPicker(isForeigner: $viewModel.isForeigner)
                
                CarrierPicker(carrierType: $viewModel.carrierType)
                
                TextForm(
                    text: $viewModel.phoneNumber,
                    placeholder: "전화번호를 입력하세요."
                )
                .title("전화번호")
                .keyboardType(.numberPad)
                
                AddressForm(
                    postCode: $viewModel.postCode,
                    address: $viewModel.address,
                    detailAddress: $viewModel.detailAddress,
                    isShowingSheet: $isShowingSheet
                )
                
                Button {
                    
                } label: {
                    Text("회원가입")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(.accent)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("회원가입")
        .navigationBarTitleDisplayMode(.inline)
        .background(.background1)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(colorScheme == .light ? .black : .white)
                }
            }
        }
        .sheet(isPresented: $isShowingSheet) {
            NavigationStack {
                PostCodeSearchWebView(roadAddress: $viewModel.address, postCode: $viewModel.postCode)
                    .edgesIgnoringSafeArea(.bottom)
                    .navigationTitle("주소검색")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                isShowingSheet.toggle()
                            } label: {
                                Text("닫기")
                            }
                        }
                    }
            }
        }
        .fork { this in
            if #available(iOS 17, *) {
                this.onChange(of: viewModel.phoneNumber) {
                    viewModel.formatPhoneNumber()
                }
            } else {
                this.onChange(of: viewModel.phoneNumber) { _ in
                    viewModel.formatPhoneNumber()
                }
            }
        }
    }
}

fileprivate struct CarrierPicker: View {
    @State private var isShowingCarrierPicker: Bool = false
    @Binding var carrierType: CarrierType
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleView(title: "통신사", isRequired: true)
            
            HStack {
                Text(carrierType.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(carrierType == .none ? .gray : colorScheme == .light ? .black : .white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
            }
            .padding()
            .background(.background2)
            .cornerRadius(10)
            .onTapGesture {
                isShowingCarrierPicker.toggle()
            }
        }
        .sheet(isPresented: $isShowingCarrierPicker) {
            NavigationStack {
                CarrierPickerSheet(carrierType: $carrierType)
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
    }
}

fileprivate struct CarrierPickerSheet: View {
    @Binding var carrierType: CarrierType
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Picker("", selection: $carrierType) {
            ForEach(CarrierType.allCases, id: \.self) { carrierType in
                HStack(spacing: 20) {
                    if let image = carrierType.fileName {
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                    }
                    
                    Text(carrierType.rawValue)
                }
            }
        }
        .pickerStyle(.wheel)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.black)
                        .opacity(0.3)
                        .overlay {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(.white)
                                .bold()
                        }
                }
            }
        }
    }
}

fileprivate struct GenderPicker: View {
    @Binding var genderType: GenderType?
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleView(title: "성별", isRequired: true)
            
            HStack {
                Button {
                    withAnimation {
                        genderType = .male
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 60)
                        .foregroundStyle(.background2)
                        .overlay {
                            Text("남성")
                                .font(.subheadline)
                                .foregroundStyle(colorScheme == .light ? .black : .white)
                            
                            if genderType == .male {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.accent, lineWidth: 2)
                            }
                        }
                }
                
                Button {
                    withAnimation {
                        genderType = .female
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 60)
                        .foregroundStyle(.background2)
                        .overlay {
                            Text("여성")
                                .font(.subheadline)
                                .foregroundStyle(colorScheme == .light ? .black : .white)
                            
                            if genderType == .female {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.accent, lineWidth: 2)
                            }
                        }
                }
            }
        }
    }
}

fileprivate struct NationalityPicker: View {
    @Binding var isForeigner: Bool?
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleView(title: "국적", isRequired: true)
            
            HStack {
                Button {
                    withAnimation {
                        isForeigner = false
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 60)
                        .foregroundStyle(.background2)
                        .overlay {
                            Text("내국인")
                                .font(.subheadline)
                                .foregroundStyle(colorScheme == .light ? .black : .white)
                            
                            if isForeigner == false {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.accent, lineWidth: 2)
                            }
                        }
                }
                
                Button {
                    withAnimation {
                        isForeigner = true
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 60)
                        .foregroundStyle(.background2)
                        .overlay {
                            Text("외국인")
                                .font(.subheadline)
                                .foregroundStyle(colorScheme == .light ? .black : .white)
                            
                            if isForeigner == true {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.accent, lineWidth: 2)
                            }
                        }
                }
            }
        }
    }
}

fileprivate struct AddressForm: View {
    @Binding var postCode: String
    @Binding var address: String
    @Binding var detailAddress: String
    @Binding var isShowingSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleView(title: "주소", isRequired: true)
            
            HStack {
                Text(postCode)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.background2)
                    .cornerRadius(10)
                
                Button {
                    isShowingSheet.toggle()
                } label: {
                    Text("주소검색")
                        .padding()
                        .background(.background2)
                        .cornerRadius(10)
                }
            }
            
            Text(address)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.background2)
                .cornerRadius(10)
            
            TextForm(text: $detailAddress, placeholder: "상세주소 입력")
        }
        .font(.subheadline)
    }
}

#Preview {
    NavigationStack {
        SignupForm(viewModel: SignupFormViewModel())
    }
}
