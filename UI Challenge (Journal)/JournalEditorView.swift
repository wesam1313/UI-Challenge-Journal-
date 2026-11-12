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
            VStack {
                TextField("Title", text: $title)
                    .font(.title2)
                    .padding()
                TextField("Type your Journal", text: $content)
                    .font(.title2)
                    .padding()
                TextEditor(text: $content)
                    .font(.body)
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
