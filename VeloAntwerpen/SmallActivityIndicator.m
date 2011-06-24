//
//  SmallActivityIndicator.m
//
//  Created by Tom Nys on 23/03/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import "SmallActivityIndicator.h"
#import <QuartzCore/QuartzCore.h>


@implementation SmallActivityIndicator

static SmallActivityIndicator* globalSmallActivityIndicator;

-(void)show:(NSString*)lbl inView:(UIView*)v
{
	superview = [v retain];
	if (superview)
	{
		label.text = lbl;
		if (!isVisible)
		{
			[superview addSubview:label];
			label.frame = CGRectMake(0, v.bounds.size.height + 10, v.bounds.size.width, 20);
			[UIView animateWithDuration:0.5 
							 animations:^(void) {
								 CGRect fr = label.frame;
								 fr.origin.y -= 30;
								 label.frame = fr;
							 } 
							 completion:^(BOOL finished) {
								 isVisible = YES;
							 }];
		}
	}
}

-(void)hide
{
	if (superview)
	{
		float delay = 0.0;
		if (!isVisible)
			delay = 0.5;
			
		[UIView animateWithDuration:0.5 
							  delay:delay
							options:0 
						 animations:^(void) {
							 CGRect fr = label.frame;
							 fr.origin.y += 30;
							 label.frame = fr;
						 } 
						 completion:^(BOOL finished) {
							 [label removeFromSuperview];
							 isVisible = NO;
						 }];
		[superview release];
		superview = nil;
	}
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
		label.backgroundColor = [UIColor blackColor];
		label.textColor = [UIColor whiteColor];
		label.layer.masksToBounds = NO;
		label.font = [UIFont fontWithName:@"Thonburi" size:14.0];
		label.textAlignment = UITextAlignmentCenter;
		label.layer.shadowOffset = CGSizeMake(0, -10);
		label.layer.shadowRadius = 5;
		label.layer.shadowOpacity = 0.5;
		label.clipsToBounds = NO;
	}
	return self;
}

+ (SmallActivityIndicator *)instance {
	
	if (!globalSmallActivityIndicator)
		globalSmallActivityIndicator = [[SmallActivityIndicator alloc] init];
	
	return globalSmallActivityIndicator;
}


@end
