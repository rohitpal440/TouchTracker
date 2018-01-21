//
//  DrawView.swift
//  TouchTracker
//
//  Created by Rohit Pal on 22/01/18.
//  Copyright © 2018 Technobells. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var currentLines: [NSValue: Line] = [:]
    var finishedLines: [Line] = []

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        UIColor.black.setStroke()
        for line in finishedLines {
            strokeLine(line: line)
        }
        UIColor.green.setStroke()
        for (_, line) in currentLines {
            // if line is currently being drawn, do it in green
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
        // Get location of the touch in view's coordinate system
        for touch in touches {
            let location = touch.location(in: self)
            let line = Line(begin: location, end: location)
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = line
        }
        setNeedsDisplay()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                let location = touch.location(in: self)
                line.end = location
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        setNeedsDisplay()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentLines.removeAll()
        setNeedsDisplay()
    }

}
