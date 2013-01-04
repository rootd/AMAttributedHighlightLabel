UIAttributedHighlightLabel
==========================

A UILabel subclass with mention/hashtag/link highlighting.

![UIAttributedHighlightLabel screenshot](https://github.com/rootd/UIAttributedHighlightLabel/raw/master/screenshot.png "UIAttributedHighlightLabel screenshot")

Usage
=====

Import UIAttributedHighlightLabel.h and UIAttributedHighlightLabel.m to your project. Link it against the CoreText framework.

UIAttributedHighlightLabel *tweetLabel = [[UIAttributedHighlightLabel alloc] initWithFrame:CGRectMake(..,..,..,..)];
tweetLabel.delegate = self;
tweetLabel.userInteractionEnabled = YES;
tweetLabel.numberOfLines = 0;
tweetLabel.lineBreakMode = NSLineBreakByCharWrapping;
[tweetLabel setString:@"This #is a @test for my #@new http://UIAttributedHighlightLabel.class"];
[self.view addSubview:tweetLabel];

Delegate methods (Use UIAttributedHighlightLabelDelegate protocol):

- (void)selectedMention:(NSString *)string {
}
- (void)selectedHashtag:(NSString *)string {
}
- (void)selectedLink:(NSString *)string {
}

Look at the sample project so de it more detailed.

License (MIT)
=============

Copyright (c) 2013 Alexander Meiler

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

