//
//  ViewController.h
//  UIAttributedHighlightLabelExample
//
//  Created by Alexander Meiler on 04.01.13.
//  Copyright (c) 2013 Alexander Meiler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAttributedHighlightLabel.h"

@interface ViewController : UIViewController <UIAttributedHighlightLabelDelegate>

@property (strong, nonatomic) IBOutlet UIAttributedHighlightLabel *tweetLabel;

@end
