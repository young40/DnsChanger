//
//  AppDelegate.swift
//  DnsChanger
//
//  Created by Peter Young on 18/11/2016.
//  Copyright © 2016 Peter Young. All rights reserved.
//

import Cocoa
import AppleScriptKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        self.initMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func initMenu() {
        let menu = NSMenu(title: "DnsChanger")
        
        let itemDefault = NSMenuItem(title: "Default", action: #selector(setDefaultDns), keyEquivalent: "Default")
        let item119292929 = NSMenuItem(title: "119.29.29.29", action: #selector(setDnsByMenu), keyEquivalent: "119.29.29.29")
        let itemQuit = NSMenuItem(title: "Quit", action: #selector(exit), keyEquivalent: "Quit")
        
        menu.addItem(itemDefault)
        menu.addItem(item119292929)
        menu.addItem(itemQuit)
        
        statusItem.menu = menu
        statusItem.title = "D"
    }
    
    func setDefaultDns(sneder: AnyObject) {
        self.setDns(dns: "empty")
    }
    
    func setDnsByMenu(sender: NSMenuItem) {
        let dns = sender.title
        self.setDns(dns: dns)
    }
    
    func exit(sender: AnyObject) {
        NSApplication.shared().terminate(sender)
    }
    
    private func setDns(dns: String) {
        let shell = "do shell script \"networksetup -setdnsservers Wi-Fi " + dns + "\""
        
        let appleScript = NSAppleScript.init(source: shell)
        appleScript?.executeAndReturnError(nil)
    }
}

