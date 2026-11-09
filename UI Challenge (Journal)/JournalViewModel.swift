import Combine

class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
}
