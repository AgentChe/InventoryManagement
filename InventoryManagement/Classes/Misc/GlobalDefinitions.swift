//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let domain = "https://inventory.thinkaboutapps.com"
    static let apiKey = "EDcTFGH4ebaBsIWQkm"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "8prKTwQ1BWlqc4Hq"
    
    static let termsOfServiceUrl = URL(string: "https://thinkaboutapps.com/terms")!
    static let privacyPolicyUrl = URL(string: "https://thinkaboutapps.com/policy")!
    static let contactUsUrl = URL(string: "https://thinkaboutapps.com/contact")!
    
    enum Paygate {
        static let yearly = "inventory.yearly1"
        static let weekly = "inventory.weekly1"
    }
}
