import sys
import os
from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl

def main():
    # Set high DPI attributes
    os.environ["QT_AUTO_SCREEN_SCALE_FACTOR"] = "1"
    
    app = QGuiApplication(sys.argv)
    app.setApplicationName("VLC Media Player - Reimagined")
    app.setOrganizationName("VideoLAN")

    engine = QQmlApplicationEngine()
    
    # Add imports
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

    print("SUCCESS: VLC Redesign Interactive Window is now running on your desktop!")
    print("Press Ctrl+C or close the window to exit.")
    
    sys.exit(app.exec())

if __name__ == "__main__":
    main()
