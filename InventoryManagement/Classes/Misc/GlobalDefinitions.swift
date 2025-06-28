//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let domain = "https://inventory.korrekted.com"
    static let apiKey = "EDcTFGH4ebaBsIWQkm"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "8prKTwQ1BWlqc4Hq"
    
    static let applicationTag = "INVENTORY_MANAGEMENT"
    static let amplitudeApiKey = "d4ad5c33d23d7a891e9c68de9471f36b"
    
    static let termsOfServiceUrl = URL(string: "https://sergei-mobile.com/eula.html")!
    static let privacyPolicyUrl = URL(string: "https://sergei-mobile.com/policy.html")!
    static let contactUsUrl = URL(string: "https://sergei-mobile.com/contact.html")!
    
    enum Paygate {
        static let yearly = "inventory.yearly1"
        static let weekly = "inventory.weekly1"
    }
}
