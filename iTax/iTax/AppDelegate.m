//
//  AppDelegate.m
//  iTax
//
//  Created by Paddy-long on 16/3/29.
//  Copyright © 2016年 Paddy-long. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    RootViewController *viewc = [[RootViewController alloc] initWithNibName:NSStringFromClass([RootViewController class]) bundle:Nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewc];
    self.window.rootViewController = nav;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
