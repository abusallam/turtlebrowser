import QtQml 2.15
import QtQml.Models 2.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

FramelessTopLevelWindow {
    id: window

    visibility: Window.Maximized

    property QtObject globalContext
    property Item currentPage: pagesStack.currentPage
    property QtObject windowProfile
    property bool windowOffTheRecord: windowProfile ? windowProfile.offTheRecord : false

    onWindowProfileChanged: {
        if (windowProfile) {
            tabBar.makeNewTab()
        }
    }

    function getTitle(currentIndex) {
        var current = tabModel.get(currentIndex)
        return current ? current.tabTitle + " - " : ""
    }

    title: getTitle(tabBar.currentIndex) + "TurtleBrowser"

    ListModel {
        id: tabModel
    }

    ColumnLayout {

        anchors.fill: parent
        anchors.margins: window.visibility === Window.Windowed ? window.windowMargin : 0
        spacing: 0

        TabToolbar {
            id: tabBar
            Layout.maximumWidth: window.width
            height: 40
            currentIndex: pagesStack.currentIndex
            model: tabModel
            offTheRecord: window.windowOffTheRecord
        }

        StackLayout {
            id: pagesStack
            currentIndex: tabBar.currentIndex

            property Item currentPage

            onCurrentIndexChanged: {
                var currentItem = pages.itemAt(currentIndex)
                if (currentItem)
                    currentPage = currentItem.view
                else
                    currentPage = null
            }

            Repeater {
                id: pages
                model: tabModel

                Layout.fillWidth: true
                Layout.fillHeight: true

                WebPage {
                    id: page
                    windowProfile: window.windowProfile
                    offTheRecord: window.windowOffTheRecord
                    Component.onCompleted: address = tabUrl

                    onTitleChanged: tabTitle = page.title
                    onAddressChanged: tabUrl = page.address
                }
            }
        }
    }

    Action {
        shortcut: "Ctrl+T"
        onTriggered: tabBar.makeNewTab()
    }

    Action {
        shortcut: "Ctrl+W"
        onTriggered: tabBar.closeCurrentTab()
    }

    Action {
        shortcut: "F11"
        onTriggered: {
            if (window.visibility == Window.FullScreen) {
                window.visibility = Window.Maximized
            } else {
                window.visibility = Window.FullScreen
            }
        }
    }

    Action {
        shortcut: "Ctrl+Q"
        onTriggered: Qt.quit()
    }

    Action {
        shortcut: "Ctrl+N"
        onTriggered: globalContext.createPublicWindow()
    }

    Action {
        shortcut: "Ctrl+Shift+N"
        onTriggered: globalContext.createPrivateWindow()
    }
}
