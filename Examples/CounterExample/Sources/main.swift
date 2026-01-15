import SwiftUI
import SwiftDesignOS

@main
struct CounterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
    }
}

struct ContentView: View {
    @State private var counterValue: Int = 0
    @State private var stepSize: Int = 1
    @State private var showResetAlert = false
    @State private var history: [Int] = []
    @State private var useDarkMode = false
    @State private var accentColor: Color = .blue
    
    var body: some View {
        HSplitView {
            sidebar
            
            mainContent
        }
        .frame(minWidth: 800, minHeight: 500)
        .preferredColorScheme(useDarkMode ? .dark : .light)
        .accentColor(accentColor)
    }
    
    private var sidebar: some View {
        VStack(alignment: .leading, spacing: 20) {
            Card {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Stats")
                        .font(.headline)
                    
                    HStack {
                        Text("Current")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(counterValue)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.accentColor)
                    }
                    
                    HStack {
                        Text("History Size")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(history.count)")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Text("Highest")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(history.max() ?? counterValue)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.green)
                    }
                }
            }
            
            Card {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Appearance")
                        .font(.headline)
                    
                    Toggle("Dark Mode", isOn: $useDarkMode)
                        .tint(accentColor)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Accent Color")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                            ForEach([Color.blue, .green, .orange, .purple, .red, .pink], id: \.self) { color in
                                ColorOption(
                                    color: color,
                                    isSelected: accentColor == color
                                ) {
                                    accentColor = color
                                }
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            Card {
                VStack(alignment: .leading, spacing: 8) {
                    Text("About")
                        .font(.headline)
                    
                    Text("Counter Example")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("Demonstrates Swift DesignOS on macOS")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("v1.0.0")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .frame(minWidth: 250)
        .background(Color(.controlBackgroundColor))
    }
    
    private var mainContent: some View {
        VStack(spacing: 32) {
            counterDisplay
            
            stepSizeSelector
            
            actionButtons
            
            resetButton
            
            historySection
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var counterDisplay: some View {
        Card {
            VStack(spacing: 16) {
                Text("Counter")
                    .font(.title)
                    .foregroundStyle(.secondary)
                
                Text("\(counterValue)")
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundStyle(.accentColor)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: counterValue)
                
                if history.count > 0 {
                    HStack(spacing: 8) {
                        if let lastChange = history.last {
                            if lastChange > counterValue {
                                Label("\(lastChange - counterValue)", systemImage: "arrow.down")
                                    .foregroundStyle(.green)
                            } else if lastChange < counterValue {
                                Label("\(counterValue - lastChange)", systemImage: "arrow.up")
                                    .foregroundStyle(.blue)
                            } else {
                                Text("0")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .font(.caption)
                    .padding(8)
                    .background(Color(.controlBackgroundColor))
                    .clipShape(Capsule())
                }
            }
            .padding(32)
        }
    }
    
    private var stepSizeSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Step Size")
                .font(.headline)
            
            HStack(spacing: 12) {
                ForEach([1, 5, 10], id: \.self) { step in
                    StepOption(
                        value: step,
                        isSelected: stepSize == step
                    ) {
                        stepSize = step
                    }
                }
            }
            
            HStack(spacing: 12) {
                SDTextField(
                    "Custom",
                    text: Binding(
                        get: { "\(stepSize)" },
                        set: { stepSize = Int($0) ?? 1 }
                    ),
                    placeholder: "Enter value"
                )
                .frame(width: 120)
                
                Text("Click buttons to increment/decrement by this amount")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var actionButtons: some View {
        HStack(spacing: 16) {
            SDButton(
                "− Decrease",
                variant: .secondary,
                size: .large
            ) {
                addToCounter(-stepSize)
            }
            .keyboardShortcut(.downArrow, modifiers: [])
            
            SDButton(
                "+ Increase",
                variant: .primary,
                size: .large
            ) {
                addToCounter(stepSize)
            }
            .keyboardShortcut(.upArrow, modifiers: [])
        }
    }
    
    private var resetButton: some View {
        SDButton(
            "Reset Counter",
            variant: .destructive,
            size: .medium
        ) {
            showResetAlert = true
        }
        .alert("Reset Counter", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetCounter()
            }
        } message: {
            Text("Are you sure you want to reset the counter to 0?")
        }
    }
    
    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("History")
                    .font(.headline)
                
                Spacer()
                
                SDButton(
                    "Clear",
                    variant: .ghost,
                    size: .small
                ) {
                    history.removeAll()
                }
                .disabled(history.isEmpty)
            }
            
            if history.isEmpty {
                Text("No history yet")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(Array(history.enumerated().reversed()), id: \.offset) { index, value in
                            HistoryRow(index: history.count - index, value: value)
                        }
                    }
                }
                .frame(height: 200)
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func addToCounter(_ amount: Int) {
        history.append(counterValue)
        counterValue += amount
    }
    
    private func resetCounter() {
        history.append(counterValue)
        counterValue = 0
    }
}

struct StepOption: View {
    let value: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(value)")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(width: 60, height: 60)
                .background(isSelected ? Color.accentColor : Color(.controlBackgroundColor))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.accentColor, lineWidth: isSelected ? 2 : 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { _ in }
    }
}

struct ColorOption: View {
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 6)
                .fill(color)
                .frame(width: 40, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(.primary, lineWidth: isSelected ? 3 : 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HistoryRow: View {
    let index: Int
    let value: Int
    
    var body: some View {
        HStack {
            Badge("#\(index)", variant: .outline)
            
            Text("Value: \(value)")
                .font(.body)
                .fontWeight(.medium)
            
            Spacer()
            
            Text("Previous")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.windowBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
