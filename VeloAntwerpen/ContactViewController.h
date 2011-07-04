//
//  ContactViewController.h
//  VeloAntwerpen
//
//  Created by Tom Nys on 23/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ContactViewController : UIViewController {
    IBOutlet UILabel* reportLbl;
	IBOutlet UIButton* reportBtn;
	UIButton *veloMobileButton;
}

@property (nonatomic, retain) IBOutlet UILabel* reportLbl;
@property (nonatomic, retain) IBOutlet UIButton* reportBtn;
@property (nonatomic, retain) IBOutlet UIButton *veloMobileButton;

-(IBAction)reportIssue:(id)btn;
-(IBAction)veloAntwerpenLink:(id)btn;

@end
