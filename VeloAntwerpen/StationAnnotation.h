//
//  AddressAnnotation.h
//  EasyMinders
//
//  Created by Tom Nys on 19/06/10.
//  Copyright 2010 Netwalk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Station.h"

@interface StationAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	Station* station;	
}

@property (nonatomic, retain) Station* station;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@end
