
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = JournalViewModel()
    @State private var searchText = ""
    @State private var showingEditor = false
    private var filteredEntries: [JournalEntry] {
        if searchText.isEmpty {
            return viewModel.entries
        }

        return viewModel.entries.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
                || $0.content.localizedCaseInsensitiveContains(searchText)
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
                
                Button(action: {}) {
                    Image(systemName: "line.3.horizontal.decrease")
                }
                
                Button(action: {showingEditor = true}) {
                    Image(systemName: "plus")
                }
                
            }
            .sheet(isPresented: $showingEditor) {
                JournalEditorView()
            }
            .searchable(text:  $searchText, placement: .toolbar, prompt: "Search")
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ContentView()
}
