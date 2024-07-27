// Copyright © 2024 Charles Kerr. All rights reserved.

import Foundation

// ==============================================================
// 2D Coordinate
// ==============================================================
struct Coordinate {
    static let zero = Coordinate(xlocation: 0, ylocation: 0)
    var xlocation = 0
    var ylocation = 0
    
    init(xlocation: Int = 0, ylocation: Int = 0) {
        self.xlocation = xlocation
        self.ylocation = ylocation
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

extension Coordinate : CustomStringConvertible {
    var description: String {
        return String(format:"%i,%i", xlocation,ylocation)
    }
}

extension Coordinate {
    mutating func set(to value:Coordinate3){
        self.xlocation = value.xlocation
        self.ylocation = value.ylocation
    }
    func distance(to value:Coordinate) -> Double {
        let deltax = value.xlocation - self.xlocation
        let deltay = value.ylocation - self.ylocation
        return sqrt(pow(Double(deltax),2) + pow(Double(deltay),2))
    }
    func distance(to value:Coordinate3) -> Double {
        let deltax = value.xlocation - self.xlocation
        let deltay = value.ylocation - self.ylocation
        return sqrt(pow(Double(deltax),2) + pow(Double(deltay),2))
    }
}

// ==============================================================
// 3D Coordinate
// ==============================================================
struct Coordinate3 {
    static let zero = Coordinate3(xlocation: 0, ylocation: 0,altitude: 0 )
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
    
}

extension Coordinate3 : CustomStringConvertible {
    var description: String {
        return String(format:"%i,%i,%i", xlocation,ylocation,altitude)
    }
}

extension Coordinate3 {
    mutating func set(to value:Coordinate){
        self.xlocation = value.xlocation
        self.ylocation = value.ylocation
    }
    
    func distance(to value:Coordinate) -> Double {
        let deltax = value.xlocation - self.xlocation
        let deltay = value.ylocation - self.ylocation
        return sqrt(pow(Double(deltax),2) + pow(Double(deltay),2))
    }
    func distance(to value:Coordinate3) -> Double {
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

func == (lhs:Coordinate3,rhs:Coordinate) -> Bool {
    return lhs.xlocation == rhs.xlocation && lhs.ylocation == rhs.ylocation
}
func == (lhs:Coordinate,rhs:Coordinate3) -> Bool {
    return lhs.xlocation == rhs.xlocation && lhs.ylocation == rhs.ylocation
}
func == (lhs:Coordinate3,rhs:Coordinate3) -> Bool {
    return lhs.xlocation == rhs.xlocation && lhs.ylocation == rhs.ylocation && lhs.altitude == rhs.altitude
}
func == (lhs:Coordinate,rhs:Coordinate) -> Bool {
    return lhs.xlocation == rhs.xlocation && lhs.ylocation == rhs.ylocation
}

func < (lhs:Coordinate,rhs:Coordinate) -> Bool {
    return  lhs.xlocation < rhs.xlocation
}

func distance(start:Coordinate,end:Coordinate) -> Double {
    return start.distance(to: end)
}
func distance(start:Coordinate3,end:Coordinate3) -> Double {
    return start.distance(to: end)
}
func distance(start:Coordinate,end:Coordinate3) -> Double {
    return start.distance(to: end)
}
func distance(start:Coordinate3,end:Coordinate) -> Double {
    return start.distance(to: end)
}
