import SwiftUI

struct ProductView: View {
    @State private var productName: String = "My Product"
    @State private var productDescription: String = ""
    @State private var showAddRoadmap = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                phaseIndicator
                
                productInfoCard
                
                roadmapCard
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Product")
        .sheet(isPresented: $showAddRoadmap) {
            AddRoadmapItemView { title, phase in
                showAddRoadmap = false
            }
        }
    }
    
    var phaseIndicator: some View {
        HStack(spacing: 8) {
            ForEach(1...4, id: \.self) { index in
                Circle()
                    .fill(index <= 2 ? Color.blue : Color.gray.opacity(0.3))
                    .frame(width: 12, height: 12)
                if index < 4 {
                    Rectangle()
                        .fill(index < 2 ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 40, height: 2)
                }
            }
        }
        .padding(.horizontal)
    }
    
    var productInfoCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Product Overview")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Product Name")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("Enter product name", text: $productName)
                    .textFieldStyle(.roundedBorder)
                
                Text("Description")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextEditor(text: $productDescription)
                    .frame(height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    var roadmapCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Product Roadmap")
                    .font(.headline)
                Spacer()
                Button(action: { showAddRoadmap = true }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            
            VStack(spacing: 12) {
                roadmapItem("MVP Launch", phase: 1, status: .completed)
                roadmapItem("Beta Testing", phase: 2, status: .inProgress)
                roadmapItem("Feature Expansion", phase: 3, status: .planned)
                roadmapItem("Scale & Optimize", phase: 4, status: .planned)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    func roadmapItem(_ title: String, phase: Int, status: RoadmapStatus) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("Phase \(phase)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            HStack(spacing: 6) {
                Circle()
                    .fill(status.color)
                    .frame(width: 8, height: 8)
                Text(status.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(status.backgroundColor)
        .cornerRadius(8)
    }
}

enum RoadmapStatus: String {
    case completed = "Completed"
    case inProgress = "In Progress"
    case planned = "Planned"
    
    var color: Color {
        switch self {
        case .completed: return .green
        case .inProgress: return .blue
        case .planned: return .gray
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .completed: return Color.green.opacity(0.1)
        case .inProgress: return Color.blue.opacity(0.1)
        case .planned: return Color.gray.opacity(0.1)
        }
    }
}

struct AddRoadmapItemView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var phase: Int = 1
    let onSave: (String, Int) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Item Title", text: $title)
                Picker("Phase", selection: $phase) {
                    ForEach(1...4, id: \.self) { phase in
                        Text("Phase \(phase)").tag(phase)
                    }
                }
            }
            .navigationTitle("Add Roadmap Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onSave(title, phase)
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ProductView()
    }
}
