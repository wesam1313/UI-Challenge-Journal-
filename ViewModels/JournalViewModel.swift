import Combine
import Foundation

class JournalViewModel: ObservableObject {
    
    @Published var entries: [JournalEntry] = [] {
        didSet {
            saveEntries()
        }
    }


    func addEntry(title: String, content: String) {
        entries.append(JournalEntry(title: title, content: content))
    }
    func updateEntry(_ entry: JournalEntry, title: String, content: String) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].title = title
            entries[index].content = content
        }
    }

    func toggleBookmark(for entry: JournalEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].isBookmarked.toggle()
           
            }
        }
    func deleteEntry(_ entry: JournalEntry) {
        entries.removeAll { $0.id == entry.id }
    }
    func saveEntries() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: "journalEntries")
        }
    }
    func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: "journalEntries"),
           let savedEntries = try? JSONDecoder().decode([JournalEntry].self, from: data) {
            entries = savedEntries
        }
    }
    init() {
        loadEntries()
    }
    }
