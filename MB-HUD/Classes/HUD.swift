//
//  HUD.swift
//  SwiftTest
//
//  Created by AlphaTest on 2020/8/3.
//  Copyright © 2020 523. All rights reserved.
//

import Foundation
import MBProgressHUD

fileprivate func RGBHex(_ rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

fileprivate let MAINSCREEN_SIZE  = UIScreen.main.bounds
fileprivate let MAINSCREEN_WIDTH  = MAINSCREEN_SIZE.size.width
fileprivate let MAINSCREEN_HEIGHT = MAINSCREEN_SIZE.size.height


public protocol HUD where Self: UIView {
    
}

public extension HUD {
    
    func showHudoldon(_ msg: String? = nil) {
        let existHud = MBProgressHUD.forView(self)
        guard existHud == nil else {
            return
        }
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.mode = .indeterminate
        hud.backgroundView.color = RGBHex(0xf5f5f5)
        hud.backgroundView.style = .solidColor
        hud.bezelView.color = .clear
        hud.bezelView.style = .solidColor
        if msg != nil {
            hud.detailsLabel.text = msg
        }
    }
    
    func showBgHudHoldon() {
        let hud = MBProgressHUD.showAdded(to: self, animated: true);
        hud.mode = .customView;
        hud.customView = { () -> HUDView in
            let loadView = HUDView(frame: CGRect(x: MAINSCREEN_WIDTH-144, y: 0, width: 144, height: 50))
            loadView.backgroundColor = .black
            let indicator = {() -> UIActivityIndicatorView in
                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
                indicator.startAnimating()
                indicator.frame = CGRect(x: 16, y: 13, width: 24, height: 24)
                return indicator
            }()
            loadView.addSubview(indicator)
            let label = { () -> UILabel in
                let label = UILabel(frame: CGRect(x: indicator.frame.origin.x + 34, y: 17.5, width: 70, height: 15))
                label.text = "正在加载中"
                label.font = UIFont.systemFont(ofSize: 12)
                label.textColor = .white
                return label
            }()
            loadView.addSubview(label)
            return loadView
        }();
        hud.customView?.layer.cornerRadius = 3;
        hud.backgroundView.color = UIColor.black.withAlphaComponent(0.3);
        hud.backgroundView.style = .solidColor;
        hud.bezelView.color = .clear;
        hud.bezelView.style = .solidColor;
    }
    
    func showHud(msg: String?, duration: TimeInterval = 1.5, complete: (() -> Void)? = nil) {
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.mode = .text
        hud.bezelView.color = .black
        hud.bezelView.style = .solidColor
        hud.detailsLabel.text = msg
        hud.detailsLabel.textColor = .white
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 14)
        hud.margin = 17
        hud.hide(animated: true, afterDelay: duration)
        if (complete != nil) {
            hud.completionBlock = {
                complete?()
            }
        }
    }
    
    func dismissHud(msg: String? = nil, complete: (() -> Void)? = nil) {
        if msg == nil && complete == nil {
            MBProgressHUD.hide(for: self, animated: true)
            return
        }
        if msg == nil {
            let hud = MBProgressHUD.forView(self)
            hud?.completionBlock = {
                complete?()
            }
            hud?.hide(animated: true)
        } else {
            let hud = MBProgressHUD.forView(self)
            hud?.hide(animated: true, afterDelay: 0)
            self.showHud(msg: msg, complete: complete)
        }
    }
    
}


public extension HUD where Self: HUDView {
    
    static var keywindow: UIWindow {
        return UIApplication.shared.keyWindow!
    }
    
    static func showHud(_ msg: String? = nil) {
        let hud = MBProgressHUD.forView(Self.keywindow)
        if hud != nil {
            return
        }
        Self.keywindow.showHudoldon(msg)
    }
    
    static func showClearHudHoldon() {
        MBProgressHUD.hide(for: Self.keywindow, animated: true)
        let hud = MBProgressHUD.showAdded(to: Self.keywindow, animated: true)
        hud.mode = .indeterminate
        hud.backgroundView.color = UIColor.clear
        hud.backgroundView.style = .solidColor
        hud.bezelView.color = RGBHex(0xf5f5f5)
        hud.bezelView.style = .solidColor
    }
    
    static func showBgHudHoldon() {
        let hud = MBProgressHUD.forView(Self.keywindow)
        if hud != nil {
            return
        }
        Self.keywindow.showBgHudHoldon()
    }
        
    static func showHud(msg: String?, duration: TimeInterval = 1.5, complete: (() -> Void)? = nil) {
        Self.keywindow.showHud(msg: msg, duration: duration, complete: complete)
    }
    
    static func dismissHud(msg: String? = nil, complete: (() -> Void)? = nil) {
        Self.keywindow.dismissHud(msg: msg, complete: complete)
    }
    
}

public class HUDView: UIView {

    public override var intrinsicContentSize: CGSize {
        return self.frame.size
    }
    
}

extension UIView : HUD {
    
}
