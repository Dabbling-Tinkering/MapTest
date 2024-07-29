// Copyright © 2024 Charles Kerr. All rights reserved.

import Foundation

class Map  : Codable {
    var name:String?
    var size = Size.zero
    var mapCells = [MapCell]()
    
    init(name:String? = nil, size:Size = Size.zero ) {
        self.name = name
        self.size = size
        mapCells.reserveCapacity(size.width * size.length)
        for y in 0..<size.length {
            for x in 0..<size.width{
                mapCells.append(MapCell(location: Point3(xlocation: x, ylocation: y, altitude: 0)))
            }
        }
    }
    
    init(name: String? , size:Size , mapCells: [MapCell] ) throws {
        self.name = name
        self.size = size
        guard size.area == mapCells.count else {
            throw GeneralError(errorMessage: "Map \(name ?? "") size and cell mismatch")
        }
        self.mapCells = mapCells
    }
    
    var xml:XMLElement {
        let element = XMLElement(name: "map")
        
        var node = XMLNode(kind: .attribute)
        node.name = "name"
        node.stringValue = self.name
        if name != nil {
            element.addAttribute(node)
        }
        node = XMLNode(kind: .attribute)
        node.name = "size"
        node.stringValue = size.description
        element.addAttribute(node)
        for cell in mapCells {
            element.addChild(cell.xml)
        }
        return element
    }
    init(element:XMLElement) throws {
        guard element.name?.lowercased() == "map" else {
            throw GeneralError(errorMessage: "Invalid element for Map: \(element.name ?? "")")
        }
        var node = element.attribute(forName: "name")
        if node?.stringValue != nil {
            self.name = node?.stringValue
        }
        
        node = element.attribute(forName: "size")
        guard node?.stringValue != nil else {
            throw GeneralError(errorMessage: "Map \(self.name ?? "") is missing size")
        }
        size = try Size(description: node!.stringValue!)
        var temp = [MapCell]()
        temp.reserveCapacity(size.width * size.length)
        for child in element.elements(forName: "mapCell") {
            temp.append( try MapCell(element: child))
        }
        mapCells = temp.sorted()
    }
}

extension Map {
    static func mapFor(element:XMLElement) throws -> Map {
        return Map()
    }
    
    static func loadMap(url:URL) throws -> Map {
        let doc = try XMLDocument(contentsOf: url,options: .documentTidyXML)
        guard let root = doc.rootElement() else {
            throw GeneralError(errorMessage: "\(url.lastPathComponent) missing root element")
        }
        guard root.name?.lowercased() == "map" else {
            throw GeneralError(errorMessage: "\(url.lastPathComponent) invalid map file")
        }
        return try Map(element: root)
    }
    
    func save(to url:URL) throws {
        let doc = XMLDocument(rootElement: self.xml)
        try doc.xmlData(options: .nodePrettyPrint).write(to: url)
    }
    
    func indexFor(point:Point) -> Int {
        return size.width * point.ylocation + point.xlocation
    }
    func boundedIndexFor(point:Point) -> Int? {
        let index = size.width * point.ylocation + point.xlocation
        guard index <= mapCells.count else { return nil }
        return index
    }
    func mapCell(for point:Point) -> MapCell? {
        let index = indexFor(point: point)
        guard index <= mapCells.count else { return nil }
        return mapCells[index]
    }
    
    func mapCellAltitude(for point:Point) -> (MapCell?,[Int]) {
        let index = indexFor(point: point)
        guard index < mapCells.count else { return (nil,[Int]()) }
        let altitude = mapCells[index].location.altitude
        
        var alts = [Int]()
        // Get the one to right
        let rightIndex = boundedIndexFor(point: Point(xlocation: point.xlocation+1, ylocation: point.ylocation))
        var rightAltitude = altitude
        if rightIndex != nil {
            rightAltitude = mapCells[rightIndex!].location.altitude
        }
        let lowerRightIndex = boundedIndexFor(point: Point(xlocation: point.xlocation+1, ylocation: point.ylocation + 1))
        var lowerRightAltitude = altitude
        if lowerRightIndex != nil {
            lowerRightAltitude = mapCells[lowerRightIndex!].location.altitude
        }
        let lowerIndex = boundedIndexFor(point: Point(xlocation: point.xlocation, ylocation: point.ylocation + 1))
        var lowerAltitude = altitude
        if lowerIndex != nil {
            lowerAltitude = mapCells[lowerIndex!].location.altitude
        }
        
        
    }
}
