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
            VStack(spacing: 20) {
                TextForm(
                    text: $viewModel.email,
                    placeholder: "ex: baobab@baobab.com"
                )
                .title("이메일")
                .state($viewModel.inputStates[0], message: "올바른 이메일 형식을 입력하세요.")
                
                TextForm(
                    text: $viewModel.password,
                    placeholder: "대소문자, 특수문자 포함 최소 8자리 이상",
                    isSecureText: true
                )
                .title("비밀번호")
                .state($viewModel.inputStates[1], message: "대문자, 소문자, 특수문자 포함 8자 이상이어야 해요.")
                
                TextForm(
                    text: $viewModel.confirmPassword,
                    placeholder: "비밀번호를 다시 한번 입력해 주세요",
                    isSecureText: true
                )
                .title("비밀번호 확인")
                .state($viewModel.inputStates[2], message: "비밀번호가 일치하지 않아요.")
                
                TextForm(
                    text: $viewModel.nickName,
                    placeholder: "닉네임을 입력해 주세요."
                )
                .title("닉네임")
                .state($viewModel.inputStates[3], message: "2자 이상 50자 이하로 입력해 주세요.")
                
                TextForm(
                    text: $viewModel.name,
                    placeholder: "본명을 입력해 주세요."
                )
                .title("이름")
                .state($viewModel.inputStates[4], message: "1자 이상, 50자 이하로 입력해 주세요.")
                
                TextForm(
                    text: $viewModel.birthDate,
                    placeholder: "생년월일 8자리 ex: 1900-10-31"
                )
                .title("생년월일")
                .keyboardType(.numberPad)
                .state($viewModel.inputStates[5], message: "생년월일 8자리로 입력해 주세요.")
                
                PickerButton(selected: $viewModel.genderType)
                    .title("성별")
                    .state($viewModel.inputStates[6], message: "성별을 선택해 주세요.")
                
                PickerButton(selected: $viewModel.nationalityType)
                    .title("국적")
                    .state($viewModel.inputStates[7], message: "국적을 선택해 주세요.")
                
                CarrierPicker(carrierType: $viewModel.carrierType)
                    .state($viewModel.inputStates[8], message: "통신사를 선택해 주세요.")
                
                TextForm(
                    text: $viewModel.phoneNumber,
                    placeholder: "전화번호를 입력하세요."
                )
                .title("전화번호")
                .keyboardType(.numberPad)
                .state($viewModel.inputStates[9], message: "전화번호 11자리로 입력해 주세요.")
                
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
                PostCodeSearchWebView(roadAddress: $viewModel.address,
                                      postCode: $viewModel.postCode)
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
        .onAppear {
            viewModel.bindWithRegex()
        }
        .fork { content in
            if #available(iOS 17, *) {
                content
                    .onChange(of: viewModel.phoneNumber) {
                        viewModel.formatPhoneNumber()
                    }
                    .onChange(of: viewModel.birthDate) {
                        viewModel.formatBirthDate()
                    }
            } else {
                content
                    .onChange(of: viewModel.phoneNumber) { _ in
                        viewModel.formatPhoneNumber()
                    }
                    .onChange(of: viewModel.birthDate) { _ in
                        viewModel.formatBirthDate()
                    }
            }
        }
    }
}

struct TitleView: View {
    let title: String
    let isRequired: Bool
    
    var body: some View {
        HStack(spacing: 2) {
            Text(title)
                .foregroundStyle(.gray)
            
            if isRequired {
                Text("*")
                    .foregroundStyle(.accent)
            }
        }
        .bold()
        .font(.subheadline)
    }
}

struct TextForm: View {
    @Binding var text: String
    
    let placeholder: String
    let isSecureText: Bool
    
    init(
        text: Binding<String>,
        placeholder: String,
        isSecureText: Bool = false
    ) {
        self._text = text
        self.placeholder = placeholder
        self.isSecureText = isSecureText
    }
    
    var body: some View {
        Group {
            if isSecureText {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(.plain)
                    .textContentType(.oneTimeCode)
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(.plain)
            }
        }
        .font(.subheadline)
        .padding()
        .background(.background2)
        .cornerRadius(10)
    }
}

struct PickerButton<T: CaseIterable & Hashable & RawRepresentable>: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selected: T?
    
    var body: some View {
        HStack {
            ForEach(Array(T.allCases), id: \.self) { choice in
                Button {
                    withAnimation {
                        selected = choice
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 60)
                        .foregroundStyle(.background2)
                        .overlay {
                            Text("\(choice.rawValue)")
                                .font(.subheadline)
                                .foregroundStyle(colorScheme == .light ? .black : .white)
                            
                            if selected == choice {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.accent, lineWidth: 2)
                            }
                        }
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
