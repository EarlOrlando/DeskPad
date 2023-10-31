import ReSwift

struct AppState: Equatable {
    let mouseLocationState: MouseLocationState
    let MouseTeleportState: MouseTeleportState
    let screenConfigurationState: ScreenConfigurationState

    static var initialState: AppState {
        return AppState(
            mouseLocationState: .initialState,
            MouseTeleportState: .initialState,
            screenConfigurationState: .initialState
        )
    }
}

func appReducer(action: Action, state: AppState?) -> AppState {
    let state = state ?? .initialState

    return AppState(
        mouseLocationState: mouseLocationReducer(action: action, state: state.mouseLocationState),
        MouseTeleportState: mouseTeleportReducer(action: action, state: state.MouseTeleportState),
        screenConfigurationState: screenConfigurationReducer(action: action, state: state.screenConfigurationState)
    )
}
