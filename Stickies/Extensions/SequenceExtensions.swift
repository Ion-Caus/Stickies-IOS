//
//  SequenceExtensions.swift
//  Stickies
//
//  Created by Ion Caus on 25.02.2023.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
