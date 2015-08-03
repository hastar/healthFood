//
//  AppDelegate.m
//  healthfood
//
//  Created by lanou on 15/6/22.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "AppDelegate.h"
#import "CategoryModel.h"
#import "ViewController.h"

#import "DataBaseHandle.h"
#import "AFNetworking.h"

@interface AppDelegate ()



@end

@implementation AppDelegate

-(void)dealloc
{
    [_viewVC release];
    [_window release];
    
    [super dealloc];
}

-(void)saveData
{
    [[NSUserDefaults standardUserDefaults] setObject:self.viewVC.category.title forKey:@"Category"];
    [[NSUserDefaults standardUserDefaults] setObject:self.viewVC.category.idArray forKey:@"CategroyId"];
    
    NSLog(@"类目名称保存成功");
    [DataBaseHandle saveLocalListModels:self.viewVC.modelArray withLimit:20];
    
}
-(void)readData
{
    self.viewVC.category = [[CategoryModel alloc]init];
    self.viewVC.category.title = [[NSUserDefaults standardUserDefaults] objectForKey:@"Category"];
    
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:@"CategroyId"];
    
    self.viewVC.category.idArray = (NSArray *)object;
    NSLog(@"%@", self.viewVC.category.title);
    self.viewVC.modelArray = [[[NSMutableArray alloc] initWithArray:[DataBaseHandle readLocalListModels]] autorelease];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    
    self.viewVC = [[[ViewController alloc] init] autorelease];
    
    
    [self readData];
    
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:self.viewVC] autorelease];
    nav.navigationBarHidden = YES;
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"进入后台,开始保存数据");
    [self saveData];
    
    NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveData];
    NSLog(@"applicationWillTerminate");
}



@end
