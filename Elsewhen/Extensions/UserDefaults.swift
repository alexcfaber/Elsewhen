//
//  UserDefaults.swift
//  UserDefaults
//
//  Created by Ben Cardy on 12/09/2021.
//

import Foundation

extension UserDefaults {
    
    static let mykeModeTimeZoneIdentifiersKey = "mykeModeTimeZoneIdentifiers"
    static let mykeModeTimeZoneIdentifiersUsingEUFlagKey = "mykeModeTimeZoneIdentifiersUsingEUFlag"
    
    var mykeModeTimeZones: [TimeZone] {
        get {
            guard let identifiers = array(forKey: Self.mykeModeTimeZoneIdentifiersKey) as? [String] else { return [] }
            return identifiers.compactMap { TimeZone(identifier: $0) }
        }
        set {
            set(newValue.map { $0.identifier }, forKey: Self.mykeModeTimeZoneIdentifiersKey)
        }
    }
    
    var mykeModeTimeZonesUsingEUFlag: Set<TimeZone> {
        get {
            guard let identifiers = array(forKey: Self.mykeModeTimeZoneIdentifiersUsingEUFlagKey) as? [String] else { return [] }
            return Set(identifiers.compactMap { TimeZone(identifier: $0) })
        }
        set {
            set(newValue.map { $0.identifier }, forKey: Self.mykeModeTimeZoneIdentifiersUsingEUFlagKey)
        }
    }
    
}
