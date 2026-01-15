import SwiftUI

public struct Dialog<Content: View>: View {
    let title: String
    let description: String?
    let content: Content
    @Binding var isPresented: Bool
    let primaryAction: (() -> Void)?
    let secondaryAction: (() -> Void)?
    let primaryButtonTitle: String
    let secondaryButtonTitle: String?
    
    public init(
        title: String,
        description: String? = nil,
        @ViewBuilder content: () -> Content,
        isPresented: Binding<Bool>,
        primaryAction: (() -> Void)? = nil,
        secondaryAction: (() -> Void)? = nil,
        primaryButtonTitle: String = "Confirm",
        secondaryButtonTitle: String? = "Cancel"
    ) {
        self.title = title
        self.description = description
        self.content = content()
        self._isPresented = isPresented
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
    }
    
    public var body: some View {
        ZStack {
            if isPresented {
                background
                    .transition(.opacity)
                
                dialogContent
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
    }
    
    private var background: some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
            .onTapGesture {
                isPresented = false
            }
    }
    
    private var dialogContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            header
            content
            actions
        }
        .padding(24)
        .frame(maxWidth: 500)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            
            if let description = description {
                Text(description)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var actions: some View {
        HStack(spacing: 12) {
            if let secondaryButtonTitle = secondaryButtonTitle {
                SDButton(
                    secondaryButtonTitle,
                    variant: .outline,
                    action: {
                        secondaryAction?()
                        isPresented = false
                    }
                )
            }
            
            SDButton(
                primaryButtonTitle,
                variant: .primary,
                action: {
                    primaryAction?()
                    isPresented = false
                }
            )
        }
    }
}

public extension Dialog where Content == EmptyView {
    init(
        title: String,
        description: String? = nil,
        isPresented: Binding<Bool>,
        primaryAction: (() -> Void)? = nil,
        secondaryAction: (() -> Void)? = nil,
        primaryButtonTitle: String = "Confirm",
        secondaryButtonTitle: String? = "Cancel"
    ) {
        self.title = title
        self.description = description
        self.content = EmptyView()
        self._isPresented = isPresented
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
    }
}
