//
//  SheetContentView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 11/09/26.
//

import SwiftUI

private struct HeaderSection: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .typography(.title)
            Text("Presentation")
                .typography(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}


private struct TitleInputField: View {
    @Binding var text: String
    
    var body: some View {
        Section("Title") {
            TextField("Title", text: $text, prompt: Text("At least 3 characters"))
                .textContentType(.namePrefix)
        }
    }
}

struct SheetContentView: View {
    let title: String
    
    @Binding var titleText: String
    var onSave: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    private var isValid: Bool {
        titleText.trimmingCharacters(in: .whitespaces).count >= 3
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HeaderSection(title: title)
                TitleInputField(text: $titleText)
                Spacer()
            }
            
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel, action: dismiss.callAsFunction)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", action: save)
                        .disabled(!isValid)
                }
            }
        }
    }
    
    private func save() {
        onSave()
        dismiss()
    }
}
