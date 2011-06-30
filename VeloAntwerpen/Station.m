//
//  Station.m
//  VeloAntwerpen
//
//  Created by Tom Nys on 22/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import "Station.h"

@implementation Station

@synthesize name, latitude, longitude, free, slots, stationID, lastUpdate;

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
	self.lastUpdate = nil;
	[super dealloc];
}

-(NSString*)tableViewImageFilename
{
	NSString* cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return [cacheFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%d-tv.png", self.stationID]];
}

-(UIImage*)tableViewImage
{
	return [UIImage imageWithContentsOfFile:[self tableViewImageFilename]];
		
}
-(NSString*)thumbnailImageFilename
{
	NSString* cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return [cacheFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%d-th.png", self.stationID]];
}

-(void)thumbnailImage:(void (^)(UIImage*))block
{
	UIImage* img = [UIImage imageWithContentsOfFile:[self thumbnailImageFilename]];
	if (!img)
	{
		dispatch_queue_t queue = [[UIApplication sharedApplication].delegate networkQueue];
		dispatch_async(queue, ^(void) {
			UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%f,%f&zoom=14&size=85x85&maptype=roadmap&sensor=true", self.latitude, self.longitude]]]];
			[UIImagePNGRepresentation(img) writeToFile:[self thumbnailImageFilename] atomically:YES];

			dispatch_async(dispatch_get_main_queue(), ^(void) {
				block(img);
			});
			
		});
	}
	else
		block(img);
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:[NSNumber numberWithDouble:self.latitude] forKey:@"latitude"];
    [coder encodeObject:[NSNumber numberWithDouble:self.longitude] forKey:@"longitude"];
    [coder encodeObject:[NSNumber numberWithInt:self.free] forKey:@"free"];
    [coder encodeObject:[NSNumber numberWithInt:self.slots] forKey:@"slots"];
    [coder encodeObject:[NSNumber numberWithInt:self.stationID] forKey:@"stationID"];
    [coder encodeObject:self.lastUpdate forKey:@"lastUpdate"];
}   
- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init])
    {
        self.name = [coder decodeObjectForKey:@"name"];
		self.latitude = [[coder decodeObjectForKey:@"latitude"] doubleValue];
		self.longitude = [[coder decodeObjectForKey:@"longitude"] doubleValue];
		self.free = [[coder decodeObjectForKey:@"free"] intValue];
		self.slots = [[coder decodeObjectForKey:@"slots"] intValue];
		self.stationID = [[coder decodeObjectForKey:@"stationID"] intValue];
		self.lastUpdate = [coder decodeObjectForKey:@"lastUpdate"];
    }
    return self;
}

@end
