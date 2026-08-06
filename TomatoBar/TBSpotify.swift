import Foundation

/// Pauses Spotify, if and only if it is already running and playing.
///
/// Deliberately does not resume: the point of the break is the silence.
/// Deliberately does not handle any other player: personal build, known habits.
enum TBSpotify {
    private static let source = """
    if application "Spotify" is running then
        tell application "Spotify"
            if player state is playing then pause
        end tell
    end if
    """

    /// Safe to call when Spotify is closed, or when nothing is playing —
    /// both cases are no-ops. Never launches Spotify.
    static func pause() {
        // NSAppleScript is not thread-safe; keep it on the main thread.
        guard Thread.isMainThread else {
            DispatchQueue.main.async { pause() }
            return
        }

        guard let script = NSAppleScript(source: source) else {
            print("TBSpotify: could not compile script")
            return
        }

        var error: NSDictionary?
        script.executeAndReturnError(&error)

        if let error = error {
            // -1743 means the user denied (or was never asked for) Automation
            // permission. See System Settings > Privacy & Security > Automation.
            print("TBSpotify: pause failed: \(error)")
        }
    }
}
