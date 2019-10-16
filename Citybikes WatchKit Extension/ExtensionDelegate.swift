//
//  ExtensionDelegate.swift
//  Citybikes WatchKit Extension
//
//  Created by Wojtek Siudzinski on 24/09/2019.
//  Copyright © 2019 Gaia Green Tech. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate, LocatorProtocol {
    var model: StationModel?
    let refreshMinutes: TimeInterval = 1
    var backgroundTask: WKRefreshBackgroundTask?
    var locator: Locator!
    var backgroundTaskScheduled = false

    override init() {
        super.init()

        self.locator = Locator()
        self.locator.delegate = self
    }

    public func scheduleBackgroundTask() {
        if self.backgroundTaskScheduled {
            print("scheduling canceled, another background task is already scheduled")
            return
        }
        self.backgroundTaskScheduled = true
        let timeInterval: TimeInterval = 10 * refreshMinutes
        let fireDate = Date().addingTimeInterval(timeInterval)

        let userInfo: NSDictionary = NSDictionary(dictionary: ["refresh": "complication", "time": fireDate])

        // Schedule background task
        WKExtension.shared().scheduleBackgroundRefresh(
            withPreferredDate: fireDate,
            userInfo: userInfo,
            scheduledCompletion: scheduledCompletionHandler(_:)
        )

        print("Scheduled background task, will fire at \(fireDate)")
    }

    private func scheduledCompletionHandler(_ error: Error?) {
        if let error = error {
            print("Failed to schedule a completion handler: \(error)")
        }
    }

    private func updateComplication(task: WKApplicationRefreshBackgroundTask) {
        print("updateComplication")
        let server =  CLKComplicationServer.sharedInstance()

        guard server.activeComplications != nil else {
            task.setTaskCompletedWithSnapshot(false)
            return
        }

        self.backgroundTask = task
        locator.doUpdate()
    }

    private func releaseBackgroundTask(doShapshot: Bool) {
        print("releaseBackgroundTask")
        if self.backgroundTask != nil {
            self.backgroundTask?.setTaskCompletedWithSnapshot(doShapshot)
            self.backgroundTask = nil
        }
        self.backgroundTaskScheduled = false
    }

    // MARK: - WKExtensionDelegate

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        model = StationModel()
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive.
        // If the application was previously in the background, optionally refresh the user interface.
        locator.doUpdate()
        scheduleBackgroundTask()
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of
        // temporary interruptions (such as an incoming phone call or SMS message) or when the user quits
        // the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
        // scheduleBackgroundTask()
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks.
        // Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                updateComplication(task: backgroundTask)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(
                    restoredDefaultState: true,
                    estimatedSnapshotExpiration: Date.distantFuture,
                    userInfo: nil
                )
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }

    // MARK: - LocatorProtocol

    func locationUpdated(_ locator: Locator) {
        print("locationUpdated")

        let server =  CLKComplicationServer.sharedInstance()
        guard let complications = server.activeComplications else {
            return
        }
        for complication in complications {
            //full reload is crude but since we arent adding to a timeline, it's ok for our needs
            server.reloadTimeline(for: complication)
        }
        releaseBackgroundTask(doShapshot: false)
        scheduleBackgroundTask()
    }

    func locatorError(error: Error) {
        print("locatorError \(error)")
        releaseBackgroundTask(doShapshot: false)
        scheduleBackgroundTask()
    }
}
