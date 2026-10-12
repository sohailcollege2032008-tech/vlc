"""
VLC Media Player - Reimagined (Jux Redesign)
Official Production-Grade Native Desktop Application
Integrates libvlc engine (Direct3D11 hardware acceleration) with Qt Quick QML Redesign.
"""
import os
import sys
import ctypes
from PySide6.QtWidgets import (
    QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout,
    QStackedWidget, QFileDialog, QSizePolicy
)
from PySide6.QtQuickWidgets import QQuickWidget
from PySide6.QtCore import Qt, QUrl, Slot, Signal, QSize, QTimer
from PySide6.QtGui import QIcon, QColor, QDragEnterEvent, QDropEvent

# Add project root to sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from scripts.vlc_engine import VlcEngine


class VideoSurfaceWidget(QWidget):
    """Native Win32 viewport widget for libvlc hardware Direct3D11 rendering."""
    doubleClicked = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)
        self.setAttribute(Qt.WA_NativeWindow, True)
        self.setAttribute(Qt.WA_PaintOnScreen, True)
        self.setAttribute(Qt.WA_OpaquePaintEvent, True)
        self.setStyleSheet("background-color: #0c0c0e;")
        self.setAcceptDrops(True)

    def mouseDoubleClickEvent(self, event):
        self.doubleClicked.emit()
        super().mouseDoubleClickEvent(event)


class VlcMainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("VLC Media Player - Reimagined")
        self.resize(1280, 780)
        self.setMinimumSize(960, 600)
        self.setStyleSheet("background-color: #0a0a0c;")
        self.setAcceptDrops(True)

        # Set application icon
        icon_path = os.path.abspath("modules/gui/qt/resources/icons/vlc.svg")
        if os.path.exists(icon_path):
            self.setWindowIcon(QIcon(icon_path))

        # Initialize VLC Engine
        self.engine = VlcEngine(self)

        # Main Central Container
        central_widget = QWidget(self)
        self.setCentralWidget(central_widget)
        main_vbox = QVBoxLayout(central_widget)
        main_vbox.setContentsMargins(0, 0, 0, 0)
        main_vbox.setSpacing(0)

        # ==================== 1. TOP BAR (QML) ====================
        self.topbar_widget = QQuickWidget(self)
        self.topbar_widget.setFixedHeight(42)
        self.topbar_widget.setResizeMode(QQuickWidget.SizeRootObjectToView)
        self.topbar_widget.rootContext().setContextProperty("VlcEngine", self.engine)
        self.topbar_widget.rootContext().setContextProperty("MainWindow", self)
        
        topbar_qml = os.path.abspath("scripts/qml_components/AppTopBar.qml")
        self.topbar_widget.setSource(QUrl.fromLocalFile(topbar_qml))
        main_vbox.addWidget(self.topbar_widget)

        # ==================== 2. CENTER CONTENT STACK ====================
        content_hbox = QHBoxLayout()
        content_hbox.setContentsMargins(0, 0, 0, 0)
        content_hbox.setSpacing(0)

        self.stack = QStackedWidget(self)
        content_hbox.addWidget(self.stack, 1)

        # --- Stack Page 0: Video Player Canvas ---
        video_page = QWidget(self)
        video_vbox = QVBoxLayout(video_page)
        video_vbox.setContentsMargins(0, 0, 0, 0)
        video_vbox.setSpacing(0)

        self.video_surface = VideoSurfaceWidget(video_page)
        self.video_surface.doubleClicked.connect(self.toggle_fullscreen)
        video_vbox.addWidget(self.video_surface)
        self.stack.addWidget(video_page)

        # --- Stack Page 1: Music View (QML) ---
        self.music_widget = QQuickWidget(self)
        self.music_widget.setResizeMode(QQuickWidget.SizeRootObjectToView)
        self.music_widget.rootContext().setContextProperty("VlcEngine", self.engine)
        self.music_widget.rootContext().setContextProperty("MainWindow", self)
        music_qml = os.path.abspath("scripts/qml_components/MusicPlayerPage.qml")
        self.music_widget.setSource(QUrl.fromLocalFile(music_qml))
        self.stack.addWidget(self.music_widget)

        # --- Stack Page 2: Media Library View (QML) ---
        self.library_widget = QQuickWidget(self)
        self.library_widget.setResizeMode(QQuickWidget.SizeRootObjectToView)
        self.library_widget.rootContext().setContextProperty("VlcEngine", self.engine)
        self.library_widget.rootContext().setContextProperty("MainWindow", self)
        lib_qml = os.path.abspath("scripts/qml_components/MediaLibraryPage.qml")
        self.library_widget.setSource(QUrl.fromLocalFile(lib_qml))
        self.stack.addWidget(self.library_widget)

        # --- Stack Page 3: Full Settings Hub (QML) ---
        self.settings_widget = QQuickWidget(self)
        self.settings_widget.setResizeMode(QQuickWidget.SizeRootObjectToView)
        self.settings_widget.rootContext().setContextProperty("VlcEngine", self.engine)
        self.settings_widget.rootContext().setContextProperty("MainWindow", self)
        settings_qml = os.path.abspath("scripts/qml_components/FullSettingsPage.qml")
        self.settings_widget.setSource(QUrl.fromLocalFile(settings_qml))
        self.stack.addWidget(self.settings_widget)

        # ==================== 3. QUICK SETTINGS SIDEBAR (QML) ====================
        self.sidebar_widget = QQuickWidget(self)
        self.sidebar_widget.setFixedWidth(380)
        self.sidebar_widget.setResizeMode(QQuickWidget.SizeRootObjectToView)
        self.sidebar_widget.rootContext().setContextProperty("VlcEngine", self.engine)
        self.sidebar_widget.rootContext().setContextProperty("MainWindow", self)
        sidebar_qml = os.path.abspath("scripts/qml_components/QuickSettingsSidebarPage.qml")
        self.sidebar_widget.setSource(QUrl.fromLocalFile(sidebar_qml))
        self.sidebar_widget.setVisible(False)
        content_hbox.addWidget(self.sidebar_widget)

        main_vbox.addLayout(content_hbox, 1)

        # ==================== 4. BOTTOM CONTROL BAR (QML) ====================
        self.controlbar_widget = QQuickWidget(self)
        self.controlbar_widget.setFixedHeight(54)
        self.controlbar_widget.setResizeMode(QQuickWidget.SizeRootObjectToView)
        self.controlbar_widget.rootContext().setContextProperty("VlcEngine", self.engine)
        self.controlbar_widget.rootContext().setContextProperty("MainWindow", self)
        controlbar_qml = os.path.abspath("scripts/qml_components/PlayerControlBarPage.qml")
        self.controlbar_widget.setSource(QUrl.fromLocalFile(controlbar_qml))
        main_vbox.addWidget(self.controlbar_widget)

        # Bind native HWND to VLC
        QTimer.singleShot(100, self._bind_hwnd)

        # Auto-load demo media if available
        demo_video = os.path.abspath("media/The_Wand_S01E05.mp4")
        if os.path.exists(demo_video):
            QTimer.singleShot(300, lambda: self.engine.openFile(demo_video))

    def _bind_hwnd(self):
        hwnd = int(self.video_surface.winId())
        self.engine.bind_video_hwnd(hwnd)
        print(f"[VlcMainWindow] Bound libvlc to HWND: {hwnd}")

    # ==================== SLOTS FOR QML / ACTIONS ====================

    @Slot(int)
    def switchView(self, index: int):
        """Switch views (0: Video, 1: Music, 2: Library, 3: Settings)."""
        self.stack.setCurrentIndex(index)
        if index == 2:  # Media Library
            self.engine.scanMediaFolder(os.path.abspath("media"))

    @Slot()
    def toggleQuickSidebar(self):
        """Toggle 380px Quick Settings Sidebar."""
        self.sidebar_widget.setVisible(not self.sidebar_widget.isVisible())

    @Slot()
    def openFileDialog(self):
        """Show native Windows file picker dialog."""
        file_path, _ = QFileDialog.getOpenFileName(
            self,
            "Open Media File",
            os.path.abspath("media"),
            "Media Files (*.mp4 *.mkv *.avi *.mov *.wmv *.webm *.mp3 *.wav *.flac);;All Files (*.*)"
        )
        if file_path:
            self.switchView(0)
            self.engine.openFile(file_path)

    @Slot()
    def toggle_fullscreen(self):
        if self.isFullScreen():
            self.showNormal()
            self.topbar_widget.setVisible(True)
            self.controlbar_widget.setVisible(True)
        else:
            self.showFullScreen()

    def keyPressEvent(self, event):
        key = event.key()
        if key == Qt.Key_Space:
            self.engine.togglePlayPause()
        elif key == Qt.Key_Left:
            self.engine.jumpSeconds(-10)
        elif key == Qt.Key_Right:
            self.engine.jumpSeconds(10)
        elif key == Qt.Key_Up:
            self.engine.setVolume(self.engine._volume + 5)
        elif key == Qt.Key_Down:
            self.engine.setVolume(self.engine._volume - 5)
        elif key == Qt.Key_M:
            self.engine.toggleMute()
        elif key == Qt.Key_F or key == Qt.Key_F11:
            self.toggle_fullscreen()
        elif key == Qt.Key_Escape and self.isFullScreen():
            self.toggle_fullscreen()
        elif key == Qt.Key_Q:
            self.toggleQuickSidebar()
        elif key == Qt.Key_O and (event.modifiers() & Qt.ControlModifier):
            self.openFileDialog()
        super().keyPressEvent(event)

    def dragEnterEvent(self, event: QDragEnterEvent):
        if event.mimeData().hasUrls():
            event.acceptProposedAction()

    def dropEvent(self, event: QDropEvent):
        urls = event.mimeData().urls()
        if urls:
            path = urls[0].toLocalFile()
            if os.path.exists(path):
                self.switchView(0)
                self.engine.openFile(path)


def main():
    app = QApplication(sys.argv)
    app.setApplicationName("VLC Media Player - Reimagined")
    app.setStyle("Fusion")

    window = VlcMainWindow()
    window.show()

    # Bring to foreground on Windows
    if sys.platform == "win32":
        try:
            hwnd = int(window.winId())
            ctypes.windll.user32.SetForegroundWindow(hwnd)
        except Exception:
            pass

    sys.exit(app.exec())


if __name__ == "__main__":
    main()
