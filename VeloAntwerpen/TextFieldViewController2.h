//
//  TextFieldViewController2.h
//  VeloAntwerpen
//
//  Created by Tom Nys on 25/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportBackViewController.h"

@interface TextFieldViewController2 : ReportBackViewController {
    IBOutlet UITextField* textField;
}

@property (nonatomic, retain) IBOutlet UITextField* textField;

@end
