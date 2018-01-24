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

    var selectedLineIndex: Int? {
        didSet {
            if selectedLineIndex == nil {
                let menu = UIMenuController.shared
                menu.setMenuVisible(false, animated: true)
            }
        }
    }

    @IBInspectable var finishedLineColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var currentLineColor: UIColor = .green {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }



    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        finishedLineColor.setStroke()
        for line in finishedLines {
            strokeLine(line: line)
        }
        currentLineColor.setStroke()
        for (_, line) in currentLines {
            // if line is currently being drawn, do it in green
            strokeLine(line: line)
        }
    }

    func strokeLine(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
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

    @objc func clearScreen() {
        currentLines.removeAll(keepingCapacity: false)
        finishedLines.removeAll(keepingCapacity: false)
        selectedLineIndex = nil
        setNeedsDisplay()
    }

    @objc func tap(gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(atPoint: point)
        let menu = UIMenuController.shared
        if selectedLineIndex != nil {
            becomeFirstResponder()
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(deleteLine(lineIndex:)))
            menu.menuItems = [deleteItem]
            menu.setTargetRect(CGRect(x: point.x, y: point.y, width: 2, height: 2), in: self)
            menu.setMenuVisible(true, animated: true)
        } else {
            menu.setMenuVisible(false, animated: true)
        }
        setNeedsDisplay()
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    @objc func deleteLine(lineIndex index: Int) {
        if let index = selectedLineIndex {
            finishedLines.remove(at: index)
            selectedLineIndex = nil
            setNeedsDisplay()
        }
    }

    @objc func longPress(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: self)
            selectedLineIndex = indexOfLine(atPoint: point)
            if selectedLineIndex != nil {
                currentLines.removeAll(keepingCapacity: false)
            }
        } else if gestureRecognizer.state == .ended {
            selectedLineIndex = nil
        }
        setNeedsDisplay()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc func moveLine(gestureRecognizer: UIPanGestureRecognizer) {
        if let index = selectedLineIndex {
            if gestureRecognizer.state == .changed {
                let translation = gestureRecognizer.translation(in: self)
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                gestureRecognizer.setTranslation(.zero, in: self)
                setNeedsDisplay()
            }
        } else {
            return
        }
    }
}
