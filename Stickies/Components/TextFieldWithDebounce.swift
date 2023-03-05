//
//  TextFieldWithDebounce.swift
//  Stickies
//
//  Created by Ion Caus on 28.02.2023.
//

import SwiftUI
import Combine

class TextFieldObserver : ObservableObject {
    @Published var debouncedText = ""
    @Published var text = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $text
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] t in
                self?.debouncedText = t
            } )
            .store(in: &subscriptions)
    }
}

struct TextFieldWithDebounce : View {
    
    var title: String
    
    @Binding var debouncedText : String
    @StateObject private var textObserver = TextFieldObserver()
    
    init(_ title: String, debouncedText: Binding<String>) {
        self.title = title
        _debouncedText = debouncedText
    }
    
    var body: some View {

        TextField(title, text: $textObserver.text)
            .onReceive(textObserver.$debouncedText) { (val) in
            debouncedText = val
        }
    }
}
