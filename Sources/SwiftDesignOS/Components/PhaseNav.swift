import SwiftUI

public struct PhaseNav: View {
    let phases: [String]
    @Binding var currentPhase: Int
    
    public init(phases: [String], currentPhase: Binding<Int>) {
        self.phases = phases
        self._currentPhase = currentPhase
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(phases.enumerated()), id: \.offset) { index, phase in
                phaseIndicator(for: index, name: phase)
                
                if index < phases.count - 1 {
                    connector
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    private func phaseIndicator(for index: Int, name: String) -> some View {
        Button(action: { currentPhase = index }) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(index <= currentPhase ? Color.accentColor : Color.gray.opacity(0.3))
                        .frame(width: 32, height: 32)
                    
                    if index < currentPhase {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                    } else {
                        Text("\(index + 1)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(index <= currentPhase ? .white : .secondary)
                    }
                }
                
                Text(name)
                    .font(.caption)
                    .fontWeight(index == currentPhase ? .semibold : .regular)
                    .foregroundStyle(index <= currentPhase ? .primary : .secondary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var connector: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(height: 2)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 8)
    }
}
