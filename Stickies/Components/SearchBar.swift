//
//  SearchBar.swift
//  Stickies
//
//  Created by Ion Caus on 03.07.2023.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
    
    @FocusState private var focused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.secondary)
            
            TextFieldWithDebounce("Search cards...", debouncedText: $searchText)
                .focused($focused)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        focused = true
                    }
                }
        }
        .padding(9)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant("Hii"))
    }
}
