//
//  Constants..swift
//  Stickies
//
//  Created by Ion Caus on 25.02.2023.
//

struct Constants {
    static let DefaultLanguage = "en-US"
    
    static let DefaultShuffleMode: ShuffleMode = .spacedRepetition
    static let DefaultMultipleDecksMode: Bool = false
    
    static let DefaultLearningSteps = [ 5, 60, 3 * 60 ]
    static let DefaultEaseFactor = 2.5
}

struct AppStorageKeys {
    static let SpeechUtteranceRate = "speech.utterance.rate"
    static let SpeechUtteranceVolume = "speech.utterance.volume"
    
    static let GoogleTranslateApiKey = "google.translate.api.key"
    
    // NB: both the input and output chars are taken into account when calculating the limit
    static let TranslateCharsSent = "translate.chars.sent"
    
    static let MultipleDecksMode = "play.decks.multiple"
    static let ShuffleMode = "play.shuffle.mode"
    
    static let RequiredCardsPlayed = "goal.required.cards.played"
    
    static let SpacedRepetitionLearningSteps = "spaced-repetition.learning-steps"
    static let SpacedRepetitionEaseFactor = "spaced-repetition.ease-factor"
}
