<p align="center">
<img src="https://raw.githubusercontent.com/ivoronin/TomatoBar/main/TomatoBar/Assets.xcassets/AppIcon.appiconset/icon_128x128%402x.png" width="128" height="128"/>
<p>

<h1 align="center">TomatoBar (Spotify fork)</h1>

<img
  src="https://github.com/ivoronin/TomatoBar/raw/main/screenshot.png?raw=true"
  alt="Screenshot"
  width="50%"
  align="right"
/>

## Overview

A personal fork of [TomatoBar](https://github.com/ivoronin/TomatoBar), a Pomodoro
timer for the macOS menu bar. Read more about the technique on
[Wikipedia](https://en.wikipedia.org/wiki/Pomodoro_Technique).

Everything from upstream is still here — configurable work and rest intervals,
sounds, notifications, global hotkey — plus the changes below.

## What's different in this fork

**Spotify pauses when a work session ends.** The break starts in silence, which
makes it a real break rather than a change of activity.

**Spotify starts again when the break ends.** This is the actual reason the fork
exists. If you're wearing multipoint Bluetooth headphones connected to something
else — a games console, a phone — a short system ding won't pull the audio back
to your Mac, but Spotify starting playback will. So the alarm is a track rather
than a chime. Configurable in the Sounds pane: either a specific track, or
"resume", which picks up whatever was paused at the start of the break.

**Option-click to shorten a long break.** Hover the timer button and hold ⌥
during a long break to convert it to a short one, without restarting the timer.
Useful if you changed the sessions-per-set setting and got a long break sooner
than you meant to. The session count is preserved, so the cycle stays correct.

## Requirements

- macOS (diverges from upstream — Monterey or later)
- Xcode, to build. The Command Line Tools alone are not enough.
- Spotify, for the alarm features. Premium is recommended: on the free tier,
  `play track` may serve an ad before your alarm, or refuse on-demand playback.

## Installing

This fork is not notarized, so there is no release download and no Homebrew
cask — a downloaded build would be blocked by Gatekeeper. Building it yourself
sidesteps that entirely: locally built apps are not quarantined.

```
git clone https://github.com/YOURNAME/TomatoBar.git
cd TomatoBar
git checkout spotify-pause
./build-tomatobar.sh
```

The script builds a Release configuration, copies the app to `/Applications`,
and launches it. Re-run it any time to rebuild after pulling changes.

If you get `permission denied`, the executable bit didn't survive the download:
`chmod +x build-tomatobar.sh`.

### First launch

macOS will ask for permission to control Spotify the first time a session ends.
Say yes — without it the pause and alarm silently do nothing. If you never see
the prompt, check System Settings → Privacy & Security → Automation.

The app is signed ad-hoc, which means the signature is only valid on the machine
that built it. A consequence is that macOS may re-ask for that permission after
a rebuild, and notification banners may not work at all.

## Configuring the alarm

The Sounds pane has a Spotify URI field and a toggle for resume-vs-track mode.

To get a track's URI: right-click it in Spotify → Share, then **hold Option** —
"Copy Song Link" becomes "Copy Spotify URI". Alternatively, take a normal share
link (`https://open.spotify.com/track/ABC123?si=...`) and rewrite it as
`spotify:track:ABC123`.

Playlist and album URIs work too, if you'd rather the break end with something
that has somewhere to go next.

## Integration with other tools

### Event log

TomatoBar logs state transitions in JSON format to
`~/Library/Containers/com.github.ivoronin.TomatoBar/Data/Library/Caches/TomatoBar.log`.
Use this data to analyze your productivity and enrich other data sources.

### Starting and stopping the timer

TomatoBar can be controlled using `tomatobar://` URLs. To start or stop the timer
from the command line, use `open tomatobar://startStop`.

## Licenses

- Upstream TomatoBar is MIT licensed — see [LICENSE](LICENSE).
- Timer sounds are licensed from buddhabeats.
