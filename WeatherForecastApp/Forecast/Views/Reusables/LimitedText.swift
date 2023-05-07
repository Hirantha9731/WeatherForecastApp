//
//  LimitedText.swift
//  Forecast
//
//  Created by Hirantha on 4/27/23.
//

import SwiftUI

struct LimitedText: View {
    
    let text : String
    let maxLength: Int
    
    var body: some View {
        Text(String(text.prefix(maxLength)))
    }
}
