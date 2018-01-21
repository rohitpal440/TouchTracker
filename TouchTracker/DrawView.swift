//
//  DrawView.swift
//  TouchTracker
//
//  Created by Rohit Pal on 22/01/18.
//  Copyright © 2018 Technobells. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var currentLine: Line?
    var finishedLines: [Line] = []

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        UIColor.black.setStroke()
        for line in finishedLines {
            strokeLine(line: line)
        }
        if let line = currentLine {
            // if line is currently being drawn, do it in green
            UIColor.green.setStroke()
            strokeLine(line: line)
        }
    }

    func strokeLine(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = 10;
        path.lineCapStyle = .round
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        // Get location of the touch in view's coordinate system
        let location = touch.location(in: self)
        currentLine = Line(begin: location, end: location)
        setNeedsDisplay()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        currentLine?.end = location
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if var line = currentLine {
            let touch = touches.first!
            let location = touch.location(in: self)
            line.end = location
            finishedLines.append(line)
        }
        currentLine = nil
        setNeedsDisplay()
    }

}
