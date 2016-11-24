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

    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let data = self.getData()
        
        let dns = self.getDns()
        
        self.initMenu(data: data, dnsList: dns)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func initMenu(data: [String: [String]], dnsList: [String]) {
        let menu = NSMenu(title: "DnsChanger")
        
        let itemDefault = NSMenuItem(title: "Default", action: #selector(setDefaultDns), keyEquivalent: "")
        menu.addItem(itemDefault)
        if dnsList.count == 0 {
            itemDefault.state = NSOnState
        }
        
        menu.addItem(NSMenuItem.separator())
        
        if let dns = data["dns"] {
            for d in dns {
                let itemNew = NSMenuItem(title: d, action: #selector(setDnsByMenu), keyEquivalent: "")
                
                if dnsList.contains(d) {
                    itemNew.state = NSOnState
                }
                
                menu.addItem(itemNew)
            }
        }
        
        menu.addItem(NSMenuItem.separator())
        let itemQuit = NSMenuItem(title: "Quit", action: #selector(exit), keyEquivalent: "")
        menu.addItem(itemQuit)
        
        statusItem.menu = menu
        statusItem.title = "D"
    }
    
    func getData() -> [String: [String]] {
        let dataFile = NSHomeDirectory().appending("/dnschanger.json")
        
        if let data = try? Data(contentsOf: URL(fileURLWithPath: dataFile)) {
            do {
                let obj = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! [String: [String]]
                
                return obj
            }
            catch let error as Error {
                print("error:\n \(error)")
            }
        }
        
        return ["dns": ["119.29.29.29"]]
    }
    
    func setDefaultDns(sender: NSMenuItem) {
        self.setDns(dns: "empty")
        
        let dns = self.getDns()
        statusItem.menu?.item(at: 0)?.state = dns.count > 0 ? NSOffState : NSOnState
        
        for index in  1 ... statusItem.menu!.numberOfItems - 1 {
            if let item = statusItem.menu!.item(at: index) {
                if !item.isSeparatorItem {
                    item.state = dns.contains(item.title) ? NSOnState : NSOffState
                }
            }
        }
    }
    
    func setDnsByMenu(sender: NSMenuItem) {
        let title = sender.title
        
        var dnsBefor = self.getDns()
        
        if dnsBefor.contains(title) {
            dnsBefor = dnsBefor.filter() {$0 != title}
        } else {
            dnsBefor.append(title)
        }
        var newDNS = dnsBefor.joined(separator: " ")
        
        if dnsBefor.count == 0 {
            newDNS = "empty"
        }
        
        self.setDns(dns: newDNS)
        
        let dns = self.getDns()
        statusItem.menu?.item(at: 0)?.state = dns.count > 0 ? NSOffState : NSOnState
        sender.state = dns.contains(title) ? NSOnState : NSOffState
    }
    
    func exit(sender: AnyObject) {
        NSApplication.shared().terminate(sender)
    }
    
    private func setDns(dns: String) {
        let shell = "do shell script \"networksetup -setdnsservers Wi-Fi " + dns + "\""
        
        let appleScript = NSAppleScript.init(source: shell)
        appleScript?.executeAndReturnError(nil)
    }
    
    private func getDns() -> [String] {
        var dns: [String] = []
        
        let task = Process()
        let pipe = Pipe()
        
        task.launchPath = "/usr/sbin/networksetup"
        task.arguments = ["-getdnsservers", "Wi-Fi"]
        task.standardOutput = pipe
        
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let rs = String(data: data, encoding: String.Encoding.utf8) {
            let c = rs[rs.startIndex ... rs.index(rs.startIndex, offsetBy: 0)]
            
            if let num = Int(c) {
                dns = rs.characters.split(separator: "\n").map(String.init)
            }
        }
        
        return dns
    }
}

