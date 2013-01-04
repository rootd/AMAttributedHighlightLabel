//
//  ViewController.m
//  UIAttributedHighlightLabelExample
//
//  Created by Alexander Meiler on 04.01.13.
//  Copyright (c) 2013 Alexander Meiler. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize tweetLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    tweetLabel.delegate = self;
    tweetLabel.userInteractionEnabled = YES;
    tweetLabel.numberOfLines = 0;
    tweetLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [tweetLabel setString:@"This #is a @test for my #@new http://UIAttributedHighlightLabel.class"];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)selectedMention:(NSString *)string {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Selected" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
- (void)selectedHashtag:(NSString *)string {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Selected" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
- (void)selectedLink:(NSString *)string {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Selected" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
