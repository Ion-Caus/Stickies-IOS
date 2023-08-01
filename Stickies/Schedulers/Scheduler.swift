//
//  Scheduler.swift
//  Stickies
//
//  Created by Ion Caus on 01.08.2023.
//

import Foundation

protocol Scheduler {
    func getNextCard() -> Card?
    
    func answer(card: inout Card, with review: Review)
}
