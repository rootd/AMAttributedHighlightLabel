//
//  AMViewController.h
//  AMAttributedHighlightLabelExample
//
//  Created by Alexander Meiler on 13.01.13.
//  Copyright (c) 2013 Alexander Meiler. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AMAttributedHighlightLabel.h"

@interface AMViewController : UIViewController <AMAttributedHighlightLabelDelegate>

@property (strong, nonatomic) IBOutlet AMAttributedHighlightLabel *tweetLabel;

@end
