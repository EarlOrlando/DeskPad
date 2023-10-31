import Foundation
import ReSwift

private var timer: Timer?

enum MouseLocationAction: Action {
    case located(isWithinScreen: Bool)
}

func mouseLocationSideEffect() -> SideEffect {
    return { _, dispatch, _ in
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
                // let mouseLocation = NSEvent.mouseLocation
                // let screens = NSScreen.screens
                // let screenContainingMouse = (screens.first { NSMouseInRect(mouseLocation, $0.frame, false) })
                // let isWithinScreen = screenContainingMouse?.displayID == getState()?.screenConfigurationState.displayID
                // let isWithinScreen = false
                // NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
                /* let mouseLocation = NSEvent.mouseLocation
                 let screens = NSScreen.screens

                 if let screenContainingMouse = screens.first(where: { NSMouseInRect(mouseLocation, $0.frame, false) }) {
                     let isWithinVirtualScreen = screenContainingMouse.displayID == getState()?.screenConfigurationState.displayID
                     let isWithinWindowScreen = screenContainingMouse.displayID == NSApp.windows.first?.contentView?.window?.screen?.displayID

                     if isWithinVirtualScreen {
                         let screenFrame = screenContainingMouse.frame
                         let borderWidth: CGFloat = 10 // Adjust this value to change the border width
                         let innerRect = NSInsetRect(screenFrame, borderWidth, borderWidth)
                         let isWithinInnerRectangle = NSMouseInRect(mouseLocation, innerRect, false)

                         if isWithinVirtualScreen, !isWithinInnerRectangle {
                             print("Mouse is on the border of the virtual screen")
                         } else {
                             print("Mouse is within the virtual screen")
                         }
                         // isWithinScreen = true
                     } else if isWithinWindowScreen {
                         if NSApp.windows.first?.contentView?.window?.frame.contains(mouseLocation) != false {
                             print("Mouse is within the window")
                             // If mouse is not in the title bar
                             // if true {
                             // if NSApp.windows.first?.contentView?.window?.mouseLocationOutsideOfEventStream.y < NSApp.windows.first?.contentView?.window?.contentView!.frame.height {
                             // Move cursor only if menu item is enabled
                             //     if true {
                             // Move the mouse to the virtual display
                             var newPoint = NSApp.windows.first?.contentView?.window?.mouseLocationOutsideOfEventStream
                             // newPoint.x = NSApp.windows.first?.contentView?.window?.mouseLocationOutsideOfEventStream.x * (self.viewController.previousResolution!.width / NSApp.windows.first?.contentView?.window?.frame.size.width)
                             // newPoint.y = self.viewController.previousResolution!.height - NSApp.windows.first?.contentView?.window?.mouseLocationOutsideOfEventStream.y * (self.viewController.previousResolution!.height / NSApp.windows.first?.contentView?.window?.contentView!.frame.height)
                             //CGDisplayMoveCursorToPoint(getState()?.screenConfigurationState.displayID, newPoint)
                             //    }
                             // }
                         } else {
                             print("Mouse is within the screen but outside the window")
                         }
                     } else {
                         print("Mouse is in another screen")
                     }
                 } */
                dispatch(MouseLocationAction.located(isWithinScreen: false))
            }
        }
    }
}
