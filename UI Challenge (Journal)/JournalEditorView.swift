import SwiftUI

struct JournalEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: JournalViewModel
    var entry: JournalEntry?
    @State private var title = ""
    @State private var content = ""
    @State private var showingDiscardAlert = false
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 4) {
                TextField("Title", text: $title)
                    .font(.title.weight(.bold))
                    .padding(.horizontal)
                Text((entry?.date ?? Date()).formatted(
                    Date.FormatStyle()
                        .day(.twoDigits)
                        .month(.twoDigits)
                        .year()
                        .locale(Locale(identifier: "en_GB"))
                ))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $content)
                        .font(.body)

                    if content.isEmpty {
                        Text("Type your Journal...")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .padding(.top, 8)
                            .padding(.leading, 5)
                            .allowsHitTesting(false)
                    }
                }
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        if title.isEmpty && content.isEmpty {
                            dismiss()
                        } else {
                            showingDiscardAlert = true
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.circle)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                        if let entry = entry {
                            viewModel.updateEntry(entry, title: title, content: content)
                        } else {
                            viewModel.addEntry(title: title, content: content)
                        }

                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.title3)
                            .foregroundStyle(.black)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("Primary Purple"))
                    .buttonBorderShape(.circle)
                }
            }
            .onAppear {
                if let entry = entry {
                    title = entry.title
                    content = entry.content
                }
            }
            .alert("Discard Journal?", isPresented: $showingDiscardAlert) {
                Button("Keep Editing", role: .cancel) {
                    // Stay in the editor
                }

                Button("Discard", role: .destructive) {
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to discard your changes?")
            }
        }
    }
}
#Preview {
    JournalEditorView(viewModel: JournalViewModel())
}
