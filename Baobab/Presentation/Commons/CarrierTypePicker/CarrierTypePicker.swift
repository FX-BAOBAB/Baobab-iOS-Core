//
//  CarrierTypePicker.swift
//  Baobab
//
//  Created by 이정훈 on 6/3/25.
//

import SwiftUI

struct CarrierPicker: View {
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

struct CarrierPickerSheet: View {
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

#Preview {
    CarrierPickerSheet(carrierType: .constant(.none))
}
