import SwiftUI

struct ConverterView: View {
    let category: ConversionCategory

    @State private var inputText: String
    @State private var fromUnitID: String
    @State private var toUnitID: String
    @FocusState private var inputFocused: Bool

    init(category: ConversionCategory) {
        self.category = category
        let units = category.units
        _inputText = State(initialValue: category.defaultInput)
        _fromUnitID = State(initialValue: units[0].id)
        _toUnitID = State(initialValue: units.count > 1 ? units[1].id : units[0].id)
    }

    private var fromUnit: ConversionUnit {
        category.units.first { $0.id == fromUnitID } ?? category.units[0]
    }

    private var toUnit: ConversionUnit {
        category.units.first { $0.id == toUnitID } ?? category.units[0]
    }

    private var parsedInput: Double? {
        UnitInputParser.parse(inputText)
    }

    private var outputValue: Double {
        guard let parsedInput else { return .nan }
        return UnitConverterEngine.convert(value: parsedInput, from: fromUnit, to: toUnit)
    }

    private var canSwap: Bool {
        parsedInput != nil
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                inputSection(title: "From", unitID: $fromUnitID)
                swapButton
                inputSection(title: "To", unitID: $toUnitID, isOutput: true)

                Text("Results are for reference only.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .padding(.bottom, 72)
        }
        .navigationTitle(category.title)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            BannerAdContainer()
        }
        .onChange(of: inputText) { _, newValue in
            let sanitized = UnitInputParser.sanitize(
                newValue,
                allowsNegative: category.allowsNegativeInput
            )
            if sanitized != newValue {
                inputText = sanitized
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                if category.allowsNegativeInput {
                    Button("±") {
                        toggleInputSign()
                    }
                    .font(.title3.weight(.semibold))
                }
                Spacer()
                Button("Done") {
                    inputFocused = false
                }
            }
        }
    }

    @ViewBuilder
    private func inputSection(title: String, unitID: Binding<String>, isOutput: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            if isOutput {
                Text(UnitConverterEngine.format(outputValue))
                    .font(.system(size: 34, weight: .semibold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .accessibilityLabel("Converted value \(UnitConverterEngine.format(outputValue))")
            } else {
                TextField("0", text: $inputText)
                    .keyboardType(.decimalPad)
                    .focused($inputFocused)
                    .font(.system(size: 34, weight: .semibold, design: .rounded))
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Picker("Unit", selection: unitID) {
                ForEach(category.units) { item in
                    Text("\(item.name) (\(item.symbol))").tag(item.id)
                }
            }
            .pickerStyle(.menu)
        }
    }

    private var swapButton: some View {
        HStack {
            Spacer()
            Button {
                swapUnits()
            } label: {
                Label("Swap", systemImage: "arrow.up.arrow.down")
                    .font(.subheadline.weight(.semibold))
            }
            .buttonStyle(.bordered)
            .disabled(!canSwap)
            Spacer()
        }
    }

    private func toggleInputSign() {
        if inputText.hasPrefix("-") {
            inputText = String(inputText.dropFirst())
        } else if inputText.isEmpty || inputText == "." {
            inputText = "-"
        } else {
            inputText = "-" + inputText
        }
    }

    private func swapUnits() {
        guard let parsedInput else { return }

        let source = fromUnit
        let target = toUnit
        let converted = UnitConverterEngine.convert(value: parsedInput, from: source, to: target)

        fromUnitID = target.id
        toUnitID = source.id
        inputText = UnitConverterEngine.formatForInput(converted)
    }
}
