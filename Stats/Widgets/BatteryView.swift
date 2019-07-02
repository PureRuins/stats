//
//  BatteryView.swift
//  Stats
//
//  Created by Serhiy Mytrovtsiy on 14/06/2019.
//  Copyright © 2019 Serhiy Mytrovtsiy. All rights reserved.
//

import Cocoa

class BatteryView: NSView, Widget {
    let batteryWidth: CGFloat = 32
    let percentageWidth: CGFloat = 40
    
    var value: Double {
        didSet {
            self.redraw()
        }
    }
    var charging: Bool {
        didSet {
            self.redraw()
        }
    }
    var percentage: Bool {
        didSet {
            self.redraw()
        }
    }
    
    var percentageValue: NSTextField = NSTextField()
    
    override init(frame: NSRect) {
        self.value = 1.0
        self.charging = false
        self.percentage = false
        super.init(frame: frame)
        self.wantsLayer = true
        self.percentageView()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        var x: CGFloat = 4.0
        var w: CGFloat = dirtyRect.size.width - (x * 2)
        let h: CGFloat = 11.0
        let y: CGFloat = (dirtyRect.size.height - h) / 2
        let r: CGFloat = 1.0
        if self.percentage {
            w = batteryWidth - (x * 2)
            x = percentageWidth + x
        }
        
        let battery = NSBezierPath(roundedRect: NSRect(x: x-1, y: y, width: w-1, height: h), xRadius: r, yRadius: r)
        
        let bPX: CGFloat = x+w-2
        let bPY: CGFloat = (dirtyRect.size.height / 2) - 2
        let batteryPoint = NSBezierPath(roundedRect: NSRect(x: bPX, y: bPY, width: 2, height: 4), xRadius: r, yRadius: r)
        if self.charging {
            NSColor.systemGreen.set()
        } else {
            NSColor.labelColor.set()
        }
        batteryPoint.lineWidth = 1.1
        batteryPoint.stroke()
        batteryPoint.fill()
        
        let maxWidth = w-4
        let inner = NSBezierPath(roundedRect: NSRect(x: x+0.5, y: y+1.5, width: maxWidth*CGFloat(self.value), height: h-3), xRadius: 0.5, yRadius: 0.5)
        self.value.batteryColor().set()
        inner.lineWidth = 0
        inner.stroke()
        inner.close()
        inner.fill()
        
        if self.charging {
            NSColor.systemGreen.set()
        } else {
            NSColor.labelColor.set()
        }
        battery.lineWidth = 0.8
        battery.stroke()
    }
    
    func percentageView() {
        if self.percentage {
            percentageValue = NSTextField(frame: NSMakeRect(0, 0, percentageWidth, self.frame.size.height - 2))
            percentageValue.isEditable = false
            percentageValue.isSelectable = false
            percentageValue.isBezeled = false
            percentageValue.wantsLayer = true
            percentageValue.textColor = .labelColor
            percentageValue.backgroundColor = .controlColor
            percentageValue.canDrawSubviewsIntoLayer = true
            percentageValue.alignment = .natural
            percentageValue.font = NSFont.systemFont(ofSize: 13, weight: .light)
            percentageValue.stringValue = "\(Int(self.value * 100))%"
            
            self.addSubview(percentageValue)
            self.frame = CGRect(x: 0, y: 0, width: batteryWidth + percentageWidth, height: self.frame.size.height)
        } else {
            for subview in self.subviews {
                subview.removeFromSuperview()
            }
            self.addSubview(NSView())
            self.frame = CGRect(x: 0, y: 0, width: batteryWidth, height: self.frame.size.height)
        }
    }
    
    func redraw() {
        self.needsDisplay = true
        setNeedsDisplay(self.frame)
    }
    
    func value(value: Double) {
        if self.value != value {
            self.value = value
            
            if percentage {
                self.percentageValue.stringValue = "\(Int(self.value * 100))%"
            }
        }
    }
    
    func setCharging(value: Bool) {
        if self.charging != value {
            self.charging = value
        }
    }
    
    func setPercentage(value: Bool) {
        if self.percentage != value {
            self.percentage = value
            self.percentageView()
        }
    }
}