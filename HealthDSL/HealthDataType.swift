//
//  HealthDataType.swift
//  HealthDSL
//
//  Created by Andrés Camilo Núñez Garzón on 13/11/24.
//

import Foundation

// MARK: - HealthDataType
public struct HealthDataType: Identifiable {
    public let id: String
    public let name: String
    public let unit: Unit

    init(id: String, name: String, unit: Unit) {
        self.id = id
        self.name = name
        self.unit = unit
    }
}

// MARK: - Main health data types
public extension HealthDataType {
    static let heartRate = HealthDataType(
        id: "heartRate",
        name: String(localized: "Heart Rate"),
        unit: UnitFrequency.hertz
    )

    static let oxygenSaturation = HealthDataType(
        id: "oxygenSaturation",
        name: String(localized: "Oxygen Saturation"),
        unit: Unit(symbol: "%")
    )

    static let stepCount = HealthDataType(
        id: "stepCount",
        name: String(localized: "Step Count"),
        unit: Unit(symbol: "count")
    )

    static let distanceWalkingRunning = HealthDataType(
        id: "distanceWalkingRunning",
        name: String(localized: "Distance Walking Running"),
        unit: UnitLength.meters
    )
}

public extension HealthDataType {
    func measured(with unit: Unit) -> HealthDataType {
        return HealthDataType(id: id, name: name, unit: unit)
    }
}
