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
        window.delegate = viewController
        window.title = "DeskPad"
        window.makeKeyAndOrderFront(nil)
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.titleVisibility = .hidden
        window.backgroundColor = .white
        window.contentMinSize = CGSize(width: 400, height: 300)
        window.contentMaxSize = CGSize(width: 3840, height: 2160)
        window.collectionBehavior.insert(.fullScreenNone)

        let mainMenu = NSMenu()
        let mainMenuItem = NSMenuItem()
        let subMenu = NSMenu(title: "MainMenu")

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
        subMenu.addItem(enableWindowResizeMenuItem)
        // Apply current state
        if isWindowResizeAllowed {
            window.styleMask.insert(.resizable)
        } else {
            window.styleMask.remove(.resizable)
        }

        // Menu item for quit application
        let quitMenuItem = NSMenuItem(
            title: "Quit",
            action: #selector(NSApp.terminate),
            keyEquivalent: "q"
        )
        subMenu.addItem(quitMenuItem)
        mainMenuItem.submenu = subMenu
        mainMenu.items = [mainMenuItem]
        NSApplication.shared.mainMenu = mainMenu

        store.dispatch(AppDelegateAction.didFinishLaunching)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        return true
    }

    @objc func toggleWindowResizeEnable(_ sender: NSMenuItem) {
        sender.state = (sender.state == .on) ? .off : .on
        UserDefaults.standard.set(sender.state == .on, forKey: "isWindowResizeAllowed")
        if sender.state == .on {
            window.styleMask.insert(.resizable)
        } else {
            window.styleMask.remove(.resizable)
        }
    }
}
