//
//  TradeArticleForm.swift
//  Baobab
//
//  Created by 이정훈 on 3/24/25.
//

import SwiftUI

struct TradeArticleForm: View {
    @StateObject private var viewModel: TradeArticleFormViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: TradeArticleFormViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                MultiImagePickerView(selectedImageDataList: $viewModel.selectedImageDataList)
            }
            .navigationTitle("중고물품 등록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.black)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("완료") {
                        
                    }
                }
            }
        }
    }
}

fileprivate struct MultiImagePickerView: View {
    @Binding var selectedImageDataList: [Data]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if selectedImageDataList.count < 6 {
                    AddImageButton(selectedImageDataList: $selectedImageDataList)
                        .padding([.leading, .top, .bottom])
                }
                
                ForEach(selectedImageDataList.indices, id: \.self) { idx in
                    SelectedImage($selectedImageDataList, at: idx)
                        .padding(.leading, idx == 0 && selectedImageDataList.count > 5 ? 16: 0)
                        .padding(.trailing, idx == selectedImageDataList.count - 1 ? 16 : 0)
                        .padding([.top, .bottom])
                }
            }
        }
        .padding([.top, .bottom])
    }
}

fileprivate struct AddImageButton: View {
    @State private var isShowingDialog: Bool = false
    @State private var isShowingCamera: Bool = false
    @State private var isShowingPhotoLibrary: Bool = false
    @Binding private var selectedImageDataList: [Data]
    
    init(selectedImageDataList: Binding<[Data]>) {
        _selectedImageDataList = selectedImageDataList
    }
    
    var body: some View {
        Button {
            isShowingDialog.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.gray2)
                    .frame(width: 80, height: 80)
                
                VStack {
                    Image(systemName: "camera.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                    
                    Text("\(selectedImageDataList.count) / 6")
                        .font(.caption)
                }
                .foregroundStyle(.black)
            }
        }
        .confirmationDialog("", isPresented: $isShowingDialog) {
            Button("카메라") {
                isShowingCamera.toggle()
            }
            
            Button("라이브러리") {
                isShowingPhotoLibrary.toggle()
            }
        }
        .fullScreenCover(isPresented: $isShowingCamera) {
            ImagePicker($selectedImageDataList)
        }
        .fullScreenCover(isPresented: $isShowingPhotoLibrary) {
            PHPicker(selectedImageDataList: $selectedImageDataList)
        }
    }
}

fileprivate struct SelectedImage: View {
    @Binding private var selectedImageDataList: [Data]
    private let pos: Int
    
    init(_ selectedImageDataList: Binding<[Data]>, at pos: Int) {
        _selectedImageDataList = selectedImageDataList
        self.pos = pos
    }
    
    var body: some View {
        ZStack {
            Image(uiImage: UIImage(data: selectedImageDataList[pos]))
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(10)
            
            Button {
                selectedImageDataList.remove(at: pos)
            } label: {
                Circle()
                    .foregroundStyle(.gray)
                    .frame(width: 20, height: 20)
                    .overlay {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 8, height: 8)
                            .foregroundStyle(.black)

                    }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .frame(maxHeight: .infinity, alignment: .top)
            .offset(x: 5, y: -5)
        }
    }
}

#Preview {
    TradeArticleForm(viewModel: TradeArticleFormViewModel())
}
