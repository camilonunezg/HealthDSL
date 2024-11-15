//
//  HealthDataSample.swift
//  HealthDSL
//
//  Created by Andrés Camilo Núñez Garzón on 13/11/24.
//

import Foundation

struct HealthDataSample: Identifiable {
    let id: String
    let value: Measurement<Unit>
    let type: HealthDataType
    let period: HealthDataSample.Period
    let deviceSources: [HealthDataSample.Device]?
}

// MARK: - HealthDataSample.Period
extension HealthDataSample {
    struct Period {
        let startDate: Date
        let endDate: Date
    }
}

// MARK: - HealthDataSample.Device
extension HealthDataSample {
    struct Device {
        let id: String
        let name: String

        static let iPhone = Device(id: "iPhone", name: "iPhone")
        static let appleWatch = Device(id: "appleWatch", name: "Apple Watch")
        static let smartBand = Device(id: "smartBand", name: "Smart Band")
        static let unknown = Device(id: "unknown", name: "Unknown")
    }
}

// MARK: - HealthDataSample DSL builder
extension HealthDataSample {
    init(
        id: String,
        type: HealthDataType,
        value: Double,
        @HealthDataSampleBuilder _ makeMetadata: () -> (HealthDataSample.Period, [HealthDataSample.Device])
    ) {
        let measurement = Measurement(value: value, unit: type.unit)
        let (period, deviceSources) = makeMetadata()

        self.init(
            id: id,
            value: measurement,
            type: type,
            period: period,
            deviceSources: deviceSources
        )
    }
}

@resultBuilder
enum HealthDataSampleBuilder {
    static func buildBlock(
        _ period: HealthDataSample.Period,
        _ deviceSources: HealthDataSample.Device...
    ) -> (HealthDataSample.Period, [HealthDataSample.Device]) {
        return (period, deviceSources)
    }

    @available(*, unavailable, message: "first statement of HealthDataSample must be its period")
    static func buildBlock(_ deviceSources: HealthDataSample.Device...) -> (HealthDataSample.Period, [HealthDataSample.Device]) {
        fatalError()
    }
}

@resultBuilder
enum HealthDataSampleArrayBuilder {
    static func buildBlock(_ samples: [HealthDataSample]...) -> [HealthDataSample] {
        samples.flatMap { $0 }
    }

    static func buildExpression(_ expression: HealthDataSample) -> [HealthDataSample] {
        [expression]
    }

    static func buildOptional(_ sample: [HealthDataSample]?) -> [HealthDataSample] {
        sample ?? []
    }
}

// MARK: - Health data samples list
extension HealthDataSample {
    @HealthDataSampleArrayBuilder
    static func previewSamples(includeNonAppleSamples: Bool = false) -> [HealthDataSample] {
        HealthDataSample(id: UUID().uuidString, type: .heartRate.measured(with: Unit(symbol: "bpm")), value: 72) {
            Period(startDate: .now, endDate: .now)
            HealthDataSample.Device.iPhone
            HealthDataSample.Device.appleWatch
        }
        HealthDataSample(id: UUID().uuidString, type: .oxygenSaturation, value: 0.82) {
            Period(startDate: .now, endDate: .now.addingTimeInterval(-3600))
            HealthDataSample.Device.iPhone
            HealthDataSample.Device.appleWatch
        }
        HealthDataSample(id: UUID().uuidString, type: .oxygenSaturation, value: 0.80) {
            Period(startDate: .now, endDate: .now.addingTimeInterval(-7200))
            HealthDataSample.Device.iPhone
            HealthDataSample.Device.appleWatch
        }
        HealthDataSample(id: UUID().uuidString, type: .distanceWalkingRunning, value: 1234.2) {
            Period(startDate: .now, endDate: .now.addingTimeInterval(-3600))
            HealthDataSample.Device.iPhone
        }

        if !includeNonAppleSamples {
            HealthDataSample(id: UUID().uuidString, type: .stepCount, value: 1234) {
                Period(startDate: .now, endDate: .now.addingTimeInterval(-3600))
                HealthDataSample.Device.smartBand
            }
            HealthDataSample(id: UUID().uuidString, type: .oxygenSaturation, value: 98.5) {
                Period(startDate: .now, endDate: .now.addingTimeInterval(-3600))
                HealthDataSample.Device.unknown
            }
            HealthDataSample(id: UUID().uuidString, type: .stepCount, value: 1234) {
                Period(startDate: .now, endDate: .now.addingTimeInterval(-3600))
                HealthDataSample.Device.smartBand
            }
            HealthDataSample(id: UUID().uuidString, type: .oxygenSaturation, value: 98.5) {
                Period(startDate: .now, endDate: .now.addingTimeInterval(-3600))
                HealthDataSample.Device.unknown
            }
        }
    }
}
