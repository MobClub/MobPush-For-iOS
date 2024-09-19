//
//  ViewUtils.swift
//  MobPushDemo
//
//  Created by MobTech-iOS on 2023/7/24.
//  Copyright © 2023 com.mob. All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 16.0, *)
class MyViews {
    @ViewBuilder
    static func CirclrIcon(_ name: String, color: Color = .red) -> some View {
        Circle()
            .foregroundColor(color)
            .overlay {
                Image(systemName: name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .padding(5)
                    .bold()
            }
    }
}

