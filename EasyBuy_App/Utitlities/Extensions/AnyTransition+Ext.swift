//
//  AnyTransition+Ext.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 17.09.2024.
//

import SwiftUI

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        )
    }
}
