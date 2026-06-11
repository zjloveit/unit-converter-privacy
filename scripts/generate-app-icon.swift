#!/usr/bin/swift

import AppKit
import CoreGraphics

let size = 1024
let output = CommandLine.arguments.count > 1
    ? CommandLine.arguments[1]
    : "AppIcon-1024.png"

let colorSpace = CGColorSpaceCreateDeviceRGB()

let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
guard let context = CGContext(
    data: nil,
    width: size,
    height: size,
    bitsPerComponent: 8,
    bytesPerRow: 0,
    space: colorSpace,
    bitmapInfo: bitmapInfo
) else {
    fatalError("Could not create context")
}

func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> CGColor {
    CGColor(red: r, green: g, blue: b, alpha: a)
}

// Background gradient
let gradient = CGGradient(
    colorsSpace: colorSpace,
    colors: [
        color(0.08, 0.72, 0.65),
        color(0.15, 0.39, 0.92)
    ] as CFArray,
    locations: [0.0, 1.0]
)!
context.drawLinearGradient(
    gradient,
    start: CGPoint(x: 0, y: size),
    end: CGPoint(x: size, y: 0),
    options: []
)

context.setStrokeColor(color(1, 1, 1))
context.setFillColor(color(1, 1, 1))
context.setLineWidth(18)
context.setLineCap(CGLineCap.round)
context.setLineJoin(CGLineJoin.round)

let centerX = CGFloat(size) / 2
let centerY = CGFloat(size) / 2 + 10

// Ruler
let rulerWidth: CGFloat = 120
let rulerHeight: CGFloat = 300
let rulerX = centerX - 170
let rulerY = centerY - rulerHeight / 2
let rulerRect = CGRect(x: rulerX, y: rulerY, width: rulerWidth, height: rulerHeight)
context.stroke(rulerRect)
for i in 0..<5 {
    let y = rulerY + CGFloat(i) * (rulerHeight / 4)
    let tickLength: CGFloat = i % 2 == 0 ? 34 : 22
    context.move(to: CGPoint(x: rulerX, y: y))
    context.addLine(to: CGPoint(x: rulerX + tickLength, y: y))
    context.strokePath()
}

// Conversion arrows
let arrowCenter = CGPoint(x: centerX + 150, y: centerY)
let arrowRadius: CGFloat = 110
context.addArc(center: arrowCenter, radius: arrowRadius, startAngle: .pi * 0.15, endAngle: .pi * 1.35, clockwise: false)
context.strokePath()
drawArrowHead(context: context, tip: CGPoint(
    x: arrowCenter.x + cos(.pi * 0.15) * arrowRadius,
    y: arrowCenter.y + sin(.pi * 0.15) * arrowRadius
), angle: .pi * 0.15 + .pi / 2)

context.addArc(center: arrowCenter, radius: arrowRadius, startAngle: .pi * 1.15, endAngle: .pi * 1.85, clockwise: false)
context.strokePath()
drawArrowHead(context: context, tip: CGPoint(
    x: arrowCenter.x + cos(.pi * 1.85) * arrowRadius,
    y: arrowCenter.y + sin(.pi * 1.85) * arrowRadius
), angle: .pi * 1.85 - .pi / 2)

// Label
let label = "m ↔ ft" as NSString
let attributes: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 54, weight: .semibold),
    .foregroundColor: NSColor.white.withAlphaComponent(0.9)
]
let labelSize = label.size(withAttributes: attributes)
let labelY = CGFloat(size) - (centerY - 200) - labelSize.height
label.draw(
    at: CGPoint(x: centerX - labelSize.width / 2, y: labelY),
    withAttributes: attributes
)

guard let image = context.makeImage() else {
    fatalError("Could not make image")
}

let rep = NSBitmapImageRep(cgImage: image)
guard let data = rep.representation(using: NSBitmapImageRep.FileType.png, properties: [:]) else {
    fatalError("Could not encode PNG")
}
try data.write(to: URL(fileURLWithPath: output))
print("Wrote \(output)")

func drawArrowHead(context: CGContext, tip: CGPoint, angle: CGFloat) {
    let length: CGFloat = 28
    let spread: CGFloat = .pi / 7
    context.move(to: tip)
    context.addLine(to: CGPoint(
        x: tip.x - cos(angle - spread) * length,
        y: tip.y - sin(angle - spread) * length
    ))
    context.move(to: tip)
    context.addLine(to: CGPoint(
        x: tip.x - cos(angle + spread) * length,
        y: tip.y - sin(angle + spread) * length
    ))
    context.strokePath()
}
