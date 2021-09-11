//
//  DateHelpers.swift
//  DateHelpers
//
//  Created by David on 10/09/2021.
//

import Foundation

enum FormatCode: String {
    case f
    case F
    case D
    case t
    case T
    case R
}

struct DateFormat: Identifiable, Hashable {
    let icon: String
    let name: String
    let code: FormatCode
    
    var id: String { code.rawValue }
}

let dateFormats: [DateFormat] = [
    DateFormat(icon: "calendar.badge.clock", name: "Full", code: .f),
    DateFormat(icon: "calendar.badge.plus", name: "Full with Day", code: .F),
    DateFormat(icon: "calendar", name: "Date only", code: .D),
    DateFormat(icon: "clock", name: "Time only", code: .t),
    DateFormat(icon: "clock.fill", name: "Time with seconds", code: .T),
    DateFormat(icon: "clock.arrow.2.circlepath", name: "Relative", code: .R),
]

func convert(date: Date, from initialTimezone: TimeZone, to targetTimezone: TimeZone) -> Date {
    let offset = TimeInterval(targetTimezone.secondsFromGMT(for: date) - initialTimezone.secondsFromGMT(for: date))
    return date.addingTimeInterval(offset)
}

func formatTimeZoneName(_ zone: String) -> String {
    zone.replacingOccurrences(of: "_", with: " ")
}

func format(date: Date, in timezone: TimeZone, with formatCode: FormatCode) -> String {
    let dateFormatter = DateFormatter()
    switch formatCode {
    case .f:
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
    case .F:
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
    case .D:
        dateFormatter.dateStyle = .long
    case .t:
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
    case .T:
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
    case .R:
        let relativeFormatter = RelativeDateTimeFormatter()
        let convertedNow = convert(date: Date(), from: TimeZone.current, to: timezone)
        return relativeFormatter.localizedString(for: date, relativeTo: convertedNow)
    }
    return dateFormatter.string(from: date)
}

func discordFormat(for date: Date, in timezone: String, with formatCode: FormatCode) -> String {
    var timeIntervalSince1970 = Int(date.timeIntervalSince1970)
    
    if let tz = TimeZone(identifier: timezone) {
        timeIntervalSince1970 = Int(convert(date: date, from: tz, to: TimeZone.current).timeIntervalSince1970)
    } else {
        logger.warning("\(date, privacy: .public) is not a valid timezone identifier!")
    }
    
    return "<t:\(timeIntervalSince1970):\(formatCode.rawValue)>"
}

func filteredTimeZones(by searchTerm: String) -> [TimeZone] {
    let st = searchTerm.trimmingCharacters(in: .whitespaces).lowercased().replacingOccurrences(of: " ", with: "_")
    return TimeZone.knownTimeZoneIdentifiers.compactMap { tz in
        TimeZone(identifier: tz)
    }.filter { tz in
        if st == "" {
            return true
        }
        if tz.identifier.lowercased().contains(st) {
            return true
        }
        if let abbreviation = tz.abbreviation(), abbreviation.lowercased().contains(st) {
            return true
        }
        return false
    }
}