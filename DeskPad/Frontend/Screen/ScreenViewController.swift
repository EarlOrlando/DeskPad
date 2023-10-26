import Cocoa
import ReSwift

enum ScreenViewAction: Action {
    case setDisplayID(CGDirectDisplayID)
}

class ScreenViewController: SubscriberViewController<ScreenViewData> {
    override func loadView() {
        view = NSView()
        view.wantsLayer = true
    }

    private var display: CGVirtualDisplay!
    private var stream: CGDisplayStream?
    private var isWindowHighlighted = false
    private var previousResolution: CGSize?
    lazy var window: NSWindow = view.window!
    private var location: NSPoint { window.mouseLocationOutsideOfEventStream }
    var moveCursorItemOnClick = true

    override func viewDidLoad() {
        super.viewDidLoad()

        let descriptor = CGVirtualDisplayDescriptor()
        descriptor.setDispatchQueue(DispatchQueue.main)
        descriptor.name = "DeskPad Display"
        descriptor.maxPixelsWide = 3840
        descriptor.maxPixelsHigh = 2160
        descriptor.sizeInMillimeters = CGSize(width: 1600, height: 1000)
        descriptor.productID = 0x1234
        descriptor.vendorID = 0x3456
        descriptor.serialNum = 0x0001

        let display = CGVirtualDisplay(descriptor: descriptor)
        store.dispatch(ScreenViewAction.setDisplayID(display.displayID))
        self.display = display

        let settings = CGVirtualDisplaySettings()
        settings.hiDPI = 1
        settings.modes = [
            // 16:9 without menu bar and title menu to optimize window size
            CGVirtualDisplayMode(width: 2560, height: 1375, refreshRate: 60),
            CGVirtualDisplayMode(width: 1920, height: 1015, refreshRate: 60),
            // 16:9
            CGVirtualDisplayMode(width: 2560, height: 1440, refreshRate: 60),
            CGVirtualDisplayMode(width: 1920, height: 1080, refreshRate: 60),
            CGVirtualDisplayMode(width: 1600, height: 900, refreshRate: 60),
            CGVirtualDisplayMode(width: 1366, height: 768, refreshRate: 60),
            CGVirtualDisplayMode(width: 1280, height: 720, refreshRate: 60),
            // 16:10
            CGVirtualDisplayMode(width: 1920, height: 1200, refreshRate: 60),
            CGVirtualDisplayMode(width: 1680, height: 1050, refreshRate: 60),
            CGVirtualDisplayMode(width: 1440, height: 900, refreshRate: 60),
            CGVirtualDisplayMode(width: 1280, height: 800, refreshRate: 60),
        ]
        display.apply(settings)

        NSEvent.addLocalMonitorForEvents(matching: [.leftMouseUp]) {
            // If mouse is not in the title bar
            if self.location.y < self.previousResolution!.height {
                // Move the mouse to the virtual display
                var newPoint = self.location
                newPoint.y = self.previousResolution!.height - self.location.y
                // Move cursor only if menu item is enabled
                if self.moveCursorItemOnClick {
                    CGDisplayMoveCursorToPoint(self.display.displayID, newPoint)
                }
            }
            return $0
        }
    }

    override func update(with viewData: ScreenViewData) {
        if viewData.isWindowHighlighted != isWindowHighlighted {
            isWindowHighlighted = viewData.isWindowHighlighted
            view.window?.backgroundColor = isWindowHighlighted
                ? NSColor(named: "TitleBarActive")
                : NSColor(named: "TitleBarInactive")
            if isWindowHighlighted {
                view.window?.orderFrontRegardless()
            }
        }

        if viewData.resolution != .zero, viewData.resolution != previousResolution {
            previousResolution = viewData.resolution
            stream = nil
            view.window?.contentMinSize = viewData.resolution
            view.window?.contentMaxSize = viewData.resolution
            view.window?.setContentSize(viewData.resolution)
            view.window?.center()
            let stream = CGDisplayStream(
                dispatchQueueDisplay: display.displayID,
                outputWidth: Int(viewData.resolution.width),
                outputHeight: Int(viewData.resolution.height),
                pixelFormat: 1_111_970_369,
                properties: nil,
                queue: .main,
                handler: { [weak self] _, _, frameSurface, _ in
                    if let surface = frameSurface {
                        self?.view.layer?.contents = surface
                    }
                }
            )
            self.stream = stream
            stream?.start()
        }
    }
}
