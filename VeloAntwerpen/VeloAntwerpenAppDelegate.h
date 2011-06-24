//
//  VeloAntwerpenAppDelegate.h
//  VeloAntwerpen
//
//  Created by Tom Nys on 22/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface VeloAntwerpenAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate> {
	NSArray* stations;
	CLLocation* currentLocation;
	CLLocationManager* locationManager;
	NSTimer* reloadTimer;
}

@property (nonatomic, readonly) NSArray* stations; 
@property (nonatomic, readonly) CLLocation* currentLocation;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
