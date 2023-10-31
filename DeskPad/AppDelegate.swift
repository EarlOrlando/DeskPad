import Cocoa
import ReSwift

enum AppDelegateAction: Action {
    case didFinishLaunching
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var viewController: ScreenViewController!
    private var location: NSPoint { window.mouseLocationOutsideOfEventStream }

    func applicationDidFinishLaunching(_: Notification) {
        viewController = ScreenViewController()
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
        window.styleMask = [.titled, .closable, .resizable, .miniaturizable]

        let mainMenu = NSMenu()
        let mainMenuItem = NSMenuItem()
        let subMenu = NSMenu(title: "MainMenu")
        let enableMouseTeleportItem = NSMenuItem(
            title: "Teleport mouse cursor to virtual display on click",
            action: #selector(toggleCheckboxMoveCursorItem(_:)),
            keyEquivalent: ""
        )

        // Get last checkbox state
        let isTeleportEnabled = UserDefaults.standard.bool(forKey: "CheckboxState")
        store.dispatch(MouseTeleportAction.located(isTeleportEnabled: isTeleportEnabled))
        enableMouseTeleportItem.state = isTeleportEnabled ? .on : .off

        let quitMenuItem = NSMenuItem(
            title: "Quit",
            action: #selector(NSApp.terminate),
            keyEquivalent: "q"
        )
        subMenu.addItem(enableMouseTeleportItem)
        subMenu.addItem(quitMenuItem)
        mainMenuItem.submenu = subMenu
        mainMenu.items = [mainMenuItem]
        NSApplication.shared.mainMenu = mainMenu

        NSEvent.addLocalMonitorForEvents(matching: [.leftMouseUp]) {
            print("Left mouse up", self.window.mouseLocationOutsideOfEventStream)
            // store.dispatch(MouseTeleportAction.located(isTeleportEnabled: sender.state == .on))
            /*
             // If mouse is not in the title bar
             if self.window.mouseLocationOutsideOfEventStream.y < self.window.contentView!.frame.height {
                 // Move cursor only if menu item is enabled
                 if true {
                     // Move the mouse to the virtual display
                     var newPoint = self.window.mouseLocationOutsideOfEventStream
                     newPoint.x = self.window.mouseLocationOutsideOfEventStream.x * (self.viewController.previousResolution!.width / self.window.frame.size.width)
                     newPoint.y = self.viewController.previousResolution!.height - self.window.mouseLocationOutsideOfEventStream.y * (self.viewController.previousResolution!.height / self.window.contentView!.frame.height)
                     CGDisplayMoveCursorToPoint(self.viewController.display.displayID, newPoint)
                 }
             }*/
            return $0
        }

        /* NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
             print("Mouse moved", self.window.mouseLocationOutsideOfEventStream)
             let mouseLocation = NSEvent.mouseLocation
             let screens = NSScreen.screens
             let screenContainingMouse = (screens.first { NSMouseInRect(mouseLocation, $0.frame, false) })
             let isWithinScreen = screenContainingMouse?.displayID == self.window.screen?.displayID // viewController. displayID// getState()?.screenConfigurationState.displayID
             print("isWithinScreen", isWithinScreen)
             // store.dispatch(MouseTeleportAction.located(isTeleportEnabled: sender.state == .on))
             /*
              // If mouse is not in the title bar
              if self.window.mouseLocationOutsideOfEventStream.y < self.window.contentView!.frame.height {
                  // Move cursor only if menu item is enabled
                  if true {
                      // Move the mouse to the virtual display
                      var newPoint = self.window.mouseLocationOutsideOfEventStream
                      newPoint.x = self.window.mouseLocationOutsideOfEventStream.x * (self.viewController.previousResolution!.width / self.window.frame.size.width)
                      newPoint.y = self.viewController.previousResolution!.height - self.window.mouseLocationOutsideOfEventStream.y * (self.viewController.previousResolution!.height / self.window.contentView!.frame.height)
                      CGDisplayMoveCursorToPoint(self.viewController.display.displayID, newPoint)
                  }
              }*/
             return $0
         } */

        NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
            let mouseLocation = NSEvent.mouseLocation
            let screens = NSScreen.screens

            if let screenContainingMouse = screens.first(where: { NSMouseInRect(mouseLocation, $0.frame, false) }) {
                let isWithinVirtualScreen = screenContainingMouse.displayID == self.viewController.display.displayID
                let isWithinWindowScreen = screenContainingMouse.displayID == self.window.screen!.displayID

                if isWithinVirtualScreen {
                    let screenFrame = screenContainingMouse.frame
                    let borderWidth: CGFloat = 10 // Adjust this value to change the border width
                    let innerRect = NSInsetRect(screenFrame, borderWidth, borderWidth)
                    let isWithinInnerRectangle = NSMouseInRect(mouseLocation, innerRect, false)

                    if isWithinVirtualScreen, !isWithinInnerRectangle {
                        print("Mouse is on the border of the virtual screen")
                        // Move cursor only if menu item is enabled
                        if true {
                            // Move the mouse to the virtual display
                            var newPoint = self.window.mouseLocationOutsideOfEventStream
                            // newPoint.x = self.window.mouseLocationOutsideOfEventStream.x * (self.viewController.previousResolution!.width / self.window.frame.size.width)
                            // newPoint.y = self.viewController.previousResolution!.height - self.window.mouseLocationOutsideOfEventStream.y * (self.viewController.previousResolution!.height / self.window.contentView!.frame.height)
                            CGDisplayMoveCursorToPoint(self.window.screen!.displayID, CGPointZero )
                        }
                    } else {
                        print("Mouse is within the virtual screen")
                    }
                } else if isWithinWindowScreen {
                    if self.window.frame.contains(mouseLocation) {
                        print("Mouse is within the window")
                        // If mouse is not in the title bar
                        if self.window.mouseLocationOutsideOfEventStream.y < self.window.contentView!.frame.height {
                            // Move cursor only if menu item is enabled
                            if true {
                                // Move the mouse to the virtual display
                                var newPoint = self.window.mouseLocationOutsideOfEventStream
                                newPoint.x = self.window.mouseLocationOutsideOfEventStream.x * (self.viewController.previousResolution!.width / self.window.frame.size.width)
                                newPoint.y = self.viewController.previousResolution!.height - self.window.mouseLocationOutsideOfEventStream.y * (self.viewController.previousResolution!.height / self.window.contentView!.frame.height)
                                CGDisplayMoveCursorToPoint(self.viewController.display.displayID, newPoint)
                            }
                        }
                    } else {
                        print("Mouse is within the screen but outside the window")
                    }
                } else {
                    print("Mouse is in another screen")
                }
            }

            // return event
        }

        store.dispatch(AppDelegateAction.didFinishLaunching)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        return true
    }

    func applicationSupportsSecureRestorableState(_: NSApplication) -> Bool {
        return true
    }

    @objc func toggleCheckboxMoveCursorItem(_ sender: NSMenuItem) {
        // Toggle checkbox
        sender.state = (sender.state == .on) ? .off : .on
        store.dispatch(MouseTeleportAction.located(isTeleportEnabled: sender.state == .on))
        UserDefaults.standard.set(sender.state == .on, forKey: "CheckboxState")
    }
}
