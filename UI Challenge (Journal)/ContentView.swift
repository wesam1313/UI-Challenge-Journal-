
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = JournalViewModel()
    @State private var searchText = ""
    @State private var showingEditor = false
    @State private var entryToDelete: JournalEntry?
    @State private var sortByBookmark = false
    @State private var entryToEdit: JournalEntry?
    private var filteredEntries: [JournalEntry] {
        let filtered = viewModel.entries.filter {
            searchText.isEmpty ||
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.content.localizedCaseInsensitiveContains(searchText)
        }

        if sortByBookmark {
            return filtered.sorted {
                if $0.isBookmarked == $1.isBookmarked {
                    return $0.date > $1.date
                }
                return $0.isBookmarked && !$1.isBookmarked
            }
        } else {
            return filtered.sorted { $0.date > $1.date }
        }
    }
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.entries.isEmpty {
                    VStack(spacing: 20) {
                        Image("Open Journal")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 151.39, height: 97.32)
                        
                        Text("Begin Your Journal")
                            .font(.title2.bold())
                            .foregroundColor(Color("Text Accent"))
                        
                        Text("Craft your personal diary, tap the plus icon to begin")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("Text Primary"))
                    }
                    .padding()
                } else {
                    
                    List {
                        ForEach(filteredEntries) { entry in
                            Section {
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack {
                                        Text(entry.title)
                                            .font(.title2.weight(.semibold))
                                            .foregroundColor(Color("Text Purple"))

                                        Spacer()

                                        Button {
                                            viewModel.toggleBookmark(for: entry)                                        } label: {
                                            Image(systemName: entry.isBookmarked ? "bookmark.fill" : "bookmark")
                                                .foregroundStyle(Color("Text Purple"))
                                        }
                                        .buttonStyle(.plain)
                                    }

                                  
                                    Text(entry.date.formatted(
                                        Date.FormatStyle()
                                            .day(.twoDigits)
                                            .month(.twoDigits)
                                            .year()
                                            .locale(Locale(identifier: "en_GB"))
                                    ))

                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .padding(.top, 0)

                                    Text(entry.content)
                                        .padding(.top, 10)
                                }
                                .listRowSeparator(.hidden)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    entryToEdit = entry
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        entryToDelete = entry
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .listSectionSpacing(16)
                    .scrollContentBackground(.hidden)
            

                    
                    
                }
            }
            .navigationTitle("Journal")
            .toolbar {
                Menu {
                    Button("Sort by Bookmark") {
                        sortByBookmark = true
                    }

                    Button("Sort by Entry Date") {
                        sortByBookmark = false
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                }

                Button(action: {
                    showingEditor = true
                }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingEditor) {
                JournalEditorView(viewModel: viewModel)
            }
            .sheet(item: $entryToEdit) { entry in
                JournalEditorView(viewModel: viewModel, entry: entry)
            }
            }
            .alert("Delete Journal?", isPresented: Binding(
                get: { entryToDelete != nil },
                set: { if !$0 { entryToDelete = nil } }
            )) {
                Button("Cancel", role: .cancel) {
                    entryToDelete = nil
                }

                Button("Delete", role: .destructive) {
                    if let entry = entryToDelete {
                        viewModel.deleteEntry(entry)
                        entryToDelete = nil
                    }
                }
            } message: {
                Text("Are you sure you want to delete this journal?")
            }
            .searchable(text:  $searchText, placement: .toolbar, prompt: "Search")
            .preferredColorScheme(.dark)
        }
    }


#Preview {
    ContentView()
}
