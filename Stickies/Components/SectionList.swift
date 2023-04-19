//
//  SectionList.swift
//  Stickies
//
//  Created by Ion Caus on 15.04.2023.
//

import SwiftUI

struct SectionList<T, TView>: View where TView: View, T: Identifiable & Hashable {
    
    let groups: Dictionary<String, Array<T>>
    let content: (T) -> TView
    
    var body: some View {
        let keys = groups.keys.map {"\($0)"}.sorted()
    
        List {
            ForEach(keys, id: \.self) { key in
                Section(header: Text(key)) {
                    ForEach(groups[key] ?? [], id:\.id) { item in
                        content(item)
                    }
                }
            }
            .id(groups)
        }
        .listStyle(InsetGroupedListStyle())
    }
}
