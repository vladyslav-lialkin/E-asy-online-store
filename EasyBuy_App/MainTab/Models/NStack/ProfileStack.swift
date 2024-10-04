//
//  ProfileStack.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.08.2024.
//

import Foundation

enum ProfileStack: CustomStringConvertible {
    case profile
    case orders(StatusOrderEnum)
    case order(UUID)
    case personalData
    case notification
    case settings
    case requestAccountDeletion

    var description: String {
        switch self {
        case .profile:
            "Profile"
        case .orders(let status):
            "Orders:\(status.rawValue)"
        case .order(let id):
            "Order:\(id.uuidString)"
        case .personalData:
            "PersonalData"
        case .notification:
            "Notification"
        case .settings:
            "Settings"
        case .requestAccountDeletion:
            "RequestAccountDeletion"
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
            let statusRawValue = String(rawValue.dropFirst("Orders:".count))
            if let status = StatusOrderEnum(rawValue: statusRawValue) {
                self = .orders(status)
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
        } else {
            return nil
        }
    }
}
