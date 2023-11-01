import Foundation
import ReSwift

struct MouseLocationState: Equatable {
    let mouseLocation: NSPoint
    let event: NSEvent?
    let window: NSWindow?
    let screenContainingMouse: NSScreen?
    let screenContainingWindow: NSScreen?
    let screenVirtualDisplay: NSScreen?
    let isTeleportEnabled: Bool
    let isWindowResizeAllowed: Bool
    let isWithinVirtualDisplay: Bool
    let isWithinScreenContainingWindow: Bool
    let isWithinWindow: Bool
    let isWithinWindowContent: Bool
    let isWithinVirtualDisplayBorder: Bool

    static var initialState: MouseLocationState {
        return MouseLocationState(
            mouseLocation: NSPoint.zero,
            event: nil,
            window: nil,
            screenContainingMouse: nil,
            screenContainingWindow: nil,
            screenVirtualDisplay: nil,
            isTeleportEnabled: UserDefaults.standard.bool(forKey: "isTeleportEnabled"),
            isWindowResizeAllowed: UserDefaults.standard.bool(forKey: "isWindowResizeAllowed"),
            isWithinVirtualDisplay: false,
            isWithinScreenContainingWindow: false,
            isWithinWindow: false,
            isWithinWindowContent: false,
            isWithinVirtualDisplayBorder: false
        )
    }
}

func mouseLocationReducer(action: Action, state: MouseLocationState) -> MouseLocationState {
    switch action {
    case let MouseLocationAction.update(screenContainingMouse: screenContainingMouse, screenContainingWindow: screenContainingWindow, screenVirtualDisplay: screenVirtualDisplay, isWithinVirtualDisplay: isWithinVirtualDisplay, isWithinScreenContainingWindow: isWithinScreenContainingWindow, isWithinWindow: isWithinWindow, isWithinWindowContent: isWithinWindowContent, isWithinVirtualDisplayBorder: isWithinVirtualDisplayBorder):
        return MouseLocationState(mouseLocation: state.mouseLocation, event: nil, window: state.window, screenContainingMouse: screenContainingMouse, screenContainingWindow: screenContainingWindow, screenVirtualDisplay: screenVirtualDisplay, isTeleportEnabled: state.isTeleportEnabled, isWindowResizeAllowed: state.isWindowResizeAllowed, isWithinVirtualDisplay: isWithinVirtualDisplay, isWithinScreenContainingWindow: isWithinScreenContainingWindow, isWithinWindow: isWithinWindow, isWithinWindowContent: isWithinWindowContent, isWithinVirtualDisplayBorder: isWithinVirtualDisplayBorder)
    case let MouseLocationAction.located(isWithinVirtualDisplay):
        return MouseLocationState(mouseLocation: state.mouseLocation, event: nil, window: state.window, screenContainingMouse: state.screenContainingMouse, screenContainingWindow: state.screenContainingWindow, screenVirtualDisplay: state.screenVirtualDisplay, isTeleportEnabled: state.isTeleportEnabled, isWindowResizeAllowed: state.isWindowResizeAllowed, isWithinVirtualDisplay: isWithinVirtualDisplay, isWithinScreenContainingWindow: state.isWithinScreenContainingWindow, isWithinWindow: state.isWithinWindow, isWithinWindowContent: state.isWithinWindowContent, isWithinVirtualDisplayBorder: state.isWithinVirtualDisplayBorder)
    case let MouseLocationAction.setWindow(window):
        return MouseLocationState(mouseLocation: state.mouseLocation, event: nil, window: window, screenContainingMouse: state.screenContainingMouse, screenContainingWindow: state.screenContainingWindow, screenVirtualDisplay: state.screenVirtualDisplay, isTeleportEnabled: state.isTeleportEnabled, isWindowResizeAllowed: state.isWindowResizeAllowed, isWithinVirtualDisplay: state.isWithinVirtualDisplay, isWithinScreenContainingWindow: state.isWithinScreenContainingWindow, isWithinWindow: state.isWithinWindow, isWithinWindowContent: state.isWithinWindowContent, isWithinVirtualDisplayBorder: state.isWithinVirtualDisplayBorder)
    case let MouseLocationSettings.enableTeleport(isTeleportEnabled):
        return MouseLocationState(mouseLocation: state.mouseLocation, event: nil, window: state.window, screenContainingMouse: state.screenContainingMouse, screenContainingWindow: state.screenContainingWindow, screenVirtualDisplay: state.screenVirtualDisplay, isTeleportEnabled: isTeleportEnabled, isWindowResizeAllowed: state.isWindowResizeAllowed, isWithinVirtualDisplay: state.isWithinVirtualDisplay, isWithinScreenContainingWindow: state.isWithinScreenContainingWindow, isWithinWindow: state.isWithinWindow, isWithinWindowContent: state.isWithinWindowContent, isWithinVirtualDisplayBorder: state.isWithinVirtualDisplayBorder)
    case let MouseLocationSettings.enableWindowResize(isWindowResizeAllowed):
        return MouseLocationState(mouseLocation: state.mouseLocation, event: nil, window: state.window, screenContainingMouse: state.screenContainingMouse, screenContainingWindow: state.screenContainingWindow, screenVirtualDisplay: state.screenVirtualDisplay, isTeleportEnabled: state.isTeleportEnabled, isWindowResizeAllowed: isWindowResizeAllowed, isWithinVirtualDisplay: state.isWithinVirtualDisplay, isWithinScreenContainingWindow: state.isWithinScreenContainingWindow, isWithinWindow: state.isWithinWindow, isWithinWindowContent: state.isWithinWindowContent, isWithinVirtualDisplayBorder: state.isWithinVirtualDisplayBorder)
    case let MouseLocationEvent.localMouseClicked(mouseLocation, event):
        return MouseLocationState(mouseLocation: mouseLocation, event: event, window: state.window, screenContainingMouse: state.screenContainingMouse, screenContainingWindow: state.screenContainingWindow, screenVirtualDisplay: state.screenVirtualDisplay, isTeleportEnabled: state.isTeleportEnabled, isWindowResizeAllowed: state.isWindowResizeAllowed, isWithinVirtualDisplay: state.isWithinVirtualDisplay, isWithinScreenContainingWindow: state.isWithinScreenContainingWindow, isWithinWindow: state.isWithinWindow, isWithinWindowContent: state.isWithinWindowContent, isWithinVirtualDisplayBorder: state.isWithinVirtualDisplayBorder)
    case let MouseLocationEvent.localMouseMoved(mouseLocation, event):
        return MouseLocationState(mouseLocation: mouseLocation, event: event, window: state.window, screenContainingMouse: state.screenContainingMouse, screenContainingWindow: state.screenContainingWindow, screenVirtualDisplay: state.screenVirtualDisplay, isTeleportEnabled: state.isTeleportEnabled, isWindowResizeAllowed: state.isWindowResizeAllowed, isWithinVirtualDisplay: state.isWithinVirtualDisplay, isWithinScreenContainingWindow: state.isWithinScreenContainingWindow, isWithinWindow: state.isWithinWindow, isWithinWindowContent: state.isWithinWindowContent, isWithinVirtualDisplayBorder: state.isWithinVirtualDisplayBorder)
    case let MouseLocationEvent.globalMouseMoved(mouseLocation, event):
        return MouseLocationState(mouseLocation: mouseLocation, event: event, window: state.window, screenContainingMouse: state.screenContainingMouse, screenContainingWindow: state.screenContainingWindow, screenVirtualDisplay: state.screenVirtualDisplay, isTeleportEnabled: state.isTeleportEnabled, isWindowResizeAllowed: state.isWindowResizeAllowed, isWithinVirtualDisplay: state.isWithinVirtualDisplay, isWithinScreenContainingWindow: state.isWithinScreenContainingWindow, isWithinWindow: state.isWithinWindow, isWithinWindowContent: state.isWithinWindowContent, isWithinVirtualDisplayBorder: state.isWithinVirtualDisplayBorder)

    default:
        return state
    }
}
