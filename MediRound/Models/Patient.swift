//
//  Wristband.swift
//  MediRound
//
//  Created by Diego Balbi on 11/18/25.
//


//import Foundation
//
//struct Patient: Identifiable {
//    var id: String?
//
//    var name: String
//    var location: String
//    var checkInInterval: Int
//    var comments: String?
//    var wristbandID: String
//
//    var checkInTimes: [Date]
//    var checkedInBy: [String]
//}
//


import Foundation

/// One check-in event for a patient
struct CheckInRecord: Identifiable {
    var id = UUID().uuidString
    var time: Date
    var staff: String      // "" means "no staff / missed" if you ever need it
}

/// Patient model stored in Firestore
struct Patient: Identifiable {
    var id: String?        // Firestore document ID

    var name: String
    var location: String   // A-wing, B-wing, etc.
    var checkInInterval: Int   // in minutes
    var comments: String?
    var wristbandID: String

    /// History of check-ins, newest last
    var checkIns: [CheckInRecord]
    
    /// Used to anchor the check-in timeline
    var createdAt: Date
}
