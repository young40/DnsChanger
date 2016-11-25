//
//  main.swift
//  sysconf_helper
//
//  Created by Peter Young on 25/11/2016.
//  Copyright © 2016 Peter Young. All rights reserved.
//

import Foundation

print("Hello, World!")

var argc = CommandLine.argc
var argv = CommandLine.arguments

//argv.append("Wi-Fi")
//
//argv.append("119.29.29.29")
//argv.append("114.114.114.114")
//
//argc = Int32(argv.count)

print(argv)

if argc < 3 {
    print("arguments not enough")
    
    exit(-1)
}

var params: [String] = ["-setdnsservers"]

for index in 1 ... (argc - 1) {
    params.append(argv[Int(index)])
}

var dns: [String] = []

let task = Process()
let pipe = Pipe()

task.launchPath = "/usr/sbin/networksetup"
task.arguments = params
task.standardOutput = pipe
task.standardError = pipe

task.launch()

let data = pipe.fileHandleForReading.readDataToEndOfFile()
if let rs = String(data: data, encoding: String.Encoding.utf8) {
    print("done")
    print(rs)
}
