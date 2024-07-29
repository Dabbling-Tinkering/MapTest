// Copyright © 2024 Charles Kerr. All rights reserved.

import Foundation

struct MapCell : Codable {
    var location = Point3.zero
    var tileID = 0
    init(location: Point3 = Point3.zero, tileID: Int = 0) {
        self.location = location
        self.tileID = tileID
    }
    
    var xml:XMLElement {
        let element = XMLElement(name: "mapCell")
        var node = XMLNode(kind: .attribute)
        node.name = "location"
        node.stringValue = location.description
        element.addAttribute(node)
        
        node = XMLNode(kind: .attribute)
        node.name = "tileID"
        node.stringValue = String(tileID)
        element.addAttribute(node)
        return element
    }
    init(element:XMLElement) throws {
        guard element.name?.lowercased() == "mapcell" else {
            throw GeneralError(errorMessage: "Invalid element name for MapCell: \(element.name ?? "")")
        }
        var node = element.attribute(forName: "location")
        guard node?.stringValue != nil else {
            throw GeneralError(errorMessage: "MapCell missing location")
        }
        location = try Point3(description: node!.stringValue!)
    
        node = element.attribute(forName: "tileID")
        guard node?.stringValue != nil else {
            throw GeneralError(errorMessage: "MapCell missing tileID")
        }
        guard let temp = Int(node!.stringValue!) else {
            throw GeneralError(errorMessage: "Invalid tileID \(node!.stringValue!) for MapCell")
        }
        tileID = temp 
    }
}

extension MapCell : Equatable {
    static func == (lhs:MapCell,rhs:MapCell) -> Bool {
        return lhs.location == rhs.location && lhs.tileID == rhs.tileID
    }
}

extension MapCell : Comparable {
    static func < (lhs:MapCell,rhs:MapCell) -> Bool {
        return lhs.location < rhs.location
    }
}
