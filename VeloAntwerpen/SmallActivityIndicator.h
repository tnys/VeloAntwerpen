//
//  SmallActivityIndicator.h
//
//  Created by Tom Nys on 23/03/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SmallActivityIndicator : NSObject {
 	UILabel* label;
	UIView* superview;
	BOOL isVisible;
	BOOL isBusyShowing;
}

// 
// get the global instance
//
+ (SmallActivityIndicator *)instance;

//
// show the activity label with string lbl, in view v.  Must be called on main thread
//
-(void)show:(NSString*)lbl inView:(UIView*)v;

//
// hide the activity label
//
-(void)hide;

@end
