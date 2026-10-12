import sys
import os
import time
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuick import QQuickItem, QQuickWindow
from PySide6.QtCore import QUrl, QTimer, Qt

def main():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.addImportPath(os.path.abspath("scripts/mock_modules"))
    engine.addImportPath(os.path.abspath("modules/gui/qt"))
    engine.warnings.connect(lambda warnings: [print("QML Warning:", w.toString()) for w in warnings])

    qml_file = os.path.abspath("scripts/PlayerWindow.qml")
    engine.load(QUrl.fromLocalFile(qml_file))

    if not engine.rootObjects():
        print("ERROR: Failed to load QML root object!")
        sys.exit(-1)

    window = engine.rootObjects()[0]
    out_dir = os.path.abspath("screenshots")
    os.makedirs(out_dir, exist_ok=True)

    step = 0
    def take_capture():
        nonlocal step
        if step == 0:
            # 1. Default Player
            img = window.grabWindow()
            p = os.path.join(out_dir, "01_player_default.png")
            img.save(p)
            print(f"Captured: {p}")
            # Open quick settings
            window.setProperty("isQuickSettingsOpen", True)
            step += 1
            QTimer.singleShot(400, take_capture)
        elif step == 1:
            # 2. Quick Settings Sidebar
            img = window.grabWindow()
            p = os.path.join(out_dir, "02_quick_settings_sidebar.png")
            img.save(p)
            print(f"Captured: {p}")
            # Close quick settings and open subtitles modal
            window.setProperty("isQuickSettingsOpen", False)
            window.setProperty("isAddSubsOpen", True)
            step += 1
            QTimer.singleShot(400, take_capture)
        elif step == 2:
            # 3. Add Subtitles Dialog
            img = window.grabWindow()
            p = os.path.join(out_dir, "03_subtitles_dialog.png")
            img.save(p)
            print(f"Captured: {p}")
            # Close subtitles and open full settings
            window.setProperty("isAddSubsOpen", False)
            window.setProperty("isFullSettingsOpen", True)
            step += 1
            QTimer.singleShot(400, take_capture)
        elif step == 3:
            # 4. Full Settings Reimagined
            img = window.grabWindow()
            p = os.path.join(out_dir, "04_full_settings.png")
            img.save(p)
            print(f"Captured: {p}")
            print("All 4 screens successfully captured!")
            app.quit()

    QTimer.singleShot(300, take_capture)
    sys.exit(app.exec())

if __name__ == "__main__":
    main()
