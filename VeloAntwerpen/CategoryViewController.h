//
//  CategoryViewController.h
//  VeloAntwerpen
//
//  Created by Tom Nys on 25/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportBackViewController.h"

@interface CategoryViewController : ReportBackViewController {
 	NSArray* categories;   
	NSString* selectedCategory;
}

@property (nonatomic, retain) NSArray* categories;   
@property (nonatomic, retain) NSString* selectedCategory;

@end
