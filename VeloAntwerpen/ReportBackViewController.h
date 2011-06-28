//
//  ReportBackViewController.h
//  VeloAntwerpen
//
//  Created by Tom Nys on 25/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReportBackDelegate <NSObject>

-(void)textWasFinished:(NSString*)text forKey:(NSString*)key;

@end


@interface ReportBackViewController : UIViewController {
    id<ReportBackDelegate> delegate;
	NSString* key;
}

@property (nonatomic, assign) id<ReportBackDelegate> delegate;
@property (nonatomic, retain) NSString* key;

@end
