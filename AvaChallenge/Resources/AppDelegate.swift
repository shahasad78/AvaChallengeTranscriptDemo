//
//  AppDelegate.swift
//  AvaChallenge
//
//  Created by Richard Martinez on 8/7/16.
//  Copyright © 2016 PhantomUniversalMediaProductions. All rights reserved.
//

import UIKit
import AVFoundation
import PubNub

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PNObjectEventListener {

    var window: UIWindow?

    var client: PubNub?

    override init() {
        super.init()

        let configuration = PNConfiguration(publishKey: "pub-c-6590f75c-b2bb-4acc-9922-d5fe5aa8dec9",
                                          subscribeKey: "sub-c-897a7150-da55-11e5-9ce2-0619f8945a4f")
        self.client = PubNub.clientWithConfiguration(configuration)

        configuration.uuid = "00001aa2"
        self.client?.addListener(self)
    }

    func client(_ client: PubNub!, didReceiveMessage message: PNMessageResult!) {
        if message.data.actualChannel != nil {

        } else {

        }

        print("Received message: \(message.data.message) on channel " +
                "\((message.data.actualChannel ?? message.data.subscribedChannel)!) at " +
                "\(message.data.timetoken)")
    }

    func client(_ client: PubNub!, didReceivePresenceEvent event: PNPresenceEventResult!) {
    }

    func client(_ client: PubNub!, didReceiveStatus status: PNStatus!) {
        // Select last object from list of channels and send message to it.
        let targetChannel = "00001aa2"
        client.publish("Hello from the AvaChallenge Test Device", toChannel: targetChannel,
                compressed: false, withCompletion: { (status) -> Void in

            if !status.error {

                // Message successfully published to specified channel.
            } else {

                // Handle message publish error. Check 'category' property
                // to find out possible reason because of which request did fail.
                // Review 'errorData' property (which has PNErrorData data type) of status
                // object to get additional information about issue.
                //
                // Request can be resent using: status.retry()
            }
        })
    }


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        registerDefaults()
        self.client?.subscribeToChannels(["00001aa2"], withPresence: true)
        return true
    }

    func registerDefaults() {
        var factorySettings = [String: AnyObject]()
        factorySettings["Pitch"]  = 1.0
        factorySettings["DefaultRate"] = AVSpeechUtteranceDefaultSpeechRate
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

