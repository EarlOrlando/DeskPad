import Cocoa
import ReSwift

enum AppDelegateAction: Action {
    case didFinishLaunching
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_: Notification) {
        let viewController = ScreenViewController()
        window = NSWindow(contentViewController: viewController)
        window.title = "DeskPad"
        window.makeKeyAndOrderFront(nil)
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.titleVisibility = .hidden
        window.backgroundColor = .white
        window.acceptsMouseMovedEvents = true
        window.contentMinSize = CGSize(width: 400, height: 300)
        window.contentMaxSize = CGSize(width: 3840, height: 2160)

        let mainMenu = NSMenu()
        let mainMenuItem = NSMenuItem()
        let subMenu = NSMenu(title: "MainMenu")

        // Menu item for isTeleportEnabled
        let enableMouseTeleportMenuItem = NSMenuItem(
            title: "Enable mouse teleport to virtual display on click",
            action: #selector(toggleMouseTeleportEnable(_:)),
            keyEquivalent: ""
        )

        if UserDefaults.standard.object(forKey: "isTeleportEnabled") == nil {
            UserDefaults.standard.set(true, forKey: "isTeleportEnabled")
        }

        let isTeleportEnabled = UserDefaults.standard.bool(forKey: "isTeleportEnabled")
        enableMouseTeleportMenuItem.state = isTeleportEnabled ? .on : .off

        // Menu item for isWindowResizeAllowed
        let enableWindowResizeMenuItem = NSMenuItem(
            title: "Enable ability to resize the window",
            action: #selector(toggleWindowResizeEnable(_:)),
            keyEquivalent: ""
        )

        if UserDefaults.standard.object(forKey: "isWindowResizeAllowed") == nil {
            UserDefaults.standard.set(true, forKey: "isWindowResizeAllowed")
        }

        let isWindowResizeAllowed = UserDefaults.standard.bool(forKey: "isWindowResizeAllowed")
        enableWindowResizeMenuItem.state = isWindowResizeAllowed ? .on : .off

        let resetWindowSizeMenuItem = NSMenuItem(
            title: "Reset window size to match the original resolution",
            action: #selector(resetWindowSize(_:)),
            keyEquivalent: ""
        )

        // Menu item for quit application
        let quitMenuItem = NSMenuItem(
            title: "Quit",
            action: #selector(NSApp.terminate),
            keyEquivalent: "q"
        )
        subMenu.addItem(enableMouseTeleportMenuItem)
        subMenu.addItem(enableWindowResizeMenuItem)
        subMenu.addItem(resetWindowSizeMenuItem)
        subMenu.addItem(quitMenuItem)
        mainMenuItem.submenu = subMenu
        mainMenu.items = [mainMenuItem]
        NSApplication.shared.mainMenu = mainMenu

        NSEvent.addLocalMonitorForEvents(matching: [.leftMouseUp]) {
            store.dispatch(MouseLocationEvent.localMouseClicked(mouseLocation: NSEvent.mouseLocation, event: $0))
            return $0
        }

        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
            store.dispatch(MouseLocationEvent.localMouseMoved(mouseLocation: NSEvent.mouseLocation, event: $0))
            return $0
        }

        NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) {
            store.dispatch(MouseLocationEvent.globalMouseMoved(mouseLocation: NSEvent.mouseLocation, event: $0))
        }

        store.dispatch(MouseLocationAction.setWindow(window: window))
        store.dispatch(MouseLocationSettings.enableTeleport(isTeleportEnabled: isTeleportEnabled))
        store.dispatch(MouseLocationSettings.enableWindowResize(isWindowResizeAllowed: isWindowResizeAllowed))
        store.dispatch(AppDelegateAction.didFinishLaunching)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        return true
    }

    func applicationSupportsSecureRestorableState(_: NSApplication) -> Bool {
        return true
    }

    @objc func toggleMouseTeleportEnable(_ sender: NSMenuItem) {
        sender.state = (sender.state == .on) ? .off : .on
        UserDefaults.standard.set(sender.state == .on, forKey: "isTeleportEnabled")
        store.dispatch(MouseLocationSettings.enableTeleport(isTeleportEnabled: sender.state == .on))
    }

    @objc func toggleWindowResizeEnable(_ sender: NSMenuItem) {
        sender.state = (sender.state == .on) ? .off : .on
        UserDefaults.standard.set(sender.state == .on, forKey: "isWindowResizeAllowed")
        store.dispatch(MouseLocationSettings.enableWindowResize(isWindowResizeAllowed: sender.state == .on))
    }

    @objc func resetWindowSize(_: NSMenuItem) {
        store.dispatch(MouseLocationSettings.resetWindowSize)
    }
}
