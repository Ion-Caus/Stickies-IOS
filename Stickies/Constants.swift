//
//  Constants..swift
//  Stickies
//
//  Created by Ion Caus on 25.02.2023.
//

struct Constants {
    static let DefaultLanguage = "en-US"
    
    static let DefaultShuffleMode: ShuffleMode = .worstToBest
    static let DefaultMultipleDecksMode: Bool = false
}

struct AppStorageKeys {
    static let SpeechUtteranceRate = "speech.utterance.rate"
    static let SpeechUtteranceVolume = "speech.utterance.volume"
    
    static let GoogleTranslateApiKey = "google.translate.api.key"
    
    // NB: both the input and output chars are taken into account when calculating the limit
    static let TranslateCharsSent = "translate.chars.sent"
    
    static let MultipleDecksMode = "play.decks.multiple"
    static let ShuffleMode = "play.shuffle.mode"
}
