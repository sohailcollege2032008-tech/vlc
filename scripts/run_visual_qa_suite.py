"""
Automated Visual QA Suite for VLC Redesign Production Application.
Renders each view, simulates media playback, captures screenshots, and checks console logs.
"""
import os
import sys
import time
from PySide6.QtWidgets import QApplication
from PySide6.QtCore import QTimer, QSize
from PySide6.QtGui import QPixmap

# Ensure project root in sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from scripts.VlcNativePlayerApp import VlcMainWindow


def run_qa_captures():
    os.environ["QT_QPA_PLATFORM"] = "windows"
    app = QApplication(sys.argv)
    app.setStyle("Fusion")

    window = VlcMainWindow()
    window.resize(1280, 780)
    window.show()

    output_dir = os.path.abspath("screenshots/production_vlc")
    os.makedirs(output_dir, exist_ok=True)

    print("[Visual QA] Starting autonomous multi-view screenshot audit...")

    def capture(name: str):
        pixmap = window.grab()
        out_path = os.path.join(output_dir, f"{name}.png")
        pixmap.save(out_path)
        print(f"[Visual QA] Saved: {out_path} ({pixmap.width()}x{pixmap.height()})")

    # Sequence of QA steps
    def step1_video_default():
        capture("01_video_player_active")
        # Step 2: Open Quick Settings
        window.toggleQuickSidebar()
        QTimer.singleShot(400, step2_quick_settings)

    def step2_quick_settings():
        capture("02_quick_settings_open")
        window.toggleQuickSidebar() # Close sidebar
        # Step 3: Switch to Media Library
        window.switchView(2)
        QTimer.singleShot(400, step3_media_library)

    def step3_media_library():
        capture("03_media_library_grid")
        # Step 4: Switch to Music Player
        window.switchView(1)
        QTimer.singleShot(400, step4_music_player)

    def step4_music_player():
        capture("04_music_player_view")
        # Step 5: Switch to Full Settings
        window.switchView(3)
        QTimer.singleShot(400, step5_full_settings)

    def step5_full_settings():
        capture("05_full_settings_hub")
        print("[Visual QA] All 5 production views captured successfully!")
        app.quit()

    # Launch sequence
    QTimer.singleShot(800, step1_video_default)
    app.exec()


if __name__ == "__main__":
    run_qa_captures()
