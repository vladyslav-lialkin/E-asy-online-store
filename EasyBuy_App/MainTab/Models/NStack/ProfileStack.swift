//
//  ProfileStack.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.08.2024.
//

import Foundation

enum ProfileStack: CustomStringConvertible {
    case profile
    case orders([StatusOrderEnum])
    case order(UUID)
    case personalData
    case editPersonalData(PersonalDataField)
    case notification
    case settings
    case requestAccountDeletion

    var description: String {
        switch self {
        case .profile:
            return "Profile"
        case .orders(let statuses):
            return "Orders: \(statuses.map { $0.rawValue }.joined(separator: ", "))"
        case .order(let id):
            return "Order: \(id.uuidString)"
        case .personalData:
            return "PersonalData"
        case .editPersonalData(let edit):
            return "EditPersonalData: \(edit.rawValue)"
        case .notification:
            return "Notification"
        case .settings:
            return "Settings"
        case .requestAccountDeletion:
            return "RequestAccountDeletion"
        }
    }

    init?(rawValue: String) {
        if rawValue == "Profile" {
            self = .profile
        } else if rawValue == "PersonalData" {
            self = .personalData
        } else if rawValue == "Notification" {
            self = .notification
        } else if rawValue == "Settings" {
            self = .settings
        } else if rawValue == "RequestAccountDeletion" {
            self = .requestAccountDeletion
        } else if rawValue.starts(with: "Orders:") {
            let statusRawValues = rawValue.dropFirst("Orders:".count).split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
            let statuses = statusRawValues.compactMap { StatusOrderEnum(rawValue: $0) }
            if statuses.count == statusRawValues.count {
                self = .orders(statuses)
            } else {
                return nil
            }
        } else if rawValue.starts(with: "Order:") {
            let uuidString = String(rawValue.dropFirst("Order:".count))
            if let uuid = UUID(uuidString: uuidString) {
                self = .order(uuid)
            } else {
                return nil
            }
        } else if rawValue.starts(with: "EditPersonalData:") {
            let rawValue = String(rawValue.dropFirst("EditPersonalData:".count))
            if let edit = PersonalDataField(rawValue: rawValue) {
                self = .editPersonalData(edit)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
