//
//  Station.h
//  VeloAntwerpen
//
//  Created by Tom Nys on 22/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Station : NSObject<NSCoding>
{
	CGFloat latitude;
	CGFloat longitude;
	int slots;
	int free;
	NSString* name;
}

@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@property (nonatomic) int stationID;
@property (nonatomic) int slots;
@property (nonatomic) int free;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSDate* lastUpdate;

-(UIImage*)tableViewImage;
-(NSString*)tableViewImageFilename;

-(void)thumbnailImage:(void (^)(UIImage*))block;
-(NSString*)thumbnailImageFilename;

@end
