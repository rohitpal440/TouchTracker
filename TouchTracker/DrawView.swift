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
    var lastPoint: CGPoint? = nil
    var swiped: Bool = false

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        UIColor.black.setStroke()
        for line in finishedLines {
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
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self)
            setNeedsDisplay()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first, let lastPoint = lastPoint {
            let currentPoint = touch.location(in: self)
//            strokeLine(line: Line(begin: lastPoint, end: currentPoint))
            finishedLines.append(Line(begin: lastPoint, end: currentPoint))
            self.lastPoint = currentPoint
            setNeedsDisplay()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            finishedLines.append(Line(begin: lastPoint!, end: lastPoint!))
            setNeedsDisplay()
        }
    }

}
