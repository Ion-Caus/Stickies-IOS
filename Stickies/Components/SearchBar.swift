//
//  SearchBar.swift
//  Stickies
//
//  Created by Ion Caus on 03.07.2023.
//

import SwiftUI

struct SearchBar: View {
    
    let title: String
    @Binding var searchText: String
    
    init(_ title: String, searchText: Binding<String>) {
        self.title = title
        self._searchText = searchText
    }
    
    @FocusState private var focused: Bool
    
    var body: some View {
        TextFieldWithDebounce(title, debouncedText: $searchText)
            .focused($focused)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    focused = true
                }
            }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar("Title", searchText: .constant("Hii"))
    }
}
