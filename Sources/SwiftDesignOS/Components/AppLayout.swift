//
//  AppLayout.swift
//  Swift DesignOS
//
//  Reusable app layout component with header, navigation, and footer
//
//  SPDX-License-Identifier: MIT
//  Copyright (c) 2025 CasJam Media LLC (Builder Methods)
//

import SwiftUI

public struct AppLayout<Content: View>: View {
    let title: String
    let content: Content
    @State private var currentPhase: Int = 0
    @State private var showingDialog: Bool = false
    
    public init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            header
            phaseNav
            mainContent
            footer
        }
        .background(Color(.systemBackground))
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Swift Design OS")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Menu {
                Button(action: { showingDialog = true }) {
                    Label("About", systemImage: "info.circle")
                }
                Button(action: {}) {
                    Label("Settings", systemImage: "gear")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
    }
    
    private var phaseNav: some View {
        PhaseNav(
            phases: ["Design", "Develop", "Deploy"],
            currentPhase: $currentPhase
        )
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var mainContent: some View {
        ScrollView {
            content
                .padding()
        }
    }
    
    private var footer: some View {
        HStack {
            Text("© 2026 Swift Design OS")
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Text("v1.0.0")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
    }
}
