public struct EEGSnapshot {
    public let delta: Int
    public let theta: Int
    public let lowAlpha: Int
    public let highAlpha: Int
    public let lowBeta: Int
    public let highBeta: Int
    public let lowGamma: Int
    public let highGamma: Int
    
    public static let allZeros = EEGSnapshot()
    
    public init(dictionary: NSDictionary = [:]) {
        func extractPoint(key: String) -> Int {
            return dictionary[key] as? Int ?? 0
        }
        
        delta = extractPoint("eegDelta")
        theta = extractPoint("eegTheta")
        lowAlpha = extractPoint("eegLowAlpha")
        highAlpha = extractPoint("eegHighAlpha")
        lowBeta = extractPoint("eegLowBeta")
        highBeta = extractPoint("eegHighBeta")
        lowGamma = extractPoint("eegLowGamma")
        highGamma = extractPoint("eegHighGamma")
    }
}


public extension NSDictionary {
    public convenience init(eegSnapshot: EEGSnapshot) {
        self.init(objects: [eegSnapshot.delta, eegSnapshot.theta, eegSnapshot.lowAlpha, eegSnapshot.highAlpha, eegSnapshot.lowBeta, eegSnapshot.highBeta, eegSnapshot.lowGamma, eegSnapshot.highGamma],
            forKeys: ["eegDelta", "eegTheta", "eegLowAlpha", "eegHighAlpha", "eegLowBeta", "eegHighBeta", "eegLowGamma", "eegHighGamma"],
            count: 8)
    }
}
