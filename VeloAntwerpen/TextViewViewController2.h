//
//  TextViewViewController2.h
//  VeloAntwerpen
//
//  Created by Tom Nys on 25/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportBackViewController.h"

@interface TextViewViewController2 : ReportBackViewController {
    IBOutlet UITextView* textView;
}

@property (nonatomic, retain) IBOutlet UITextView* textView;

@end
