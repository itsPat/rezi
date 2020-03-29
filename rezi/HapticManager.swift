//
//  HapticManager.swift
//  rezi
//
//  Created by Pat Trudel on 2020-03-29.
//  Copyright © 2020 Pat Trudel. All rights reserved.
//

import UIKit

class HapticManager: NSObject {
    static let shared = HapticManager()
    
    let lightHaptic = UIImpactFeedbackGenerator(style: .light)
    let mediumHaptic = UIImpactFeedbackGenerator(style: .medium)
    let heavyHaptic = UIImpactFeedbackGenerator(style: .heavy)
    let notifHaptic = UINotificationFeedbackGenerator()
    var lastFired = TimeInterval()
    
    override init() {
        lightHaptic.prepare()
        mediumHaptic.prepare()
        heavyHaptic.prepare()
        notifHaptic.prepare()
    }
    
    func fire(impactStyle: UIImpactFeedbackGenerator.FeedbackStyle?, notifStyle: UINotificationFeedbackGenerator.FeedbackType?,  intensity: CGFloat?) {

        DispatchQueue.main.async { [weak self] in
            guard let s = self else { return }
            guard CACurrentMediaTime() - s.lastFired > 0.1 else { return }
            s.lastFired = CACurrentMediaTime()
            if let impactStyle = impactStyle {
                    switch impactStyle {
                    case .light:
                        if #available(iOS 13.0, *) {
                            s.lightHaptic.impactOccurred(intensity: intensity ?? 1.0)
                        } else {
                            s.lightHaptic.impactOccurred()
                        }
                    case .medium:
                        if #available(iOS 13.0, *) {
                            s.mediumHaptic.impactOccurred(intensity: intensity ?? 1.0)
                        } else {
                            s.mediumHaptic.impactOccurred()
                        }
                    case .heavy:
                        if #available(iOS 13.0, *) {
                            s.heavyHaptic.impactOccurred(intensity: intensity ?? 1.0)
                        } else {
                            s.heavyHaptic.impactOccurred()
                        }
                    default:
                        break
                    }
            } else if let notifStyle = notifStyle {
                s.notifHaptic.notificationOccurred(notifStyle)
            }
        }
        
    }
}
