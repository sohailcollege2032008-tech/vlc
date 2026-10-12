import sys
import os
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuick import QQuickItem, QQuickWindow
from PySide6.QtCore import QUrl, QTimer

def capture_file(app, qml_path, output_path):
    engine = QQmlApplicationEngine()
    engine.addImportPath(os.path.abspath("scripts/mock_modules"))
    engine.addImportPath(os.path.abspath("modules/gui/qt"))
    engine.warnings.connect(lambda ws: [print("QML Warning:", w.toString()) for w in ws])

    engine.load(QUrl.fromLocalFile(os.path.abspath(qml_path)))
    if not engine.rootObjects():
        print(f"ERROR loading QML for {output_path}")
        return False

    window = engine.rootObjects()[0]
    app.processEvents()
    
    img = window.grabWindow()
    img.save(output_path)
    print(f"Captured: {output_path}")
    return True

def main():
    app = QGuiApplication(sys.argv)
    out_dir = os.path.abspath("screenshots")
    os.makedirs(out_dir, exist_ok=True)

    capture_file(app, "scripts/ToolbarEditorWindow.qml", os.path.join(out_dir, "05_toolbar_editor.png"))
    capture_file(app, "scripts/MusicPlayerWindow.qml", os.path.join(out_dir, "06_music_player.png"))
    capture_file(app, "scripts/MediaLibraryWindow.qml", os.path.join(out_dir, "07_media_library.png"))

    print("All additional screens successfully captured!")

if __name__ == "__main__":
    main()
