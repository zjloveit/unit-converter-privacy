import Foundation

enum ConversionCategory: String, CaseIterable, Identifiable {
    case length
    case weight
    case temperature
    case volume

    var id: String { rawValue }

    var title: String {
        switch self {
        case .length: return "Length"
        case .weight: return "Weight"
        case .temperature: return "Temperature"
        case .volume: return "Volume"
        }
    }

    /// Shorter label for the segmented control on narrow screens.
    var segmentTitle: String {
        switch self {
        case .length: return "Length"
        case .weight: return "Weight"
        case .temperature: return "Temp"
        case .volume: return "Volume"
        }
    }

    var defaultInput: String {
        self == .temperature ? "0" : "1"
    }

    var allowsNegativeInput: Bool {
        self == .temperature
    }

    var systemImage: String {
        switch self {
        case .length: return "ruler"
        case .weight: return "scalemass"
        case .temperature: return "thermometer.medium"
        case .volume: return "drop"
        }
    }

    var units: [ConversionUnit] {
        switch self {
        case .length:
            return [.meter, .kilometer, .centimeter, .millimeter, .mile, .yard, .foot, .inch]
        case .weight:
            return [.kilogram, .gram, .pound, .ounce, .metricTon]
        case .temperature:
            return [.celsius, .fahrenheit, .kelvin]
        case .volume:
            return [.liter, .milliliter, .gallonUS, .fluidOunceUS, .cupUS, .cubicMeter]
        }
    }
}

struct ConversionUnit: Identifiable {
    let id: String
    let name: String
    let symbol: String
    let toBase: (Double) -> Double
    let fromBase: (Double) -> Double

    static let meter = ConversionUnit(
        id: "m", name: "Meter", symbol: "m",
        toBase: { $0 },
        fromBase: { $0 }
    )

    static let kilometer = ConversionUnit(
        id: "km", name: "Kilometer", symbol: "km",
        toBase: { $0 * 1_000 },
        fromBase: { $0 / 1_000 }
    )

    static let centimeter = ConversionUnit(
        id: "cm", name: "Centimeter", symbol: "cm",
        toBase: { $0 / 100 },
        fromBase: { $0 * 100 }
    )

    static let millimeter = ConversionUnit(
        id: "mm", name: "Millimeter", symbol: "mm",
        toBase: { $0 / 1_000 },
        fromBase: { $0 * 1_000 }
    )

    static let mile = ConversionUnit(
        id: "mi", name: "Mile", symbol: "mi",
        toBase: { $0 * 1_609.344 },
        fromBase: { $0 / 1_609.344 }
    )

    static let yard = ConversionUnit(
        id: "yd", name: "Yard", symbol: "yd",
        toBase: { $0 * 0.9144 },
        fromBase: { $0 / 0.9144 }
    )

    static let foot = ConversionUnit(
        id: "ft", name: "Foot", symbol: "ft",
        toBase: { $0 * 0.3048 },
        fromBase: { $0 / 0.3048 }
    )

    static let inch = ConversionUnit(
        id: "in", name: "Inch", symbol: "in",
        toBase: { $0 * 0.0254 },
        fromBase: { $0 / 0.0254 }
    )

    static let kilogram = ConversionUnit(
        id: "kg", name: "Kilogram", symbol: "kg",
        toBase: { $0 },
        fromBase: { $0 }
    )

    static let gram = ConversionUnit(
        id: "g", name: "Gram", symbol: "g",
        toBase: { $0 / 1_000 },
        fromBase: { $0 * 1_000 }
    )

    static let pound = ConversionUnit(
        id: "lb", name: "Pound", symbol: "lb",
        toBase: { $0 * 0.453_592_37 },
        fromBase: { $0 / 0.453_592_37 }
    )

    static let ounce = ConversionUnit(
        id: "oz", name: "Ounce", symbol: "oz",
        toBase: { $0 * 0.028_349_523_125 },
        fromBase: { $0 / 0.028_349_523_125 }
    )

    static let metricTon = ConversionUnit(
        id: "t", name: "Metric Ton", symbol: "t",
        toBase: { $0 * 1_000 },
        fromBase: { $0 / 1_000 }
    )

    static let celsius = ConversionUnit(
        id: "C", name: "Celsius", symbol: "°C",
        toBase: { $0 },
        fromBase: { $0 }
    )

    static let fahrenheit = ConversionUnit(
        id: "F", name: "Fahrenheit", symbol: "°F",
        toBase: { ($0 - 32) * 5 / 9 },
        fromBase: { $0 * 9 / 5 + 32 }
    )

    static let kelvin = ConversionUnit(
        id: "K", name: "Kelvin", symbol: "K",
        toBase: { $0 - 273.15 },
        fromBase: { $0 + 273.15 }
    )

    static let liter = ConversionUnit(
        id: "L", name: "Liter", symbol: "L",
        toBase: { $0 },
        fromBase: { $0 }
    )

    static let milliliter = ConversionUnit(
        id: "mL", name: "Milliliter", symbol: "mL",
        toBase: { $0 / 1_000 },
        fromBase: { $0 * 1_000 }
    )

    static let gallonUS = ConversionUnit(
        id: "gal", name: "US Gallon", symbol: "gal",
        toBase: { $0 * 3.785_411_784 },
        fromBase: { $0 / 3.785_411_784 }
    )

    static let fluidOunceUS = ConversionUnit(
        id: "fl oz", name: "US Fluid Ounce", symbol: "fl oz",
        toBase: { $0 * 0.029_573_529_562_5 },
        fromBase: { $0 / 0.029_573_529_562_5 }
    )

    static let cupUS = ConversionUnit(
        id: "cup", name: "US Cup", symbol: "cup",
        toBase: { $0 * 0.236_588_236_5 },
        fromBase: { $0 / 0.236_588_236_5 }
    )

    static let cubicMeter = ConversionUnit(
        id: "m³", name: "Cubic Meter", symbol: "m³",
        toBase: { $0 * 1_000 },
        fromBase: { $0 / 1_000 }
    )
}

enum UnitInputParser {
    /// Keeps only valid numeric characters; optional leading minus for temperature.
    static func sanitize(_ text: String, allowsNegative: Bool) -> String {
        let compact = text
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "−", with: "-")

        var result = ""
        var hasDecimal = false

        for (index, character) in compact.enumerated() {
            if character == "-" {
                if allowsNegative, index == 0, !result.contains("-") {
                    result.append(character)
                }
            } else if character == "." || character == "," {
                if !hasDecimal {
                    result.append(".")
                    hasDecimal = true
                }
            } else if character.isNumber {
                result.append(character)
            }
        }

        return result
    }

    /// Returns nil for incomplete input such as `-`, `.`, or `-0.`.
    static func parse(_ text: String) -> Double? {
        let normalized = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "−", with: "-")
            .replacingOccurrences(of: ",", with: "")

        guard !normalized.isEmpty else { return nil }

        if normalized == "-" || normalized == "." || normalized == "-." || normalized == "-0." {
            return nil
        }

        if normalized.hasSuffix(".") {
            let withoutTrailingDot = String(normalized.dropLast())
            guard !withoutTrailingDot.isEmpty, withoutTrailingDot != "-" else { return nil }
            guard let value = Double(withoutTrailingDot), value.isFinite else { return nil }
            return value
        }

        guard let value = Double(normalized), value.isFinite else { return nil }
        return value == 0 ? 0 : value
    }
}

enum UnitConverterEngine {
    static func convert(value: Double, from source: ConversionUnit, to target: ConversionUnit) -> Double {
        guard value.isFinite else { return 0 }
        let base = source.toBase(value)
        return target.fromBase(base)
    }

    static func format(_ value: Double) -> String {
        guard value.isFinite else { return "—" }

        let absValue = abs(value)
        let formatted: String
        if absValue != 0, (absValue < 0.000_1 || absValue >= 10_000_000) {
            formatted = String(format: "%.6e", value)
        } else if absValue >= 100 {
            formatted = String(format: "%.4f", value)
        } else if absValue >= 1 {
            formatted = String(format: "%.6f", value)
        } else {
            formatted = String(format: "%.8f", value)
        }

        return trimTrailingZeros(from: formatted)
    }

    static func formatForInput(_ value: Double) -> String {
        let formatted = format(value)
        return formatted == "—" ? "" : formatted
    }

    private static func trimTrailingZeros(from formatted: String) -> String {
        guard formatted.contains("."), !formatted.contains("e") else { return formatted }

        var result = formatted
        while result.last == "0" {
            result.removeLast()
        }
        if result.last == "." {
            result.removeLast()
        }
        return result == "-0" ? "0" : result
    }
}
