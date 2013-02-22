AMAttributedHighlightLabel
==========================

A UILabel subclass with mention/hashtag/link highlighting.

![AMAttributedHighlightLabel screenshot](https://github.com/rootd/AMAttributedHighlightLabel/raw/master/screenshot.png "AMAttributedHighlightLabel screenshot")

Usage
=====

Import AMAttributedHighlightLabel.m and AMAttributedHighlightLabel.h to your project. Also link it against the CoreText framework for iOS 5 support.
IMPORTANT: iOS 5 support not tested yet!

    AMAttributedHighlightLabel *tweetLabel = [[AMAttributedHighlightLabel alloc] initWithFrame:CGRectMake(..,..,..,..)];
    tweetLabel.delegate = self;
    tweetLabel.userInteractionEnabled = YES;
    tweetLabel.numberOfLines = 0;
    tweetLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [tweetLabel setString:@"This #is a @test for my #@new http://AMAttributedHighlightLabel.class"];
    
    tweetLabel.textColor = [UIColor lightGrayColor];
    tweetLabel.mentionTextColor = [UIColor darkGrayColor];
    tweetLabel.hashtagTextColor = [UIColor darkGrayColor];
    tweetLabel.linkTextColor = [UIColor colorWithRed:129.0/255.0 green:171.0/255.0 blue:193.0/255.0 alpha:1.0];
    tweetLabel.selectedMentionTextColor = [UIColor blackColor];
    tweetLabel.selectedHashtagTextColor = [UIColor blackColor];
    tweetLabel.selectedLinkTextColor = UIColorFromRGB(0x4099FF);

    NSError *error;
    regex = [NSRegularExpression regularExpressionWithPattern:@"((@|#)([A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)_]+))|(http(s)?://([A-Z0-9a-z._-]*(/)?)*)" options:NSRegularExpressionCaseInsensitive error:&error];

    tweetLabel.regex = regex;

    [self.view addSubview:tweetLabel];
    
Delegate methods (Use <AMAttributedHighlightLabelDelegate> protocol):

<code>-(void)selectedMention:(NSString *)string; <br>
 -(void)selectedHashtag:(NSString *)string; <br>
 -(void)selectedLink:(NSString *)string;</code>

Look at the sample project to see it more detailed.

License (MIT)
=============

Copyright (c) 2013 Alexander Meiler

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

