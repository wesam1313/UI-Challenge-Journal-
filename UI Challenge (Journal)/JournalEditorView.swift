import SwiftUI

struct JournalEditorView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("New Journal")
            }
            .navigationTitle("New Journal")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#Preview {
    JournalEditorView()
}
