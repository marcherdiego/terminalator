import SwiftUI

var instance: NSRunningApplication? = nil

struct ContentView: View {
    var body: some View {
        Text("Muy putooo")
            .onAppear {
                PopupWindowController().showWindow(nil)
            }
        
    }
}

struct Popup: View {
    var body: some View {
        Group {
            Text("Gordo putooo")
        }
        .frame(width: 300, height: 100)
        .onAppear {
            registerKeyListener()
        }
    }
}

public func registerKeyListener() {
    NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
        if event.keyCode == 17 {
            openTerminal()
        }
    }
    NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler:myKeyDownEvent)
}

func myKeyDownEvent(event: NSEvent) -> NSEvent {
    if event.keyCode == 17 {
        openTerminal()
    }
    return event
}

func moveCursorPos() {
    let event = CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: CGPoint(x: 100, y: 100), mouseButton: .left)
    event?.post(tap: .cghidEventTap)
}

public func openTerminal() {
    if instance != nil {
        instance?.activate()
    } else {
        let url = NSURL(fileURLWithPath: "/System/Applications/Utilities/Terminal.app", isDirectory: true) as URL
        let path = "/bin"
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.arguments = [path]
        configuration.createsNewApplicationInstance = true
        NSWorkspace.shared.openApplication(at: url, configuration: configuration) { app, error in
            instance = app
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
