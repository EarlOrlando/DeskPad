import Cocoa
import ReSwift

enum AppDelegateAction: Action {
    case didFinishLaunching
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var viewController: ScreenViewController!

    func applicationDidFinishLaunching(_: Notification) {
        viewController = ScreenViewController()
        window = NSWindow(contentViewController: viewController)
        window.title = "DeskPad"
        window.makeKeyAndOrderFront(nil)
        window?.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.titleVisibility = .hidden
        window.backgroundColor = .white
        window.acceptsMouseMovedEvents = true

        let mainMenu = NSMenu()
        let mainMenuItem = NSMenuItem()
        let subMenu = NSMenu(title: "MainMenu")
        let checkboxMoveCursorItem = NSMenuItem(
            title: "Move cursor to virtual display on click",
            action: #selector(toggleCheckboxMoveCursorItem(_:)),
            keyEquivalent: ""
        )

        // Get last checkbox state
        viewController.moveCursorItemOnClick = UserDefaults.standard.bool(forKey: "CheckboxState")
        checkboxMoveCursorItem.state = viewController.moveCursorItemOnClick ? .on : .off

        let quitMenuItem = NSMenuItem(
            title: "Quit",
            action: #selector(NSApp.terminate),
            keyEquivalent: "q"
        )
        subMenu.addItem(checkboxMoveCursorItem)
        subMenu.addItem(quitMenuItem)
        mainMenuItem.submenu = subMenu
        mainMenu.items = [mainMenuItem]
        NSApplication.shared.mainMenu = mainMenu

        store.dispatch(AppDelegateAction.didFinishLaunching)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        return true
    }

    @objc func toggleCheckboxMoveCursorItem(_ sender: NSMenuItem) {
        // Toggle checkbox
        sender.state = (sender.state == .on) ? .off : .on
        UserDefaults.standard.set(sender.state == .on, forKey: "CheckboxState")

        if sender.state == .on {
            // Checkbox is selected.
            viewController.moveCursorItemOnClick = true
        } else {
            // Checkbox is not selected.
            viewController.moveCursorItemOnClick = false
        }
    }
}
