import Foundation

enum TBSpotify {
    /// The track to fire at the end of a rest block. Right-click a track in
    /// Spotify → Share, hold Option, "Copy Spotify URI".
    private static let alarmURI = "spotify:track:5Wjjn7sW1VT9enCdZLqBK2"

    // MARK: - Scripts

    private static let pauseScript = """
    if application "Spotify" is running then
        tell application "Spotify"
            if player state is playing then pause
        end tell
    end if
    """

    private static var alarmScript: String {
        """
        tell application "Spotify"
            activate
            play track "\(alarmURI)"
        end tell
        """
    }

    // MARK: - Public API

    /// Pause, if running and playing. Never launches Spotify.
    static func pause() { run(pauseScript, label: "pause") }

    /// Play the alarm track. Launches Spotify if closed, and deliberately
    /// replaces the current playback context — this ends the break.
    static func playAlarm() { run(alarmScript, label: "alarm") }

    // MARK: - Plumbing

    private static func run(_ source: String, label: String) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { run(source, label: label) }
            return
        }
        guard let script = NSAppleScript(source: source) else {
            print("TBSpotify: could not compile \(label)")
            return
        }
        var error: NSDictionary?
        script.executeAndReturnError(&error)
        if let error = error {
            print("TBSpotify: \(label) failed: \(error)")
        }
    }
}
