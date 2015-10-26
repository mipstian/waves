import UIKit


let MaxDataPoints = 500
let EmptyEEGHistory = Array<EEGSnapshot>(count: MaxDataPoints, repeatedValue: EEGSnapshot.allZeros)


class MainVC: UIViewController {
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var deltaView: WaveView!
    @IBOutlet weak var thetaView: WaveView!
    @IBOutlet weak var lowAlphaView: WaveView!
    @IBOutlet weak var highAlphaView: WaveView!
    @IBOutlet weak var lowBetaView: WaveView!
    @IBOutlet weak var highBetaView: WaveView!
    @IBOutlet weak var lowGammaView: WaveView!
    @IBOutlet weak var highGammaView: WaveView!
    @IBOutlet var waveViews: [WaveView]!
    
    var eegHistory: [EEGSnapshot] = EmptyEEGHistory
    let manager = TGAccessoryManager.sharedTGAccessoryManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSavedHistory()
        
        refreshViews()
        
        manager.setupManagerWithInterval(0.05)
        manager.delegate = self
        manager.rawEnabled = false
        
        startStreamIfPossible()
    }
    
    deinit {
        manager.teardownManager()
    }
    
    func startStreamIfPossible() {
        if manager.accessory != nil {
            manager.startStream()
        }
    }
    
    func refreshViews() {
        statusLabel.text = manager.connected ? manager.accessory.name : "Not connected"
        
        func extractBand(extractValue: EEGSnapshot -> Int) -> [Int] {
            return eegHistory.map(extractValue)
        }
        
        deltaView.points = extractBand { $0.delta }
        thetaView.points = extractBand { $0.theta }
        lowAlphaView.points = extractBand { $0.lowAlpha }
        highAlphaView.points = extractBand { $0.highAlpha }
        lowBetaView.points = extractBand { $0.lowBeta }
        highBetaView.points = extractBand { $0.highBeta }
        lowGammaView.points = extractBand { $0.lowGamma }
        highGammaView.points = extractBand { $0.highGamma }
    }
}


// MARK: Accessory delegate
extension MainVC: TGAccessoryDelegate {
    func dataReceived(data: [NSObject:AnyObject]!) {
        eegHistory.append(EEGSnapshot(dictionary: data as NSDictionary))
        
        // Forget surplus points
        eegHistory.removeRange(0 ..< max(0, eegHistory.count - MaxDataPoints))
        
        saveHistory()
        refreshViews()
    }
    
    func accessoryDidConnect(accessory: EAAccessory!) {
        startStreamIfPossible()
        refreshViews()
    }
    
    func accessoryDidDisconnect() {
        refreshViews()
    }
}


// MARK: History management
extension MainVC {
    func loadSavedHistory() {
        if let dictionaryValues = NSUserDefaults.standardUserDefaults().arrayForKey("eegHistory") {
            eegHistory = dictionaryValues.map { EEGSnapshot(dictionary: $0 as! NSDictionary) }
        }
    }
    
    func saveHistory() {
        let dictionaryValues = eegHistory.map { NSDictionary(eegSnapshot: $0) }
        NSUserDefaults.standardUserDefaults().setObject(dictionaryValues, forKey: "eegHistory")
    }
}


// MARK: Actions
extension MainVC {
    @IBAction func clear(sender: UIButton) {
        eegHistory = EmptyEEGHistory
        refreshViews()
    }
}
