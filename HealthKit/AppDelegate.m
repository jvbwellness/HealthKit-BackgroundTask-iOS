//
//  AppDelegate.m
//  HealthKit
//
//  Created by Sushma S7works on 13/02/19.
//  Copyright © 2019 Sushma S7works. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /**
     Added method to check App state and if the app is installed or not., currently Not using.
     */
    //and create new timer with async call:
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //run function after every 900 seconds OR 15 mins
        NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:20  target:self selector:@selector(checkAppState:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
    
    
    
    return YES;
}


/**
 Method to check App state(Active, Killed OR InActive)
 and
 if App is installed or not.
 */
- (void) checkAppState: (NSTimer *)timer {
//    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
//        // do something
//        NSLog(@" 123---> application was not active  ");
//    } else if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
//        NSLog(@" 123---> app is in background");
//    }else {
//        NSLog(@" 123---> app is active ");
//    }

//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"HealthKit://"]])
//    {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"HealthKit://"]];
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App not installed on Device"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Open link", nil];
//        [alert show];
//    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    /**
     Calling background method from ViewController
     */
    ViewController *view=[[ViewController alloc]init];
    [view startRNBackgroundTask];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    /**
     Calling the method for checking the killed state of the app.
     */
    ViewController *view=[[ViewController alloc]init];
    [view runTaskInKilledState];
}


@end
