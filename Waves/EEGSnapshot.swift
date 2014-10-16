public struct EEGSnapshot {
    public let delta: Int = 0
    public let theta: Int = 0
    public let lowAlpha: Int = 0
    public let highAlpha: Int = 0
    public let lowBeta: Int = 0
    public let highBeta: Int = 0
    public let lowGamma: Int = 0
    public let highGamma: Int = 0
    
    public static let allZeros = EEGSnapshot()
    
    private init(){}
    
    public init(dictionary: NSDictionary) {
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
