//
//  AuxBank.swift
//  BoatSchool
//
//  Created by Zach Venanzi on 3/29/21.
//

import Foundation

struct Section {
    var name: String
    var lowerBound: Int
    var upperBound: Int
    
    init(_ name: String, _ lower: Int, _ upper: Int) {
        self.name = name
        self.lowerBound = lower
        self.upperBound = upper
    }
}

struct Contents {
    static var subjects = ["General Subjects","Refrigeration","Safety","Gas Turbines","Steam Plants","Motor Plants","Electricity","Electronics and Control Engineering"]
    static var generalSubjectsSubs: [Section] = [
        Section("Blueprints", 1, 56),
        Section("Drawing", 57, 93),
        Section("Piping", 94, 146),
        Section("Piping Symbols and Systems", 147, 165),
        Section("Pipe Fittings", 159, 169),
        Section("Tubing", 170, 179),
        Section("Conversion Factors", 181, 198),
//        "Screwdrivers": [199...215],
//        "Files": [216...255],
//        "Chisels": [256...263],
//        "Saws": [264...299],
//        "Drills": [300...335],
//        "Taps and Dies" : [336...364],
//        "Screw Threads and Fasteners":[365...400],
//        "Miscellaneous Tools" : [401...456],
//        "Measuring Tools (Shop)" :[457...557],
//        "Lathe Operations" :[578...673],
//        "Heat Treatment":[674...681],
//        "Non-Destructive Testing":[682...687],
//        "Soldering":[688...698],
//        "Welding":[699...766],
//        "Packing and Gaskets":[767...791],
//        "Mechanical Seals":[792...794],
//        "Valves":[795...902],
//        "Power Operated Valves":[903...909],
//        "Taps, Drains, and Strainers":[910...945],
//        "Centrifugal Pump Design":[946...1085],
//        "Centrifugal Pump Operation":[1086...1180],
//        "Reciprocating Pumps":[1181...1212],
//        "Reciprocating Pump Problems":[1213...1227],
//        "Rotary Pumps":[1228...1254],
//        "Jet Pumps":[1255...1258],
//        "Miscellaneous Pumps":[1259...1278],
//        "Air Compressors":[1279...1398],
//        "Air Compressor Trouble Shooting":[1399...1433],
//        "Heat Exchangers":[1434...1500],
//        "Steam Systems":[1501...1528],
//        "Fresh Water Drains":[1529...1540],
//        "Contaminated Drains":[1541...1560],
//        "Bilge and Ballast Systems":[1561...1619],
//        "Oily Water Separator":[1620...1687],
//        "Sanitary and Sewage Systems":[1688...1714],
//        "Potable Water Systems":[1715...1744],
//        "Saltwater Systems":[1745...1757],
//        "Condensers":[1758...1812],
//        "Air Ejectors":[1813...1837],
//        "Feed Heaters":[1838...1861],
//        "D.C. Heaters":[1862...1893],
//        "Feed Pumps":[1894...1906],
//        "Feed Water Systems":[1907...1933],
//        "Flash Evaporators":[1934...2070],
//        "Submerged Tube Evaporators":[2071...2092],
//        "Miscellaneous Evaporators":[2093...2118],
//        "Evaporator Salinity":[2119...2141],
//        "Evaporators, Special":[2142...2161],
//        "Hydraulic Systems":[2162...2205],
//        "Hydraulic Flow Control Devices":[2206...2254],
//        "Hydraulic System Components":[2255...2292],
//        "Hydraulic Hose and Piping":[2293...2326],
//        "Hydraulic Accumulators":[2327...2340],
//        "Hydraulic Pumps, Motors, Rams":[2341...2394],
//        "Hydraulic Fluid":[2395...2431],
//        "Hydraulic System Operation":[2414...2464],
//        "Steering Gear":[2465...2490],
//        "Steering Gear Control Devices":[2491...2544],
//        "Steering Gear Operation":[2545...2573],
//        "Steering Gear Regs":[2574...2592],
//        "Propellers":[2593...2618],
//        "Controllable Pitch Propellers":[2619...2625],
//        "Propulsors, Thrusters":[2626...2642],
//        "Incinerators":[2643...2648],
//        "Deck Machinery":[2649...2712],
//        "Ball and Roller Bearings":[2713...2754],
//        "Grease":[2755...2781],
//        "Corrosion, Cathodic Protection":[2782...2798],
//        "Ship Construction":[2799...2963],
//        "Oil Tanks":[2964...2996],
//        "Tank Cleaning":[2997...3023],
//        "Oil Tank Vents":[3024...3036],
//        "Oil Transfer Operations":[3037...3200],
//        "Fuel and Cargo Hoses":[3201...3216],
//        "Inert Gas":[3217...3254],
//        "LNG":[3255...3280],
//        "Supply Boat Operations":[3281...3305],
//        "International Regulations":[3306...3309],
//        "Maintneance Management":[3310...3319],
//        "Watchstanding, Machinery Operation":[3320...3338],
//        "Vessel Security":[3339...3339],
//        "Training":[3340...3361],
//        "Leadership, Managment, ERM":[3362...3432],
//        "Calculations":[3433...3526]
    ]
}
