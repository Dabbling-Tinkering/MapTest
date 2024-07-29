// Copyright © 2024 Charles Kerr. All rights reserved.

import Foundation

// ==============================================================
// Size
// ==============================================================

struct Size : Codable {
    static let zero = Size(width: 0, length: 0)
    var width = 0
    var length = 0
    init(width: Int = 0, length: Int = 0) {
        self.width = width
        self.length = length
    }
    
    init(description:String) throws {
        let values = description.components(separatedBy: ",").map{ $0.trimmingCharacters(in: .whitespaces)}
        guard values.count >= 2 else {
            throw GeneralError(errorMessage: "Incorrect amount of arguments",failure: "Description was: \(description)")
        }
        guard let tempw = Int(values[0]) else {
            throw GeneralError(errorMessage: "Invalid arguments",failure: "Description was: \(description)")
        }
        width = tempw
        
        guard let templ = Int(values[1]) else {
            throw GeneralError(errorMessage: "Invalid arguments",failure: "Description was: \(description)")
        }
        length = templ
    }
    var area:Int {
        return width * length
    }
    
}

extension Size : CustomStringConvertible {
    var description: String {
        return String(format:"%i,%i",width,length)
    }
}

extension Size : Equatable {
    static func == (lhs:Size,rhs:Size) -> Bool {
        return lhs.length == rhs.length && lhs.width == rhs.width
    }

}

extension Size : Comparable {
    static func < (lhs:Size,rhs:Size) -> Bool {
        return lhs.area < rhs.area
    }

}

extension Size {
    mutating func set(to value:Size) {
        self.width = value.width
        self.length = value.length
    }
}


// ==============================================================
// Rectangle
// ==============================================================

struct Rectangle : Codable {
    static let zero = Rectangle()
    var origin = Point.zero
    var size = Size.zero
    
    init(origin: Point = Point.zero, size: Size = Size.zero) {
        self.origin = origin
        self.size = size
    }
    init(x:Int,y:Int,width:Int,length:Int) {
        origin = Point(xlocation: x, ylocation: y)
        size = Size(width: width, length: length)
    }
    init(description:String) throws {
        let values = description.components(separatedBy: ":").map{ $0.trimmingCharacters(in: .whitespaces)}
        guard values.count >= 2 else {
            throw GeneralError(errorMessage: "Incorrect amount of arguments",failure: "Description was: \(description)")
        }
        self.origin = try Point(description: values[0])
        self.size = try Size(description: values[1])
    }
    
}

extension Rectangle : CustomStringConvertible {
    var description: String {
        return String(format: "%@:%@", origin.description,size.description)
    }
}

extension Rectangle : Comparable {
    static func == (lhs:Rectangle,rhs:Rectangle) -> Bool {
        return lhs.origin == rhs.origin && lhs.size == rhs.size
    }
}

extension Rectangle {
    var area:Int {
        return size.area
    }
    
    func contains(point:Point,inclusive:Bool = false) -> Bool {
        if !inclusive {
            if point.xlocation > self.origin.xlocation && point.ylocation > self.origin.ylocation {
                if point.xlocation < self.origin.xlocation + size.width && point.ylocation < self.origin.ylocation + size.length {
                    return true
                }
            }
        }
        else {
            if point.xlocation >= self.origin.xlocation && point.ylocation >= self.origin.ylocation {
                if point.xlocation <= self.origin.xlocation + size.width && point.ylocation <= self.origin.ylocation + size.length {
                    return true
                }
            }

        }
        return false
    }
    func contains(point:Point3,inclusive:Bool = false) -> Bool {
        if !inclusive {
            if point.xlocation > self.origin.xlocation && point.ylocation > self.origin.ylocation {
                if point.xlocation < self.origin.xlocation + size.width && point.ylocation < self.origin.ylocation + size.length {
                    return true
                }
            }
        }
        else {
            if point.xlocation >= self.origin.xlocation && point.ylocation >= self.origin.ylocation {
                if point.xlocation <= self.origin.xlocation + size.width && point.ylocation <= self.origin.ylocation + size.length {
                    return true
                }
            }

        }
        return false
    }
    func contains(rect:Rectangle, inclusive:Bool = false) -> Bool {
        if !inclusive {
            if (self.origin.xlocation < rect.origin.xlocation) && ( (self.origin.xlocation + self.size.width) > (rect.origin.xlocation + rect.size.width) ) && ( self.origin.ylocation < rect.origin.ylocation ) && ( (self.origin.ylocation + self.size.length) > (rect.origin.ylocation + rect.size.length) ) {
                return true
            }
        }
        else {
            if (self.origin.xlocation <= rect.origin.xlocation) && ( (self.origin.xlocation + self.size.width) >= (rect.origin.xlocation + rect.size.width) ) && ( self.origin.ylocation <= rect.origin.ylocation ) && ( (self.origin.ylocation + self.size.length) >= (rect.origin.ylocation + rect.size.length) ) {
                return true
            }
        }
        return false
                
    }
    
    func isSmaller(rect:Rectangle) -> Bool {
        return self.area < rect.area
    }
    
    func intersects(rect:Rectangle) -> Bool {
        if ((self.origin.xlocation < rect.origin.xlocation) && ( (self.origin.xlocation + self.size.width) > rect.origin.xlocation ))  || ((self.origin.ylocation < rect.origin.ylocation) && ( (self.origin.ylocation + self.size.length) > rect.origin.ylocation ))  ||  ( (self.origin.xlocation > rect.origin.xlocation) && self.origin.xlocation < (rect.origin.xlocation  + rect.size.width)) ||  ( (self.origin.ylocation > rect.origin.ylocation) && self.origin.ylocation < (rect.origin.ylocation  + rect.size.length)){
            return true
        }
        return false
    }

}


func < (lhs:Rectangle,rhs:Rectangle) ->Bool {
    return lhs.origin.xlocation < rhs.origin.xlocation
}


// =================================================================
// Area
// =================================================================

struct Area : Codable {
    var locations = [Rectangle]()
}

extension Area {
    func contains(point:Point) -> Bool {
        for rect in locations {
            if rect.contains(point: point) {
                return true
            }
        }
        return false
    }
    func contains(point:Point3) -> Bool {
        for rect in locations {
            if rect.contains(point: point) {
                return true
            }
        }
        return false
    }
}
