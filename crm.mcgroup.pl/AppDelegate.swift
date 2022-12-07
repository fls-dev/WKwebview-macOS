//
//  AppDelegate.swift
//  crm.mcgroup.pl
//
//  Created by Pavel Misko on 30.11.22.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var tabService: TabService!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        replaceTabServiceWithInitialWindow()
        
    }

    /// Fallback for the menu bar action when all windows are closed.
    @IBAction func newWindowForTab(_ sender: Any?) {

        if let existingWindow = tabService.mainWindow {
            tabService.createTab(newWindowController: WindowController.create(),
                                 inWindow: existingWindow,
                                 ordered: .above)
        } else {
            replaceTabServiceWithInitialWindow()
        }
    }
    

    private func replaceTabServiceWithInitialWindow() {
        let windowController = WindowController.create()
        windowController.showWindow(self)
        tabService = TabService(initialWindowController: windowController)
    }


    
}
