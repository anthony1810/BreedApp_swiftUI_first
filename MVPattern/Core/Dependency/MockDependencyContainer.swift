//
//  MockDependencyContainer.swift
//  MVPattern
//
//  Created by Anthony Tran on 20/5/24.
//

import Foundation
import SwiftUI

protocol MockDependencyContainer: DependencyContainer {}

struct WithMockContainer<Container: MockDependencyContainer, Content: View>: View {
    
    private class Storage: ObservableObject {
        let container: Container
        
        init(container: Container) {
            self.container = container
        }
    }
    
    @StateObject private var storage: Storage
    
    private var content: (Container) -> Content
    
    init(
        _ container: @autoclosure @escaping () -> Container,
        @ViewBuilder content: @escaping (_ container: Container) -> Content) {
            self._storage = .init(wrappedValue: .init(container: container()))
        self.content = content
    }
    
    var body: some View {
        content(storage.container)
            .dependency(storage.container)
    }
}

extension View {
    @MainActor
    func mockContainer<Container: MockDependencyContainer>(
        _ container: @autoclosure @escaping () -> Container
    ) -> some View {
        WithMockContainer(container()) { _ in
            self
        }
    }
}
