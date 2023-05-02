//
//  WindowController.swift
//  crm.mcgroup.pl
//
//  Created by Pavel Misko on 6.12.22.
//

import Cocoa
import UserNotifications


var count = 0

protocol TabDelegate: AnyObject {
    func createTab(newWindowController: WindowController,
                   inWindow window: NSWindow,
                   ordered orderingMode: NSWindow.OrderingMode)
}

class WindowController: NSWindowController {

    static func create() -> WindowController {
        let windowStoryboard = NSStoryboard(name: "WindowController", bundle: nil)
        return windowStoryboard.instantiateInitialController() as! WindowController
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        count += 1
        self.window!.title = "MIACRM #\(count)"
    }

    weak var tabDelegate: TabDelegate?

    override func newWindowForTab(_ sender: Any?) {

        guard let window = self.window else { preconditionFailure("Expected window to be loaded") }
        guard let tabDelegate = self.tabDelegate else { return }

        tabDelegate.createTab(newWindowController: WindowController.create(),
                              inWindow: window,
                              ordered: .above)

        inspectWindowHierarchy()
    }

    func inspectWindowHierarchy() {
        let rootWindow = self.window!
        print("Root window", rootWindow, rootWindow.title, "has tabs:")
        rootWindow.tabbedWindows?.forEach { window in
            print("- ", window, window.title, "isKey =", window.isKeyWindow, ", isMain =", window.isMainWindow, " at ", window.frame)
        }
    }
    static let TestMessageNotification = "com.test.TestMessageNotification"
    
    @IBAction func testPrint(_ sender: Any) {
        print("PRINT BTN PRINT")
        
        let center = UNUserNotificationCenter.current()

            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted {
                    print("Yay!")
                } else {
                    print("D'oh")
                }
            }

           let content = UNMutableNotificationContent()
           content.title = "Late wake up call"
           content.body = "The early bird catches the worm, but the second mouse gets the cheese."
           content.categoryIdentifier = "alarm"
           content.userInfo = ["customData": "fizzbuzz"]
           content.sound = UNNotificationSound.default

           var dateComponents = DateComponents()
           
           let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

           let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
           center.add(request)
              
    }
}
class LocalNotificationManager {
    var notifications = [Notification]()
}
