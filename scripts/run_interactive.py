import sys
import os
import ctypes
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl, QTimer

def main():
    os.environ["QT_AUTO_SCREEN_SCALE_FACTOR"] = "1"
    
    app = QApplication(sys.argv)
    app.setApplicationName("VLC Media Player - Reimagined")
    app.setOrganizationName("VideoLAN")

    engine = QQmlApplicationEngine()
    
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    
    engine.addImportPath(os.path.join(script_dir, "mock_modules"))
    engine.addImportPath(os.path.join(project_root, "modules", "gui", "qt"))
    
    engine.warnings.connect(lambda warnings: [print("QML Warning:", w.toString()) for w in warnings])

    qml_file = os.path.join(script_dir, "InteractiveVlcApp.qml")
    print(f"Loading Interactive VLC Redesign: {qml_file}")
    
    engine.load(QUrl.fromLocalFile(qml_file))

    if not engine.rootObjects():
        print("ERROR: Failed to load QML root object!")
        sys.exit(-1)

    win = engine.rootObjects()[0]
    win.show()
    win.raise_()
    win.requestActivate()

    # Force window to foreground on Windows desktop
    def bring_to_front():
        try:
            hwnd = int(win.winId())
            user32 = ctypes.windll.user32
            user32.SetWindowPos(hwnd, -1, 0, 0, 0, 0, 0x0001 | 0x0002 | 0x0040)
            user32.ShowWindow(hwnd, 9)  # SW_RESTORE
            user32.SetForegroundWindow(hwnd)
            user32.BringWindowToTop(hwnd)
            user32.SwitchToThisWindow(hwnd, True)
            print(f"Window brought to foreground: HWND {hex(hwnd)}")
        except Exception as e:
            print(f"Foreground notice: {e}")

    QTimer.singleShot(250, bring_to_front)

    print("SUCCESS: VLC Redesign Interactive Window is now running on your desktop!")
    print("Press Ctrl+C or close the window to exit.")
    
    sys.exit(app.exec())

if __name__ == "__main__":
    main()
