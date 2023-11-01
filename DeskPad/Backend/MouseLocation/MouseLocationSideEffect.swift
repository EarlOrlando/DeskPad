import Foundation
import ReSwift

enum MouseLocationAction: Action {
    case located(isWithinVirtualDisplay: Bool)
    case setWindow(window: NSWindow)
    case update(screenContainingMouse: NSScreen?, screenContainingWindow: NSScreen?, screenVirtualDisplay: NSScreen?, isWithinVirtualDisplay: Bool, isWithinScreenContainingWindow: Bool, isWithinWindow: Bool, isWithinWindowContent: Bool, isWithinVirtualDisplayBorder: Bool)
}

enum MouseLocationSettings: Action {
    case enableTeleport(isTeleportEnabled: Bool)
    case enableWindowResize(isWindowResizeAllowed: Bool)
    case resetWindowSize
}

enum MouseLocationEvent: Action {
    case localMouseClicked(mouseLocation: NSPoint, event: NSEvent)
    case localMouseMoved(mouseLocation: NSPoint, event: NSEvent)
    case globalMouseMoved(mouseLocation: NSPoint, event: NSEvent)
}

func mouseLocationSideEffect() -> SideEffect {
    var mouseLocation = NSPoint.zero
    var event: NSEvent?
    var window: NSWindow?
    var screenContainingMouse: NSScreen?
    var screenContainingWindow: NSScreen?
    var screenVirtualDisplay: NSScreen?
    var isTeleportEnabled = false
    var isWithinVirtualDisplay = false
    var isWithinScreenContainingWindow = false
    var isWithinWindow = false
    var isWithinWindowContent = false
    var isWithinVirtualDisplayBorder = false

    return { action, dispatch, getState in
        guard let appState = getState() else { return }
        UserDefaults.standard.set(appState.mouseLocationState.isTeleportEnabled, forKey: "isTeleportEnabled")
        UserDefaults.standard.set(appState.mouseLocationState.isWindowResizeAllowed, forKey: "isWindowResizeAllowed")
        event = appState.mouseLocationState.event
        if event != nil, appState.screenConfigurationState.resolution != .zero {
            let screens = NSScreen.screens
            mouseLocation = appState.mouseLocationState.mouseLocation
            window = appState.mouseLocationState.window
            screenContainingMouse = (screens.first { NSMouseInRect(mouseLocation, $0.frame, false) })
            screenContainingWindow = (screens.first { NSPointInRect((window?.frame.origin)!, $0.frame) })
            screenVirtualDisplay = (screens.first { $0.displayID == appState.screenConfigurationState.displayID })
            isWithinVirtualDisplay = screenContainingMouse?.displayID == screenVirtualDisplay?.displayID
            isWithinScreenContainingWindow = screenContainingMouse?.displayID == screenContainingWindow?.displayID
            isWithinWindow = NSMouseInRect(mouseLocation, (window?.frame)!, false)
            isWithinWindowContent = NSMouseInRect((window?.mouseLocationOutsideOfEventStream)!, (window?.contentView?.frame)!, false)
            isTeleportEnabled = appState.mouseLocationState.isTeleportEnabled

            let borderWidth: CGFloat = 5 // Border width
            let innerRect = NSInsetRect((screenVirtualDisplay?.frame)!, borderWidth, borderWidth)
            let isWithinInnerRectangle = NSMouseInRect(mouseLocation, innerRect, false)
            isWithinVirtualDisplayBorder = isWithinVirtualDisplay && !isWithinInnerRectangle ? true : false

            /* print("")
             print("Mouse event")
             print("event:", event as Any)
             print("windowNumber:", window?.windowNumber as Any)
             print("screenContainingMouse:", screenContainingMouse?.localizedName as Any)
             print("screenContainingWindow:", screenContainingWindow?.localizedName as Any)
             print("screenVirtualDisplay:", screenVirtualDisplay?.localizedName as Any)
             print("isWithinVirtualDisplay:", isWithinVirtualDisplay)
             print("isWithinScreenContainingWindow:", isWithinScreenContainingWindow)
             print("isWithinWindow:", isWithinWindow)
             print("isWithinWindowContent:", isWithinWindowContent)
             print("isWithinVirtualDisplayBorder:", isWithinVirtualDisplayBorder)
             print("isTeleportEnabled:", isTeleportEnabled) */

            dispatch(MouseLocationAction.update(screenContainingMouse: screenContainingMouse, screenContainingWindow: screenContainingWindow, screenVirtualDisplay: screenVirtualDisplay, isWithinVirtualDisplay: isWithinVirtualDisplay, isWithinScreenContainingWindow: isWithinScreenContainingWindow, isWithinWindow: isWithinWindow, isWithinWindowContent: isWithinWindowContent, isWithinVirtualDisplayBorder: isWithinVirtualDisplayBorder))
        }

        switch action {
        case MouseLocationEvent.localMouseClicked:
            // print("localClick:", mouseLocation)
            if isTeleportEnabled, isWithinWindowContent {
                teleportMouseToVirtualDisplay(state: appState.mouseLocationState)
                // print("Teleport mouse", mouseLocation)
            }
        case MouseLocationEvent.localMouseMoved:
            // print("localMove:", mouseLocation)
            do {}
        case MouseLocationEvent.globalMouseMoved:
            // print("globalMove:", mouseLocation)
            do {}
        case MouseLocationSettings.resetWindowSize:
            appState.mouseLocationState.window?.contentAspectRatio = appState.screenConfigurationState.resolution
            appState.mouseLocationState.window?.setContentSize(appState.screenConfigurationState.resolution)
            appState.mouseLocationState.window?.center()
        case MouseLocationSettings.enableWindowResize:
            if appState.mouseLocationState.isWindowResizeAllowed {
                appState.mouseLocationState.window?.styleMask = [.titled, .closable, .resizable, .miniaturizable]
            } else {
                appState.mouseLocationState.window?.styleMask = [.titled, .closable, .miniaturizable]
            }
        default:
            return
        }
    }
}

func teleportMouseToVirtualDisplay(state: MouseLocationState) {
    // Move the mouse to the virtual display
    let newX = CGFloat(state.window!.mouseLocationOutsideOfEventStream.x * (state.screenVirtualDisplay!.frame.width / state.window!.contentView!.frame.size.width))
    let newY = CGFloat(state.screenVirtualDisplay!.frame.height - state.window!.mouseLocationOutsideOfEventStream.y * (state.screenVirtualDisplay!.frame.height / state.window!.contentView!.frame.size.height))
    let newPoint = NSPoint(x: newX, y: newY)
    // print("newPoint:", newPoint)
    CGDisplayMoveCursorToPoint(state.screenVirtualDisplay!.displayID, newPoint)
}
