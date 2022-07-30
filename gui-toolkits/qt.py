import sys
from PyQt6.QtCore import QSize, Qt
#from PyQt6.QtWidgets import QApplication, QMainWindow, QPushButton, QWidget, QVBoxLayout
from PyQt6.QtWidgets import (
    QApplication,
    QCheckBox,
    QComboBox,
    QDateEdit,
    QDateTimeEdit,
    QDial,
    QDoubleSpinBox,
    QFontComboBox,
    QLabel,
    QLCDNumber,
    QLineEdit,
    QMainWindow,
    QProgressBar,
    QPushButton,
    QRadioButton,
    QSlider,
    QSpinBox,
    QTimeEdit,
    QVBoxLayout,
    QHBoxLayout,
    QStackedLayout,
    QWidget,
)
from PyQt6.QtGui import QColor, QPalette


# **Signals** are notifications emitted by widgets when something happens.
# Every interaction the user has with a Qt application is an **event.


class MyApp(QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("Qt app demo")

        # basic empty GUI widget -- good as a widget root
        self.root = QWidget()

        self.label = QLabel(text="label 1")
        self.label.move(50, 40)
        self.label.setText("label 2")

        self.input = QLineEdit()
        self.input.move(450, 40)

        self.button = QPushButton("click")
        self.button.setFixedSize(QSize(100, 100))
        #self.button.setMinimumSize(QSize(100, 100))
        #self.button.setMaximumSize(QSize(500, 500))
        self.button.clicked.connect(self.button_click)

        self.input.returnPressed.connect(self.return_pressed)
        self.input.selectionChanged.connect(self.selection_changed)
        self.input.textChanged.connect(self.text_changed)
        self.input.textEdited.connect(self.text_edited)

        # better to use this instead of `parent=` kwarg
        self.vbox = QVBoxLayout()
        self.vbox.addWidget(self.label)
        self.vbox.addWidget(self.input)
        self.root.setLayout(self.vbox)

        # set the central widget of the window, widget will expand
        # to take up all the space in the window by default
        self.setCentralWidget(self.root)

        # widgets without a parent are invisible by default
        self.show()


    def button_click(self):
        print("clicked")

    def return_pressed(self):
        print("Return pressed!")
        self.label.setText(self.input.text())

    def selection_changed(self):
        print("Selection changed")
        print(self.input.selectedText())

    def text_changed(self, s):
        print("Text changed...")
        print(s)

    def text_edited(self, s):
        print("Text edited...")
        print(s)

    def contextMenuEvent(self, e):
        context = QMenu(self)
        context.addAction(QAction("test 1", self))
        context.addAction(QAction("test 2", self))
        context.addAction(QAction("test 3", self))
        context.exec(e.globalPos())


# custom widget
class Color(QWidget):

    def __init__(self, color):
        super(Color, self).__init__()
        self.setAutoFillBackground(True)

        palette = self.palette()
        palette.setColor(QPalette.ColorRole.Window, QColor(color))
        self.setPalette(palette)


class MainWindow(QMainWindow):

    def __init__(self):
        super().__init__()

        self.setWindowTitle("My App")

        if not True:
            layout = QHBoxLayout()
            layout2 = QVBoxLayout()
            layout3 = QVBoxLayout()

            layout.setContentsMargins(0,0,0,0)
            layout.setSpacing(20)

            layout2.addWidget(Color('red'))
            layout2.addWidget(Color('yellow'))
            layout2.addWidget(Color('purple'))

            layout.addLayout(layout2)

            layout.addWidget(Color('green'))

            layout3.addWidget(Color('red'))
            layout3.addWidget(Color('purple'))

            layout.addLayout(layout3)
        else:
            layout = QStackedLayout()

            layout.addWidget(Color("red"))
            layout.addWidget(Color("green"))
            layout.addWidget(Color("blue"))
            layout.addWidget(Color("yellow"))

            layout.setCurrentIndex(3)

        widget = QWidget()
        widget.setLayout(layout)
        self.setCentralWidget(widget)


if __name__ == '__main__':
    # only one instance of `QApplication` is needed (and allowed?) to run
    # there is only one running event loop per application
    app = QApplication(sys.argv)

    # QMainWindow is just the main Qt window and it is better not to subclass
    # QApplication itself, because it is the QMainWindow that we are changing,
    # not the QApplication
    main_window = MyApp()
    #main_window = MainWindow()
    main_window.show()

    # main Qt application execution and event loop
    app.exec()

