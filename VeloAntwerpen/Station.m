//
//  Station.m
//  VeloAntwerpen
//
//  Created by Tom Nys on 22/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import "Station.h"

@implementation Station

@synthesize name, latitude, longitude, free, slots;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)dealloc
{
	self.name = nil;
	[super dealloc];
}

@end
