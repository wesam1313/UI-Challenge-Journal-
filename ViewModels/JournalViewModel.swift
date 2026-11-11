import Combine

class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []

    func addEntry(title: String, content: String) {
        entries.append(JournalEntry(title: title, content: content))
    }
}
