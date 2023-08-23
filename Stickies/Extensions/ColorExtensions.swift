//
//  ColorExtensions.swift
//  Stickies
//
//  Created by Ion Caus on 23.08.2023.
//

import SwiftUI

extension Color {
    
    public static var accentBlue: Color {
        return Color(UIColor(red: 5/255, green: 44/255, blue: 250/255, alpha: 1.0))
    }
    
    public static var accentRed: Color {
        return Color(UIColor(red: 241/255, green: 0/255, blue: 27/255, alpha: 1.0))
    }
    
    public static var accentBlueDark: Color {
        return Color(UIColor(red: 10/255, green: 34/255, blue: 153/255, alpha: 1.0))
    }
    
    public static var accentRedDark: Color {
        return Color(UIColor(red: 171/255, green: 0/255, blue: 19/255, alpha: 1.0))
    }
    
    public static var darkGray: Color {
        return Color(UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1.0))
    }
    
    public static var accentWhite: Color {
        return Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0))
    }
}
