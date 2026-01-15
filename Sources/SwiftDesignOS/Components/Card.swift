import SwiftUI

public struct Card<Content: View, Header: View, Footer: View>: View {
    let header: Header?
    let footer: Footer?
    let content: Content
    
    public init(
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) where Header: View, Footer: View {
        self.header = header()
        self.content = content()
        self.footer = footer()
    }
    
    public init(
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) where Header: View, Footer == EmptyView {
        self.header = header()
        self.content = content()
        self.footer = nil
    }
    
    public init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) where Header == EmptyView, Footer: View {
        self.header = nil
        self.content = content()
        self.footer = footer()
    }
    
    public init(@ViewBuilder content: () -> Content) where Header == EmptyView, Footer == EmptyView {
        self.header = nil
        self.content = content()
        self.footer = nil
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let header = header {
                headerSection(header)
                    .padding(.bottom, 16)
            }
            
            contentSection
            
            if let footer = footer {
                footerSection(footer)
                    .padding(.top, 16)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    @ViewBuilder
    private func headerSection(_ header: Header) -> some View {
        header
            .font(.headline)
            .foregroundStyle(.primary)
    }
    
    private var contentSection: some View {
        content
            .foregroundStyle(.secondary)
    }
    
    @ViewBuilder
    private func footerSection(_ footer: Footer) -> some View {
        footer
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}

public extension Card where Header == EmptyView, Footer == EmptyView {
    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.init {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
        } content: {
            content()
        }
    }
}
