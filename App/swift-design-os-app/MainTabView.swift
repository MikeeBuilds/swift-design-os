import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .product
    
    enum Tab: Int, CaseIterable {
        case product = 0
        case data = 1
        case design = 2
        case sections = 3
        case shells = 4
        case export = 5
        
        var title: String {
            switch self {
            case .product: return "Product"
            case .data: return "Data Model"
            case .design: return "Design"
            case .sections: return "Sections"
            case .shells: return "Shells"
            case .export: return "Export"
            }
        }
        
        var icon: String {
            switch self {
            case .product: return "doc.text"
            case .data: return "database"
            case .design: return "paintpalette"
            case .sections: return "list.bullet"
            case .shells: return "rectangle.3.group"
            case .export: return "square.and.arrow.up"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                ProductView()
            }
            .tabItem {
                Label(Tab.product.title, systemImage: Tab.product.icon)
            }
            .tag(Tab.product)
            
            NavigationView {
                DataModelView()
            }
            .tabItem {
                Label(Tab.data.title, systemImage: Tab.data.icon)
            }
            .tag(Tab.data)
            
            NavigationView {
                DesignSystemView()
            }
            .tabItem {
                Label(Tab.design.title, systemImage: Tab.design.icon)
            }
            .tag(Tab.design)
            
            NavigationView {
                SectionsView()
            }
            .tabItem {
                Label(Tab.sections.title, systemImage: Tab.sections.icon)
            }
            .tag(Tab.sections)
            
            NavigationView {
                ShellDesignView()
            }
            .tabItem {
                Label(Tab.shells.title, systemImage: Tab.shells.icon)
            }
            .tag(Tab.shells)
            
            NavigationView {
                ExportView()
            }
            .tabItem {
                Label(Tab.export.title, systemImage: Tab.export.icon)
            }
            .tag(Tab.export)
        }
    }
}

#Preview {
    MainTabView()
}
