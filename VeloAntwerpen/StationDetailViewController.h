//
//  StationDetailViewController.h
//  VeloAntwerpen
//
//  Created by Tom Nys on 22/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Station.h"

@interface StationDetailViewController : UIViewController {
	IBOutlet UIImageView* mapView;
	IBOutlet UILabel* nameLbl;
	IBOutlet UITableView* tableView;
	
	Station* station;
	MKReverseGeocoder* reverseGeocoder;
	MKPlacemark* detailedLocation;
}

@property (nonatomic, retain) IBOutlet UIImageView* mapView;
@property (nonatomic, retain) IBOutlet UILabel* nameLbl;
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) Station* station;

@end
