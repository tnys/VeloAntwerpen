//
//  SecondViewController.h
//  VeloAntwerpen
//
//  Created by Tom Nys on 22/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListViewController : UIViewController {
    IBOutlet UITableView* tableView;

	NSArray* stations;
	NSMutableDictionary* stationsIndexed;
	
	BOOL viewVisible;
	int sortMode;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) NSArray* stations;

-(void)stationsUpdated:(NSNotification*)notif;
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;

@end
