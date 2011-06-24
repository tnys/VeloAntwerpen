//
//  ReportIssueViewController.h
//  VeloAntwerpen
//
//  Created by Tom Nys on 23/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEPopoverController.h"

@interface ReportIssueViewController : UITableViewController {
	int currentPopoverCellIndex;
	WEPopoverController* popoverController;
	UIImage* photo;
	NSString* bikeId;
	NSString* category;
	NSString* description;
}

@property (nonatomic, retain) WEPopoverController* popoverController;
@property (nonatomic, retain) NSString* bikeId;
@property (nonatomic, retain) NSString* category;
@property (nonatomic, retain) NSString* description;

-(IBAction)reportTapped:(id)btn;

@end
