import Combine

class JournalViewModel: ObservableObject {
    
    @Published var entries: [JournalEntry] = [
        JournalEntry(
            title: "wesam",
            content: "wesam wesam wesam wesam wesamwesam wesam wesam wesam wesam",
            isBookmarked: true
        ),
        JournalEntry(
            title: "wesam",
            content: "wesam wesam wesam wesam wesam wesam wesam wesam wesam wesam"
        ),
        JournalEntry(
            title: "wesam",
            content: "wesam wesam wesam wesam wesamwesam wesam wesam wesam wesamwesam wesam wesam wesam wesam"
        )
    ]


    func addEntry(title: String, content: String) {
        entries.append(JournalEntry(title: title, content: content))
    }

    func toggleBookmark(for entry: JournalEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].isBookmarked.toggle()
           
            }
        }
    func deleteEntry(_ entry: JournalEntry) {
        entries.removeAll { $0.id == entry.id }
    }

    }
