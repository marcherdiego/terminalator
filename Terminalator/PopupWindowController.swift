import Foundation
import AppKit
import SwiftUI

class PopupWindowController: NSWindowController {
    init() {
        let window = NSWindow(
            contentRect: NSRect(x:0,y:0,width: 360,height: 180),
            styleMask: [.fullSizeContentView, .titled],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.level = .floating
        let contentView  = Popup()
        window.contentView = NSHostingView(rootView: contentView)
        PopupWindowController.acquireAccessibilityPrivileges(
            window: window,
            acquired: {
            },
            nope: {
            }
        )

        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func acquireAccessibilityPrivileges(window: NSWindow, acquired: @escaping () -> Void, nope: @escaping () -> Void) {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true]
        let enabled = AXIsProcessTrustedWithOptions(options as CFDictionary)

        if enabled {
            acquired()
        } else {
            let alert = NSAlert()
            alert.messageText = "Enable Terminalator"
            alert.informativeText = "Click OK once you enabled Terminalator in System Preferences - Security & Privacy -> Accessibility and Input Monitoring"
            alert.beginSheetModal(for: window, completionHandler: { response in
                if AXIsProcessTrustedWithOptions(options as CFDictionary) {
                    acquired()
                } else {
                    nope()
                }
            })
        }
    }
}
