//
//  main.swift
//  sysconf_helper
//
//  Created by Peter Young on 25/11/2016.
//  Copyright © 2016 Peter Young. All rights reserved.
//

import Foundation

//print("Hello, World!")

var argc = CommandLine.argc
var argv = CommandLine.arguments

//argv.append("Wi-Fi")
//
//argv.append("119.29.29.29")
//argv.append("114.114.114.114")
//
//argc = Int32(argv.count)

//print(argv)

if argc < 3 {
    print("arguments not enough")
    
    exit(-1)
}

var params: [String] = ["-setdnsservers"]

for index in 1 ... (argc - 1) {
    params.append(argv[Int(index)])
}

let paramStr = params.joined(separator: " ")

var error: NSDictionary?
    
let script = "do shell script \"/usr/sbin/networksetup " + paramStr + "\" with administrator privileges"

let appleScript = NSAppleScript.init(source: script)
appleScript?.executeAndReturnError(&error)

if error != nil {
    print("error: \(error)")
}
