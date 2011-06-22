//
//  AddressAnnotation.m
//  EasyMinders
//
//  Created by Tom Nys on 19/06/10.
//  Copyright 2010 Netwalk. All rights reserved.
//

#import "StationAnnotation.h"


@implementation StationAnnotation

@synthesize station, coordinate;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	return self;
}

-(void)setStation:(Station *)s{
	if (s != station)
	{
		[station release];
		station = [s retain];
		coordinate = CLLocationCoordinate2DMake(station.latitude, station.longitude);
	}
}

-(NSString*)title
{
	return station.name;
}

-(NSString*)subtitle
{
	return [NSString stringWithFormat:@"%d slots, %d free", station.slots, station.free];
}

@end
