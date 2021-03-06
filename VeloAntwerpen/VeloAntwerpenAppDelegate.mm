//
//  VeloAntwerpenAppDelegate.m
//  VeloAntwerpen
//
//  Created by Tom Nys on 22/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import "VeloAntwerpenAppDelegate.h"
#import "tinyxml.h"
#import "Station.h"
#import "ASIFormDataRequest.h"

#import <CoreLocation/CoreLocation.h>


#define REFRESHVALUE				60*5

@implementation VeloAntwerpenAppDelegate


@synthesize window=_window, stations, currentLocation, networkQueue;

@synthesize tabBarController=_tabBarController;

-(void)reload:(NSTimer*)timer
{
	[self reload];
}

-(void)reload
{
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		NSMutableArray* res = [NSMutableArray arrayWithCapacity:100];
		NSError* err;
		
		ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:VELO_URL]];
		[request addPostValue:@"d41d8cd98f00b204e9800998ecf8427e" forKey:@"app_id"];
		[request addPostValue:@"xml" forKey:@"output_format"];
		[request addPostValue:@"GETSTATIONS" forKey:@"action"];
		[request startSynchronous];
		
		NSString* str = [request responseString];
		
		TiXmlDocument doc2;
		doc2.Parse([str UTF8String]);
		
		TiXmlElement* root = doc2.RootElement();
		if (root)
		{
			TiXmlElement* e = 0;
			while( e = (TiXmlElement*)root->IterateChildren(e))
			{
				NSLog(@"%s", e->Value());
				if (strcmp(e->Value(), "station") == 0)
				{
					TiXmlElement* child = 0;
					Station* station = [[Station alloc] init];
					while( child = (TiXmlElement*)e->IterateChildren(child))
					{

						NSLog(@"%s", child->Value());
						if (strcmp(child->Value(), "station_name") == 0)
							if (child->GetText())
								station.name = [NSString stringWithUTF8String:child->GetText()];
						if (strcmp(child->Value(), "station_lat") == 0)
							if (child->GetText())
								station.latitude = [[NSString stringWithUTF8String:child->GetText()] doubleValue];
						if (strcmp(child->Value(), "station_lon") == 0)
							if (child->GetText())
								station.longitude = [[NSString stringWithUTF8String:child->GetText()] doubleValue];
						if (strcmp(child->Value(), "station_slots") == 0)
							if (child->GetText())
								station.slots = [[NSString stringWithUTF8String:child->GetText()] intValue];
						if (strcmp(child->Value(), "station_free") == 0)
							if (child->GetText())
								station.free = [[NSString stringWithUTF8String:child->GetText()] intValue];
						if (strcmp(child->Value(), "station_id") == 0)
							if (child->GetText())
								station.stationID = [[NSString stringWithUTF8String:child->GetText()] intValue];
						if (strcmp(child->Value(), "lastupdate") == 0)
							if (child->GetText())
								station.lastUpdate = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithUTF8String:child->GetText()] intValue]];
					}
					
					[res addObject:station];
					[station release];
				}
			}
		}		
		if ([res count])
		{
			stations = [[NSArray arrayWithArray:res] retain];
			NSData* d = [NSKeyedArchiver archivedDataWithRootObject:stations];
			NSString* cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
			[d writeToFile:[cacheFolder stringByAppendingPathComponent:@"stations.dat"] atomically:YES];
		}

//		dispatch_async(dispatch_get_main_queue(), ^(void) {
			[[NSNotificationCenter defaultCenter] postNotificationName:STATIONS_UPDATED_NOTIFICATIONNAME object:self userInfo:nil];
//		});
	});	
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	[currentLocation release];
	currentLocation = [newLocation retain];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-414821-9" 
										   dispatchPeriod:10.0 
												 delegate:nil];
	
	NSString* cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	stations = [[NSKeyedUnarchiver unarchiveObjectWithFile:[cacheFolder stringByAppendingPathComponent:@"stations.dat"]] retain];
	
	networkQueue = dispatch_queue_create("networkqueue", 0);
	dispatch_async(networkQueue, ^(void) {
		if (![[NSFileManager defaultManager] fileExistsAtPath:[cacheFolder stringByAppendingPathComponent:@"1-th.png"]])
		{
			// copy over map caches
			NSString* sourceFolder = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"cache"];
			NSDirectoryEnumerator* enumerator = [[NSFileManager defaultManager] enumeratorAtPath:sourceFolder];
			NSString *currentItemName;
			while (currentItemName = [enumerator nextObject])
			{
				[[NSFileManager defaultManager] copyItemAtPath:[sourceFolder stringByAppendingPathComponent:currentItemName] toPath:[cacheFolder stringByAppendingPathComponent:currentItemName] error:nil];
			}
		}
	});
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager startUpdatingLocation];
		
	reloadTimer = [NSTimer scheduledTimerWithTimeInterval:REFRESHVALUE target:self selector:@selector(reload:) userInfo:nil repeats:YES];

	[self reload];
	
	self.window.rootViewController = self.tabBarController;
	[self.window makeKeyAndVisible];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	[reloadTimer invalidate];
	reloadTimer = nil;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
	reloadTimer = [NSTimer scheduledTimerWithTimeInterval:REFRESHVALUE target:self selector:@selector(reload:) userInfo:nil repeats:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
	[reloadTimer invalidate];
	reloadTimer = nil;
}

- (void)dealloc
{
	dispatch_release(networkQueue);
	[reloadTimer invalidate];
	reloadTimer = nil;
	[stations release];
	[_window release];
	[_tabBarController release];
    [super dealloc];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
