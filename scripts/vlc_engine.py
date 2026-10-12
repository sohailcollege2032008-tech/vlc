"""
VLC Engine Service - Real native libvlc media playback controller.
Provides hardware-accelerated video rendering, audio equalizer,
video adjust filters, subtitle track manipulation, and metadata parsing.
"""
import os
import re
import sys
import vlc
from PySide6.QtCore import QObject, Signal, Property, Slot, QTimer, QUrl


class VlcEngine(QObject):
    # Signals for QML
    playingStateChanged = Signal(int)
    timeChanged = Signal(int, str)          # timeMs, formatted string
    lengthChanged = Signal(int, str)        # lengthMs, formatted string
    positionChanged = Signal(float)         # 0.0 to 1.0
    volumeChanged = Signal(int)             # 0 to 100
    muteChanged = Signal(bool)
    rateChanged = Signal(float)
    titleChanged = Signal(str)
    artistChanged = Signal(str)
    albumChanged = Signal(str)
    hasVideoOutputChanged = Signal(bool)
    subtitlesScanned = Signal(list)
    mediaLibraryScanned = Signal(list)

    def __init__(self, parent=None):
        super().__init__(parent)
        
        # Initialize libvlc instance with hardware acceleration
        self._vlc_instance = vlc.Instance(
            "--no-xlib",
            "--quiet",
            "--avcodec-hw=d3d11va",
            "--network-caching=1000"
        )
        self._player = self._vlc_instance.media_player_new()
        
        # State
        self._current_path = ""
        self._title = "No Media Loaded"
        self._artist = ""
        self._album = ""
        self._volume = 80
        self._is_muted = False
        self._rate = 1.0
        self._has_video = False
        self._duration_ms = 0
        self._current_time_ms = 0
        
        # Poll timer for smooth playback UI updates (100ms / 10fps)
        self._timer = QTimer(self)
        self._timer.setInterval(100)
        self._timer.timeout.connect(self._poll_playback_state)
        self._timer.start()

    def bind_video_hwnd(self, hwnd: int):
        """Bind libvlc video output to a native Win32 HWND."""
        if sys.platform == "win32":
            self._player.set_hwnd(hwnd)

    def _poll_playback_state(self):
        """Poll the active libvlc media player state."""
        if not self._player:
            return

        state = self._player.get_state()
        state_int = int(state.value) if hasattr(state, "value") else int(state)
        
        # Track time and position
        curr_time = self._player.get_time()
        if curr_time >= 0:
            self._current_time_ms = curr_time
            formatted = self._format_ms(curr_time)
            self.timeChanged.emit(curr_time, formatted)
            
            # Position
            pos = self._player.get_position()
            if pos >= 0.0:
                self.positionChanged.emit(pos)

        # Track length
        length = self._player.get_length()
        if length > 0 and length != self._duration_ms:
            self._duration_ms = length
            self.lengthChanged.emit(length, self._format_ms(length))

        # Check video output availability
        has_vout = self._player.has_vout() > 0
        if has_vout != self._has_video:
            self._has_video = has_vout
            self.hasVideoOutputChanged.emit(has_vout)

    @staticmethod
    def _format_ms(ms: int) -> str:
        seconds = int((ms // 1000) % 60)
        minutes = int((ms // (1000 * 60)) % 60)
        hours = int((ms // (1000 * 60 * 60)))
        if hours > 0:
            return f"{hours:02d}:{minutes:02d}:{seconds:02d}"
        return f"{minutes:02d}:{seconds:02d}"

    # ==================== PLAYBACK SLOTS ====================

    @Slot(str)
    def openFile(self, file_path: str):
        """Open and play any video or audio file."""
        if not file_path:
            return
        
        # Normalize Windows path
        if file_path.startswith("file:///"):
            file_path = QUrl(file_path).toLocalFile()
        
        file_path = os.path.normpath(file_path)
        if not os.path.exists(file_path):
            print(f"[VlcEngine] File does not exist: {file_path}")
            return

        self._current_path = file_path
        media = self._vlc_instance.media_new(file_path)
        self._player.set_media(media)
        self._player.play()

        # Update metadata
        filename = os.path.basename(file_path)
        self._title = filename
        self.titleChanged.emit(self._title)

        # Parse artist and album if audio
        media.parse_with_options(vlc.MediaParseFlag.local, -1)
        artist = media.get_meta(vlc.Meta.Artist) or ""
        album = media.get_meta(vlc.Meta.Album) or ""
        title = media.get_meta(vlc.Meta.Title) or filename
        self._artist = artist
        self._album = album
        self._title = title
        self.artistChanged.emit(artist)
        self.albumChanged.emit(album)
        self.titleChanged.emit(title)

        # Enable video adjustments
        self._player.video_set_adjust_int(vlc.VideoAdjustOption.Enable, 1)

        # Trigger subtitle auto-scan
        self.scanSubtitles(file_path)

    @Slot()
    def togglePlayPause(self):
        """Toggle play/pause state."""
        if self._player.is_playing():
            self._player.pause()
            self.playingStateChanged.emit(4)  # PAUSED
        else:
            self._player.play()
            self.playingStateChanged.emit(3)  # PLAYING

    @Slot()
    def play(self):
        self._player.play()
        self.playingStateChanged.emit(3)

    @Slot()
    def pause(self):
        self._player.pause()
        self.playingStateChanged.emit(4)

    @Slot()
    def stop(self):
        self._player.stop()
        self.playingStateChanged.emit(5)  # STOPPED
        self.timeChanged.emit(0, "00:00")
        self.positionChanged.emit(0.0)

    @Slot(float)
    def seek(self, position: float):
        """Seek to position ratio 0.0 - 1.0."""
        pos = max(0.0, min(1.0, position))
        self._player.set_position(pos)

    @Slot(int)
    def jumpSeconds(self, seconds: int):
        """Jump relative seconds (+10, -10, +15, -15)."""
        curr = self._player.get_time()
        if curr >= 0:
            target = max(0, curr + (seconds * 1000))
            self._player.set_time(target)

    @Slot(int)
    def setVolume(self, volume: int):
        """Set volume 0 to 125%."""
        vol = max(0, min(125, volume))
        self._volume = vol
        self._player.audio_set_volume(vol)
        self.volumeChanged.emit(vol)

    @Slot()
    def toggleMute(self):
        """Toggle audio mute."""
        self._is_muted = not self._is_muted
        self._player.audio_set_mute(self._is_muted)
        self.muteChanged.emit(self._is_muted)

    @Slot(float)
    def setRate(self, rate: float):
        """Set playback rate (0.5x, 1.0x, 1.25x, 1.5x, 2.0x)."""
        r = max(0.25, min(4.0, rate))
        self._rate = r
        self._player.set_rate(r)
        self.rateChanged.emit(r)

    # ==================== QUICK SETTINGS FX SLOTS ====================

    @Slot(int)
    def setAudioDelayMs(self, delay_ms: int):
        """Adjust audio sync delay in milliseconds."""
        microseconds = delay_ms * 1000
        self._player.audio_set_delay(microseconds)

    @Slot(int)
    def setSubtitleDelayMs(self, delay_ms: int):
        """Adjust subtitle sync delay in milliseconds."""
        microseconds = delay_ms * 1000
        self._player.video_set_spu_delay(microseconds)

    @Slot(str)
    def setEqualizerPreset(self, preset_name: str):
        """Apply a native 10-band equalizer preset."""
        count = vlc.libvlc_audio_equalizer_get_preset_count()
        for i in range(count):
            name = vlc.libvlc_audio_equalizer_get_preset_name(i).decode('utf-8')
            if name.lower() == preset_name.lower():
                eq = vlc.libvlc_audio_equalizer_new_from_preset(i)
                self._player.set_equalizer(eq)
                print(f"[VlcEngine] Applied Equalizer Preset: {name}")
                return
        print(f"[VlcEngine] Preset '{preset_name}' not found.")

    @Slot(float, float, float)
    def setVideoAdjust(self, brightness: float, contrast: float, saturation: float):
        """Adjust live video filters (brightness 0-2, contrast 0-2, saturation 0-2)."""
        self._player.video_set_adjust_int(vlc.VideoAdjustOption.Enable, 1)
        self._player.video_set_adjust_float(vlc.VideoAdjustOption.Brightness, max(0.0, min(2.0, brightness)))
        self._player.video_set_adjust_float(vlc.VideoAdjustOption.Contrast, max(0.0, min(2.0, contrast)))
        self._player.video_set_adjust_float(vlc.VideoAdjustOption.Saturation, max(0.0, min(2.0, saturation)))

    # ==================== SMART SUBTITLES AUTO-MATCHER ====================

    @Slot(str)
    def scanSubtitles(self, video_path: str):
        """
        Scan directory for subtitle files, match episode patterns
        (e.g. S01E05), and return matching results.
        """
        if not video_path or not os.path.exists(video_path):
            self.subtitlesScanned.emit([])
            return

        folder = os.path.dirname(video_path)
        video_name = os.path.basename(video_path)
        
        # Extract season/episode token from video name
        ep_match = re.search(r'[Ss](\d{1,2})[Ee](\d{1,2})|(?:ep|episode)\.?\s*(\d{1,2})', video_name, re.IGNORECASE)
        video_token = ""
        if ep_match:
            video_token = ep_match.group(0).lower()

        sub_files = []
        target_dirs = [folder]
        subs_subdir = os.path.join(folder, "Subs")
        if os.path.exists(subs_subdir):
            target_dirs.append(subs_subdir)

        sub_exts = ('.srt', '.ass', '.vtt', '.sub')
        for d in target_dirs:
            for f in os.listdir(d):
                if f.lower().endswith(sub_exts):
                    full_p = os.path.join(d, f)
                    is_matched = False
                    if video_token and video_token in f.lower():
                        is_matched = True
                    elif os.path.splitext(video_name)[0].lower() in f.lower():
                        is_matched = True

                    sub_files.append({
                        "name": f,
                        "path": full_p,
                        "isMatched": is_matched,
                        "size": f"{os.path.getsize(full_p) / 1024:.1f} KB"
                    })

        # Sort so matched appears first
        sub_files.sort(key=lambda x: not x["isMatched"])
        self.subtitlesScanned.emit(sub_files)

    @Slot(str)
    def applySubtitleFile(self, sub_path: str):
        """Mount external subtitle track directly to the video player."""
        if os.path.exists(sub_path):
            res = self._player.video_set_subtitle_file(sub_path)
            print(f"[VlcEngine] Loaded subtitle {sub_path} (result={res})")

    # ==================== LOCAL MEDIA LIBRARY SCANNER ====================

    @Slot(str)
    def scanMediaFolder(self, folder_path: str):
        """Scan local folder and return real media files."""
        if not folder_path or not os.path.exists(folder_path):
            folder_path = os.path.abspath("media")

        media_exts = ('.mp4', '.mkv', '.avi', '.mov', '.mp3', '.wav', '.webm')
        items = []
        for root_dir, _, files in os.walk(folder_path):
            for f in files:
                if f.lower().endswith(media_exts):
                    p = os.path.join(root_dir, f)
                    size_mb = os.path.getsize(p) / (1024 * 1024)
                    ext = os.path.splitext(f)[1].upper().replace(".", "")
                    items.append({
                        "title": os.path.splitext(f)[0].replace("_", " "),
                        "path": p,
                        "filename": f,
                        "format": ext,
                        "size": f"{size_mb:.1f} MB",
                        "isVideo": not f.lower().endswith(('.mp3', '.wav'))
                    })

        self.mediaLibraryScanned.emit(items)
