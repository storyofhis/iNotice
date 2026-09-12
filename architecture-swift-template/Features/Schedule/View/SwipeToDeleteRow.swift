//
//  SwipeToDeleteRow.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 12/09/26.
//

import SwiftUI

struct SwipeToDeleteRow<Content: View>: View {
    let onDelete: () -> Void
    @ViewBuilder let content: () -> Content
    
    @State private var offset: CGFloat = 0
    @State private var isSwiped = false
    
    private let deleteButtonWidth: CGFloat = 80
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Button(role: .destructive, action: onDelete) {
                Image(systemName: "trash")
                    .foregroundStyle(.white)
                    .frame(width: deleteButtonWidth)
                    .frame(maxHeight: .infinity)
            }
            .background(Color.red)
            .clipShape(.rect(cornerRadius: 12))
            
            content()
                .background(Color.opalSurface)   // biar row nutupin tombol delete sebelum digeser
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // cuma izinin geser ke KIRI (translation negatif)
                            guard value.translation.width < 0 else { return }
                            offset = max(value.translation.width, -deleteButtonWidth)
                        }
                        .onEnded { value in
                            withAnimation(.snappy) {
                                if value.translation.width < -deleteButtonWidth / 2 {
                                    offset = -deleteButtonWidth
                                    isSwiped = true
                                } else {
                                    offset = 0
                                    isSwiped = false
                                }
                            }
                        }
                )
        }
        .clipShape(.rect(cornerRadius: 12))
    }
}
