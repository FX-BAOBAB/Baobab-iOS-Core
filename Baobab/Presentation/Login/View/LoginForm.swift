//
//  LoginView.swift
//  Baobab
//
//  Created by 이정훈 on 1/30/25.
//

import SwiftUI
import Factory
import Foundation

struct LoginForm: View {
    @StateObject private var viewModel: LoginFormViewModel
    @State private var isKeyboardActive: Bool = false
    @State private var isShowingSignupForm: Bool = false
    
    init(viewModel: LoginFormViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        LogoView()
                            .padding(.bottom, 20)
                        
                        BorderedTextField(input: $viewModel.email,
                                          placeholder: "이메일을 입력하세요.",
                                          isSecureText: false)
                        
                        BorderedTextField(input: $viewModel.password,
                                          placeholder: "비밀번호를 입력하세요.",
                                          isSecureText: true)
                        
                        AutoLoginBtn(isAutoLogin: $viewModel.isAutoLogin)
                        
                        Button {
                            viewModel.login()
                        } label: {
                            Text("로그인")
                                .bold()
                                .foregroundStyle(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.accent)
                        }
                        .cornerRadius(30)
                        .padding(.top)
                        
                        SectionSeparator()
                            .padding(.top)
                        
                        Button {
                            isShowingSignupForm.toggle()
                        } label: {
                            Text("회원가입")
                                .bold()
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding([.leading, .trailing, .bottom])
                    .padding(.top, UIScreen.main.bounds.width * 0.2)
                }
                .scrollDisabled(!isKeyboardActive)
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                    isKeyboardActive = true
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                    isKeyboardActive = false
                }
                .toolbar(.hidden)
                .fullScreenCover(isPresented: $isShowingSignupForm) {
                    NavigationStack {
                        SignupForm(viewModel: SignupFormViewModel())
                    }
                }
                .onDisappear {
                    viewModel.loginTask?.cancel()
                }
                .navigationDestination(isPresented: $viewModel.isLoginComplete) {
                    TabBarView()
                        .navigationBarBackButtonHidden()
                        .edgesIgnoringSafeArea(.bottom)
                }
                .alert(viewModel.alertMessage, isPresented: $viewModel.isShowingAlert) {
                    Button("확인") {}
                }
                
                if viewModel.isLoading {
                    SpinningIndicator()
                }
            }
        }
    }
}

fileprivate struct LogoView: View {
    var body: some View {
        Image("Baobab_Logo")
            .resizable()
            .frame(width: UIScreen.main.bounds.width * 0.25,
                   height: UIScreen.main.bounds.width * 0.25)
    }
}

fileprivate struct BorderedTextField: View {
    @Binding var input: String
    let placeholder: String
    let isSecureText: Bool
    
    var body: some View {
        Group {
            if isSecureText {
                SecureField(text: $input) {
                    Text(placeholder)
                }
            } else {
                TextField(text: $input) {
                    Text(placeholder)
                }
            }
        }
        .font(.subheadline)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, lineWidth: 0.5)
        )
    }
}

fileprivate struct AutoLoginBtn: View {
    @Binding var isAutoLogin: Bool
    
    var body: some View {
        HStack {
            Button {
                withAnimation(.easeInOut) {
                    isAutoLogin.toggle()
                }
            } label: {
                if isAutoLogin {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.accent)
                } else {
                    Circle()
                        .stroke(lineWidth: 0.5)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black)
                }
            }
            
            Text("자동 로그인")
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

fileprivate struct SectionSeparator: View {
    var body: some View {
        HStack {
            Rectangle()
                .frame(height: 0.5)
                .layoutPriority(1)
            
            Text("또는")
                .font(.footnote)
                .lineLimit(1)
                .layoutPriority(2)
            
            Rectangle()
                .frame(height: 0.5)
                .layoutPriority(1)
        }
        .foregroundStyle(.gray)
    }
}

#Preview {
    NavigationStack {
        LoginForm(viewModel: LoginFormViewModel())
    }
}
