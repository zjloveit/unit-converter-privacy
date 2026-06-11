#!/usr/bin/swift

import Foundation

enum ConversionCategory: String {
    case length, weight, temperature, volume
}

struct ConversionUnit {
    let id: String
    let toBase: (Double) -> Double
    let fromBase: (Double) -> Double
}

enum UnitInputParser {
    static func sanitize(_ text: String, allowsNegative: Bool) -> String {
        let compact = text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "−", with: "-")
        var result = ""
        var hasDecimal = false
        for (index, character) in compact.enumerated() {
            if character == "-" {
                if allowsNegative, index == 0, !result.contains("-") { result.append(character) }
            } else if character == "." || character == "," {
                if !hasDecimal { result.append("."); hasDecimal = true }
            } else if character.isNumber {
                result.append(character)
            }
        }
        return result
    }

    static func parse(_ text: String) -> Double? {
        let normalized = text.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "−", with: "-")
            .replacingOccurrences(of: ",", with: "")
        guard !normalized.isEmpty else { return nil }
        if ["-", ".", "-.", "-0."].contains(normalized) { return nil }
        if normalized.hasSuffix(".") {
            let without = String(normalized.dropLast())
            guard !without.isEmpty, without != "-", let value = Double(without), value.isFinite else { return nil }
            return value
        }
        guard let value = Double(normalized), value.isFinite else { return nil }
        return value
    }
}

let celsius = ConversionUnit(id: "C", toBase: { $0 }, fromBase: { $0 })
let fahrenheit = ConversionUnit(id: "F", toBase: { ($0 - 32) * 5 / 9 }, fromBase: { $0 * 9 / 5 + 32 })

func convert(_ value: Double, from s: ConversionUnit, to t: ConversionUnit) -> Double {
    t.fromBase(s.toBase(value))
}

assert(UnitInputParser.parse("-40") == -40)
assert(UnitInputParser.parse("-") == nil)
assert(UnitInputParser.parse("5.") == 5)
assert(UnitInputParser.sanitize("--40", allowsNegative: true) == "-40")
assert(UnitInputParser.sanitize(" -40", allowsNegative: true) == "-40")
assert(UnitInputParser.sanitize("-40", allowsNegative: false) == "40")
assert(abs(convert(-40, from: celsius, to: fahrenheit) + 40) < 0.0001)
assert(abs(convert(32, from: fahrenheit, to: celsius)) < 0.0001)

print("All converter checks passed.")
