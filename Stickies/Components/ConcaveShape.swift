//
//  ConcaveShape.swift
//  Stickies
//
//  Created by Ion Caus on 23.08.2023.
//

import SwiftUI

struct ConcaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        path.move(to: CGPoint(x: 0, y: height))
        path.addCurve(to: CGPoint(x: 0.2 * width, y: 0.5 * height),
                      control1: CGPoint(x: 0.1 * width, y: height),
                      control2: CGPoint(x: 0.2 * width, y: 0.7 * height))
        path.addCurve(to: CGPoint(x: 0, y: 0),
                      control1: CGPoint(x: 0.2 * width, y: 0.3 * height),
                      control2: CGPoint(x: 0.1 * width, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        
        path.addCurve(to: CGPoint(x: 0.8 * width, y: 0.5 * height),
                      control1: CGPoint(x: 0.9 * width, y: 0),
                      control2: CGPoint(x: 0.8 * width, y: 0.3 * height))
        path.addCurve(to: CGPoint(x: width, y: height),
                      control1: CGPoint(x: 0.8 * width, y: 0.7 * height),
                      control2: CGPoint(x: 0.9 * width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        
        path.closeSubpath()
        return path
    }
}

struct ConcaveShape_Previews: PreviewProvider {
    static var previews: some View {
        ConcaveShape()
    }
}
