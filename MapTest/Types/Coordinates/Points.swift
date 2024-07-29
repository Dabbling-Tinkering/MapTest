// Copyright © 2024 Charles Kerr. All rights reserved.

import Foundation

// ==============================================================
// 2D Point
// ==============================================================
struct Point : Codable {
    static let zero = Point(xlocation: 0, ylocation: 0)
    var xlocation = 0
    var ylocation = 0
    
    init(xlocation: Int = 0, ylocation: Int = 0) {
        self.xlocation = xlocation
        self.ylocation = ylocation
    }
    init(point3:Point3) {
        self.xlocation = point3.xlocation
        self.ylocation = point3.ylocation
    }
    
    init(description:String) throws {
        let values = description.components(separatedBy: ",").map{ $0.trimmingCharacters(in: .whitespaces)}
        guard values.count >= 2 else {
            throw GeneralError(errorMessage: "Incorrect amount of arguments",failure: "Description was: \(description)")
        }
        guard let tempx = Int(values[0]) else {
            throw GeneralError(errorMessage: "Invalid arguments",failure: "Description was: \(description)")
        }
        xlocation = tempx
        
        guard let tempy = Int(values[1]) else {
            throw GeneralError(errorMessage: "Invalid arguments",failure: "Description was: \(description)")
        }
        ylocation = tempy
    }
}

extension Point : CustomStringConvertible {
    var description: String {
        return String(format:"%i,%i", xlocation,ylocation)
    }
}

extension Point : Equatable {
    static func == (lhs:Point,rhs:Point) -> Bool {
        return lhs.xlocation == rhs.xlocation && lhs.ylocation == rhs.ylocation
    }
}

extension Point : Comparable {
    static func < (lhs:Point,rhs:Point) -> Bool {
        if lhs.xlocation < rhs.xlocation {
            return true
        }
        if lhs.xlocation > rhs.xlocation {
            return false
        }
        return lhs.ylocation < rhs.ylocation
    }
}

extension Point {
    mutating func set(to value:Point3){
        self.xlocation = value.xlocation
        self.ylocation = value.ylocation
    }
    func distance(to value:Point) -> Double {
        let deltax = value.xlocation - self.xlocation
        let deltay = value.ylocation - self.ylocation
        return sqrt(pow(Double(deltax),2) + pow(Double(deltay),2))
    }
    func distance(to value:Point3) -> Double {
        let deltax = value.xlocation - self.xlocation
        let deltay = value.ylocation - self.ylocation
        return sqrt(pow(Double(deltax),2) + pow(Double(deltay),2))
    }
}

// ==============================================================
// 3D Point
// ==============================================================
struct Point3 : Codable {
    static let zero = Point3(xlocation: 0, ylocation: 0,altitude: 0 )
    var xlocation = 0
    var ylocation = 0
    var altitude = 0
    
    init(xlocation: Int = 0, ylocation: Int = 0, altitude: Int = 0) {
        self.xlocation = xlocation
        self.ylocation = ylocation
        self.altitude = altitude
    }
    
    init(description:String) throws {
        let values = description.components(separatedBy: ",").map{ $0.trimmingCharacters(in: .whitespaces)}
        guard values.count >= 3 else {
            throw GeneralError(errorMessage: "Incorrect amount of arguments",failure: "Description was: \(description)")
        }
        guard let tempx = Int(values[0]) else {
            throw GeneralError(errorMessage: "Invalid arguments",failure: "Description was: \(description)")
        }
        xlocation = tempx
        
        guard let tempy = Int(values[1]) else {
            throw GeneralError(errorMessage: "Invalid arguments",failure: "Description was: \(description)")
        }
        ylocation = tempy
        
        guard let tempz = Int(values[2]) else {
            throw GeneralError(errorMessage: "Invalid arguments",failure: "Description was: \(description)")
        }
        altitude = tempz
    }

    init(point:Point,altitude:Int = 0 ) {
        self.xlocation = point.xlocation
        self.ylocation = point.ylocation
        self.altitude = altitude
    }

}

extension Point3 : CustomStringConvertible {
    var description: String {
        return String(format:"%i,%i,%i", xlocation,ylocation,altitude)
    }
}
extension Point3 : Equatable {
    static func == (lhs:Point3,rhs:Point3) -> Bool {
        return lhs.xlocation == rhs.xlocation && lhs.ylocation == rhs.ylocation && lhs.altitude == rhs.altitude
    }
}

extension Point3 : Comparable {
    static func < (lhs:Point3,rhs:Point3) -> Bool {
        if lhs.xlocation < rhs.xlocation {
            return true
        }
        if lhs.xlocation > rhs.xlocation {
            return false
        }
        if lhs.ylocation < rhs.ylocation {
            return true
        }
        if lhs.ylocation > rhs.ylocation {
            return false
        }
        return lhs.altitude < rhs.altitude
    }
}

extension Point3 {
    mutating func set(to value:Point){
        self.xlocation = value.xlocation
        self.ylocation = value.ylocation
    }
    
    func distance(to value:Point) -> Double {
        let deltax = value.xlocation - self.xlocation
        let deltay = value.ylocation - self.ylocation
        return sqrt(pow(Double(deltax),2) + pow(Double(deltay),2))
    }
    func distance(to value:Point3) -> Double {
        let deltax = value.xlocation - self.xlocation
        let deltay = value.ylocation - self.ylocation
        let deltaz = value.altitude - self.altitude
        let temp = pow(Double(deltax),2) + pow(Double(deltay),2)
        return sqrt(temp + pow(Double(deltaz),2))
    }
}

// ================================================================
// Functions
// ===============================================================

// Equivalent
func == (lhs:Point3,rhs:Point) -> Bool {
    return lhs.xlocation == rhs.xlocation && lhs.ylocation == rhs.ylocation
}
func == (lhs:Point,rhs:Point3) -> Bool {
    return lhs.xlocation == rhs.xlocation && lhs.ylocation == rhs.ylocation
}

// Less then

func < (lhs:Point3,rhs:Point) -> Bool {
    if lhs.xlocation < rhs.xlocation {
        return true
    }
    if lhs.xlocation > rhs.xlocation {
        return false
    }
    return lhs.ylocation < rhs.ylocation
}
func < (lhs:Point,rhs:Point3) -> Bool {
    if lhs.xlocation < rhs.xlocation {
        return true
    }
    if lhs.xlocation > rhs.xlocation {
        return false
    }
    return lhs.ylocation < rhs.ylocation
}

// Distance
func distance(start:Point,end:Point) -> Double {
    return start.distance(to: end)
}
func distance(start:Point3,end:Point3) -> Double {
    return start.distance(to: end)
}
func distance(start:Point,end:Point3) -> Double {
    return start.distance(to: end)
}
func distance(start:Point3,end:Point) -> Double {
    return start.distance(to: end)
}
