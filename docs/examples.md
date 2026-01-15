# Swift DesignOS Examples

This document provides complete examples for using Swift DesignOS.

## Example 1: Simple Planning App

Create a basic planning interface with Swift DesignOS components.

```swift
import SwiftUI
import SwiftDesignOS

struct SimplePlanningApp: App {
    var body: some Scene {
        WindowGroup {
            PlanningView()
        }
    }
}

struct PlanningView: View {
    @State private var productName = ""
    @State private var currentPhase = 0

    let phases = [
        "Product Vision",
        "Roadmap",
        "Data Model",
        "Design System",
        "Sections"
    ]

    var body: some View {
        AppLayout(title: "Product Planning") {
            VStack(spacing: 20) {
                PhaseNav(currentPhase: $currentPhase)

                DesignOSCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Product Name")
                            .font(.headline)

                        TextField("Enter product name", text: $productName)
                            .textFieldStyle(.rounded)
                            .padding()
                    }
                    .padding()
                }

                Button(action: { /* Save */ }) {
                    Text("Continue")
                }
                .buttonStyle(.primary)
                .disabled(productName.isEmpty)
            }
            .padding()
        }
    }
}
```

## Example 2: Section List with Cards

Display a list of sections with cards.

```swift
struct SectionsListView: View {
    let sections = [
        Section(id: "1", name: "User Management", status: .completed),
        Section(id: "2", name: "Dashboard", status: .inProgress),
        Section(id: "3", name: "Settings", status: .notStarted)
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(sections) { section in
                    SectionCard(section: section)
                }
            }
            .padding()
        }
    }
}

struct SectionCard: View {
    let section: Section

    var body: some View {
        DesignOSCard {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(section.name)
                        .font(.headline)

                    Badge(statusText, color: statusColor)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .onTapGesture {
            // Navigate to section
        }
    }

    var statusText: String {
        switch section.status {
        case .completed: return "Completed"
        case .inProgress: return "In Progress"
        case .notStarted: return "Not Started"
        }
    }

    var statusColor: Color {
        switch section.status {
        case .completed: return .green
        case .inProgress: return .blue
        case .notStarted: return .gray
        }
    }
}
```

## Example 3: Form with Validation

Create a form with text fields and validation.

```swift
struct FormView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false

    var isValid: Bool {
        !name.isEmpty && !email.isEmpty && !password.isEmpty && email.contains("@")
    }

    var body: some View {
        AppLayout(title: "Create Account") {
            ScrollView {
                VStack(spacing: 16) {
                    DesignOSCard {
                        VStack(spacing: 16) {
                            TextField("Full Name", text: $name)
                                .textFieldStyle(.rounded)
                                .textContentType(.name)
                                .autocapitalization(.words)

                            TextField("Email", text: $email)
                                .textFieldStyle(.rounded)
                                .keyboardType(.emailAddress)
                                .textContentType(.emailAddress)
                                .autocapitalization(.never)

                            SecureField("Password", text: $password)
                                .textFieldStyle(.rounded)
                                .textContentType(.password)
                        }
                        .padding()
                    }

                    if showError {
                        Text("Please fill in all fields correctly")
                            .foregroundColor(.red)
                            .font(.callout)
                    }

                    Button(action: handleSubmit) {
                        Text("Create Account")
                    }
                    .buttonStyle(.primary)
                    .disabled(!isValid)
                }
                .padding()
            }
        }
    }

    func handleSubmit() {
        if isValid {
            // Submit form
        } else {
            showError = true
        }
    }
}
```

## Example 4: Loading Product Data

Load and display product information from markdown files.

```swift
struct ProductOverviewView: View {
    @State private var product: ProductOverview?
    @State private var isLoading = true
    @State private var error: Error?

    var body: some View {
        AppLayout(title: "Product Overview") {
            Group {
                if isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let product {
                    ProductContentView(product: product)
                } else if let error {
                    ErrorView(error: error)
                }
            }
        }
        .task {
            await loadProduct()
        }
    }

    func loadProduct() async {
        do {
            product = try ProductLoader.load(from: "product/product-overview.md")
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
}

struct ProductContentView: View {
    let product: ProductOverview

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.name)
                        .font(.largeTitle)
                    Badge("Product", color: .purple)
                }

                DesignOSCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Description")
                            .font(.headline)
                        Text(product.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }

                DesignOSCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Problems We Solve")
                            .font(.headline)

                        ForEach(product.problems, id: \.self) { problem in
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(problem)
                                    .font(.body)
                            }
                        }
                    }
                    .padding()
                }
            }
            .padding()
        }
    }
}
```

## Example 5: Confirm Dialog

Use dialog for confirming destructive actions.

```swift
struct DeleteItemView: View {
    @State private var showDialog = false
    @State private var items = ["Item 1", "Item 2", "Item 3"]

    var body: some View {
        AppLayout(title: "Items") {
            VStack(spacing: 16) {
                ForEach(items, id: \.self) { item in
                    ItemRow(item: item, onDelete: { showDeleteDialog(for: item) })
                }
                .padding(.horizontal)
            }
            .sheet(isPresented: $showDialog) {
                if let itemToDelete {
                    DeleteConfirmDialog(
                        item: itemToDelete,
                        isPresented: $showDialog,
                        onDelete: { deleteItem(itemToDelete!) }
                    )
                }
            }
        }
    }

    @State private var itemToDelete: String?

    func showDeleteDialog(for item: String) {
        itemToDelete = item
        showDialog = true
    }

    func deleteItem(_ item: String) {
        items.removeAll { $0 == item }
    }
}

struct DeleteConfirmDialog: View {
    let item: String
    @Binding var isPresented: Bool
    let onDelete: () -> Void

    var body: some View {
        Dialog(
            title: "Delete Item",
            message: "Are you sure you want to delete \"\(item)\"? This action cannot be undone.",
            primaryAction: DialogAction(
                title: "Delete",
                style: .destructive
            ) {
                onDelete()
                isPresented = false
            },
            secondaryAction: DialogAction(
                title: "Cancel",
                style: .secondary
            ) {
                isPresented = false
            }
        )
    }
}
```

## Example 6: Multi-Platform Layout

Adaptive layout for iOS and macOS.

```swift
struct PlatformAdaptiveView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        if horizontalSizeClass == .compact {
            // iPhone layout - vertical
            compactLayout
        } else {
            // iPad/Mac layout - horizontal
            regularLayout
        }
    }

    var compactLayout: some View {
        VStack(spacing: 16) {
            HeaderView()
            ContentList()
            FooterView()
        }
    }

    var regularLayout: some View {
        HStack(spacing: 16) {
            SidebarView()
                .frame(width: 250)

            ContentView()

            DetailView()
        }
    }
}

struct HeaderView: View {
    var body: some View {
        HStack {
            Text("Swift DesignOS")
                .font(.title)
            Spacer()
            Button("Settings") {}
                .buttonStyle(.ghost)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
    }
}
```

## Example 7: Dark Mode Support

All Swift DesignOS components automatically support dark mode.

```swift
struct ThemeView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 20) {
            DesignOSCard {
                Text("Automatic Dark Mode")
                    .font(.headline)
                Text("This card adapts to your system theme")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()

            Text("Current theme: \(colorScheme == .dark ? "Dark" : "Light")")
                .font(.callout)
        }
        .padding()
        .background(colorScheme == .dark ? .black : .gray.opacity(0.1))
    }
}
```

## Example 8: Navigation with Tabs

Tab-based navigation for iOS.

```swift
struct TabNavigationView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ProductView()
                .tabItem {
                    Label("Product", systemImage: "doc.text")
                }
                .tag(0)

            SectionsView()
                .tabItem {
                    Label("Sections", systemImage: "list.bullet")
                }
                .tag(1)

            DesignSystemView()
                .tabItem {
                    Label("Design", systemImage: "paintbrush")
                }
                .tag(2)

            ExportView()
                .tabItem {
                    Label("Export", systemImage: "square.and.arrow.up")
                }
                .tag(3)
        }
    }
}
```

## Example 9: Loading and Error States

Handle loading and error states gracefully.

```swift
struct DataView: View {
    @State private var state: ViewState = .loading

    var body: some View {
        AppLayout(title: "Data") {
            switch state {
            case .loading:
                LoadingView()

            case .success(let data):
                SuccessView(data: data)

            case .error(let message):
                ErrorView(message: message, onRetry: { loadData() })
            }
        }
    }

    func loadData() {
        state = .loading

        Task {
            do {
                let data = try await fetchData()
                state = .success(data)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
}

enum ViewState {
    case loading
    case success([String])
    case error(String)
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading...")
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.orange)

            Text("Something went wrong")
                .font(.headline)

            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button(action: onRetry) {
                Text("Try Again")
            }
            .buttonStyle(.primary)
        }
        .padding()
    }
}
```

## Example 10: Animated Transitions

Add smooth transitions to your views.

```swift
struct AnimatedListView: View {
    @State private var items = ["Item 1", "Item 2"]
    @State private var showDetail = false

    var body: some View {
        AppLayout(title: "Animated List") {
            VStack(spacing: 16) {
                ForEach(items, id: \.self) { item in
                    ItemRow(item: item)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                }
                .padding(.horizontal)

                Button(action: addItem) {
                    Text("Add Item")
                }
                .buttonStyle(.primary)
            }
            .animation(.easeInOut, value: items.count)
        }
        .sheet(isPresented: $showDetail) {
            DetailView()
        }
    }

    func addItem() {
        items.append("Item \(items.count + 1)")
    }
}

struct ItemRow: View {
    let item: String

    var body: some View {
        HStack {
            Text(item)
                .font(.body)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
    }
}
```

## Next Steps

- See [Components Documentation](./components.md) for component reference
- See [Setup Guide](./setup.md) for installation instructions
- Check [README.md](../README.md) for full project documentation