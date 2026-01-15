import SwiftUI

struct ExportView: View {
    @State private var selectedFormat: ExportFormat = .react
    @State private var selectedPlatform: ExportPlatform = .web
    @State private var isExporting = false
    @State private var exportProgress: Double = 0
    @State private var showSuccess = false
    
    enum ExportFormat: String, CaseIterable {
        case react = "React"
        case swift = "Swift/SwiftUI"
        case flutter = "Flutter"
        case vue = "Vue"
        case angular = "Angular"
    }
    
    enum ExportPlatform: String, CaseIterable {
        case web = "Web"
        case ios = "iOS"
        case android = "Android"
        case desktop = "Desktop"
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                exportSummary
                
                formatSelector
                
                platformSelector
                
                exportOptions
                
                exportButton
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Export")
        .sheet(isPresented: $showSuccess) {
            exportSuccessSheet
        }
    }
    
    var exportSummary: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Export Summary")
                .font(.headline)
            
            HStack(spacing: 16) {
                summaryCard("Sections", "12", "rectangle.on.rectangle", .blue)
                summaryCard("Screens", "48", "rectangle.stack", .green)
                summaryCard("Shells", "3", "rectangle.3.group", .orange)
                summaryCard("Components", "67", "square.grid.2x2", .purple)
            }
        }
    }
    
    func summaryCard(_ title: String, _ count: String, _ icon: String, _ color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
            
            Text(count)
                .font(.title)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    var formatSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Export Format")
                .font(.headline)
            
            VStack(spacing: 8) {
                ForEach(ExportFormat.allCases, id: \.self) { format in
                    formatOption(format)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    func formatOption(_ format: ExportFormat) -> some View {
        Button(action: { selectedFormat = format }) {
            HStack {
                Image(systemName: "doc.text")
                    .foregroundColor(selectedFormat == format ? .blue : .secondary)
                    .frame(width: 24)
                
                Text(format.rawValue)
                    .font(.subheadline)
                    .foregroundColor(selectedFormat == format ? .primary : .secondary)
                
                Spacer()
                
                if selectedFormat == format {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(selectedFormat == format ? Color.blue.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    var platformSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Target Platform")
                .font(.headline)
            
            HStack(spacing: 12) {
                ForEach(ExportPlatform.allCases, id: \.self) { platform in
                    platformOption(platform)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    func platformOption(_ platform: ExportPlatform) -> some View {
        Button(action: { selectedPlatform = platform }) {
            VStack(spacing: 8) {
                Image(systemName: platform.icon)
                    .foregroundColor(selectedPlatform == platform ? .blue : .secondary)
                    .font(.title3)
                
                Text(platform.rawValue)
                    .font(.caption)
                    .foregroundColor(selectedPlatform == platform ? .primary : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(selectedPlatform == platform ? Color.blue.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    var exportOptions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Export Options")
                .font(.headline)
            
            VStack(spacing: 12) {
                Toggle("Include design tokens", isOn: .constant(true))
                Toggle("Generate documentation", isOn: .constant(true))
                Toggle("Create component library", isOn: .constant(false))
                Toggle("Export sample data", isOn: .constant(true))
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
    
    var exportButton: some View {
        VStack(spacing: 12) {
            if isExporting {
                VStack(spacing: 12) {
                    ProgressView(value: exportProgress)
                        .progressViewStyle(LinearProgressViewStyle())
                    
                    Text("Exporting... \(Int(exportProgress * 100))%")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else {
                Button(action: startExport) {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                        Text("Export Project")
                            .fontWeight(.semibold)
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    var exportSuccessSheet: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.green)
            }
            
            VStack(spacing: 8) {
                Text("Export Complete!")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Your project has been exported successfully")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 12) {
                Button(action: {}) {
                    Label("Download ZIP", systemImage: "square.and.arrow.down")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                Button(action: { showSuccess = false }) {
                    Text("Close")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(32)
        .frame(width: 350)
    }
    
    func startExport() {
        isExporting = true
        exportProgress = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            exportProgress += 0.02
            
            if exportProgress >= 1.0 {
                exportProgress = 1.0
                timer.invalidate()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isExporting = false
                    showSuccess = true
                }
            }
        }
    }
}

extension ExportView.ExportPlatform {
    var icon: String {
        switch self {
        case .web: return "globe"
        case .ios: return "iphone"
        case .android: return "antenna.radiowaves.left.and.right"
        case .desktop: return "desktopcomputer"
        }
    }
}

#Preview {
    NavigationView {
        ExportView()
    }
}
