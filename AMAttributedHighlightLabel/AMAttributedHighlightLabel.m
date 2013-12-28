//
//  UIAttributedHighlightLabel.m
//  UIAttributedHighlightLabelExample
//
//  Created by Alexander Meiler on 04.01.13.
//  Copyright (c) 2013 Alexander Meiler. All rights reserved.
//

#import "AMAttributedHighlightLabel.h"

@implementation AMAttributedHighlightLabel

@synthesize textColor,mentionTextColor,hashtagTextColor,linkTextColor,selectedMentionTextColor,selectedHashtagTextColor,selectedLinkTextColor;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        textColor = [UIColor lightGrayColor];
        mentionTextColor = [UIColor darkGrayColor];
        hashtagTextColor = [UIColor darkGrayColor];
        linkTextColor = [UIColor colorWithRed:129.0/255.0 green:171.0/255.0 blue:193.0/255.0 alpha:1.0];
        
        selectedMentionTextColor = [UIColor blackColor];
        selectedHashtagTextColor = [UIColor blackColor];
        selectedLinkTextColor = UIColorFromRGB(0x4099FF);
        
        touchableWords = [[NSMutableArray alloc] init];
        touchableLocations = [[NSMutableArray alloc] init];
        touchableWordsRange = [[NSMutableArray alloc] init];
        self.text = @"";
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        textColor = [UIColor lightGrayColor];
        mentionTextColor = [UIColor darkGrayColor];
        hashtagTextColor = [UIColor darkGrayColor];
        linkTextColor = [UIColor colorWithRed:129.0/255.0 green:171.0/255.0 blue:193.0/255.0 alpha:1.0];
        
        selectedMentionTextColor = [UIColor blackColor];
        selectedHashtagTextColor = [UIColor blackColor];
        selectedLinkTextColor = UIColorFromRGB(0x4099FF);
        
        touchableWords = [[NSMutableArray alloc] init];
        touchableLocations = [[NSMutableArray alloc] init];
        touchableWordsRange = [[NSMutableArray alloc] init];
        self.text = @"";
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        textColor = [UIColor lightGrayColor];
        mentionTextColor = [UIColor darkGrayColor];
        hashtagTextColor = [UIColor darkGrayColor];
        linkTextColor = [UIColor colorWithRed:129.0/255.0 green:171.0/255.0 blue:193.0/255.0 alpha:1.0];
        
        selectedMentionTextColor = [UIColor blackColor];
        selectedHashtagTextColor = [UIColor blackColor];
        selectedLinkTextColor = UIColorFromRGB(0x4099FF);
        
        touchableWords = [[NSMutableArray alloc] init];
        touchableLocations = [[NSMutableArray alloc] init];
        touchableWordsRange = [[NSMutableArray alloc] init];
        self.text = @"";
    }
    return self;
}

- (void)setString:(NSString *)string
{
    [touchableWords removeAllObjects];
    [touchableWordsRange removeAllObjects];
    [touchableLocations removeAllObjects];
    currentSelectedString = nil;
    
    self.text = string;
    NSArray *words = [string componentsSeparatedByString:@" "];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"((@|#)([A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)_]+))|(http(s)?://([A-Z0-9a-z._-]*(/)?)*)" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSForegroundColorAttributeName value:textColor range:[string rangeOfString:string]];
    
    NSUInteger startLocation = 0;
    for (NSString *word in words) {
        NSRange wordSearchRange = NSMakeRange(startLocation, ([string length] - startLocation));
        
        NSTextCheckingResult *match = [regex firstMatchInString:word options:0 range:NSMakeRange(0, [word length])];
        NSString *tappableWord = [word substringWithRange:match.range];
        if ([tappableWord length] > 0)
        {
            NSRange matchRange = [string rangeOfString:word options:NSLiteralSearch range:wordSearchRange];
            if ([tappableWord hasPrefix:@"@"])
            {
                [attrString addAttribute:NSForegroundColorAttributeName value:mentionTextColor range:matchRange];
            }
            else if ([tappableWord hasPrefix:@"#"])
            {
                [attrString addAttribute:NSForegroundColorAttributeName value:hashtagTextColor range:matchRange];
            }
            else if ([tappableWord hasPrefix:@"http://"])
            {
                [attrString addAttribute:NSForegroundColorAttributeName value:linkTextColor range:matchRange];
            }
            else if ([tappableWord hasPrefix:@"https://"])
            {
                [attrString addAttribute:NSForegroundColorAttributeName value:linkTextColor range:matchRange];
            }
            else if ([tappableWord hasPrefix:@"www."])
            {
                [attrString addAttribute:NSForegroundColorAttributeName value:linkTextColor range:matchRange];
            }
            
            for(int i = 0;i < matchRange.length;i++)
            {
                CGRect pos = [self rectForLetterAtIndex:matchRange.location + i];
                [touchableWords addObject:tappableWord];
                [touchableWordsRange addObject:[NSValue valueWithRange:matchRange]];
                [touchableLocations addObject:[NSValue valueWithCGRect:pos]];
            }
        }
        
        startLocation += [word length];
    }
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        // iOS 6 supports attributed strings on UILabel
        self.attributedText = attrString;
    }
    else
    {
        CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, self.bounds );

        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                                    CFRangeMake(0, [attrString length]), path, NULL);
        
        CTFrameDraw(frame, context);

        CFRelease(frame);
        CFRelease(path);
        CFRelease(framesetter);
    }
}

// Thank you, Erik Andersson!
// https://gist.github.com/1278483
- (CGRect)rectForLetterAtIndex:(NSUInteger)index
{
    NSAssert(self.lineBreakMode != NSLineBreakByClipping, @"UILabel.lineBreakMode cannot be NSLineBreakByClipping to calculate the rect of a character. You might think that it's possible, seeing as NSLineBreakByWordWrapping is supported, and they are almost the same. But the semantics are weird. Sorry.");
    NSAssert(self.lineBreakMode != NSLineBreakByTruncatingHead, @"UILabel.lineBreakMode cannot be NSLineBreakByTruncatingHead to calculate the rect of a character. We can't have everything you know.");
    NSAssert(self.lineBreakMode != NSLineBreakByTruncatingMiddle, @"UILabel.lineBreakMode cannot be NSLineBreakByTruncatingMiddle to calculate the rect of a character. We can't have everything you know.");
    NSAssert(self.lineBreakMode != NSLineBreakByTruncatingTail, @"UILabel.lineBreakMode cannot be NSLineBreakByTruncatingTail to calculate the rect of a character. We can't have everything you know.");
    
    // Check if label is empty. Should add so it also checks for strings containing only spaces
    if ( [self.text length] == 0 )
    {
        return self.bounds;
    }
    
    // Algorithm goes like this:
    //    1. Determine which line the letter is on
    //    2. Get the x-position on the line by: width of string up to letter
    //    3. Apply UITextAlignment to the x-position
    //    4. Add y position based on height of letters * line number
    //    Et víolà!
    
    NSString *letter = [self.text substringWithRange:NSMakeRange(index, 1)];
    
    // Determine which line the letter is on and the string on that line
    CGSize letterSize = [letter sizeWithFont:self.font];
    
    int lineNo = 0;
    int linesDisplayed = 1;
    
    // Get the substring with the line on it
    NSUInteger lineStartsOn = 0;
    NSUInteger currentLineLength = 1;
    
    // Temporary variables
    NSUInteger currentLineStartsOn = 0;
    NSUInteger currentCurrentLineLength = 1;
    
    float currentWidth;
    
    // TODO: Add support for UILineBreakModeWordWrap, UILineBreakModeCharacterWrap to complete implementation
    
    // Get the line number of the current letter
    // Get the contents of that line
    // Get the total number of lines (which means that no matter what we loop through the entire thing)
    
    BOOL isDoneWithLine = NO;
    
    NSUInteger i = 0, len = [self.text length];
    
    // The loop is different depending on the lineBreakMode. If it is UILineBreakModeCharacterWrap it is easy
    // just check for every single character. For UILineBreakModeWordWrap it is a bit more tedious. We have
    // to think in terms of words. We have to find each word and check it. If it is longer than the frame width
    // then we know we have a new word, and that lines index starts on the words beginning index.
    // Spaces prove to be even morse troublesome. Several spaces in a row at the end of a line won't result in
    // any more width.
    for ( ; i < len; i++ )
    {
        NSString *currentLine = [self.text substringWithRange:NSMakeRange(currentLineStartsOn, currentCurrentLineLength)];
        
        CGSize currentSize = [currentLine sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 1000) lineBreakMode:self.lineBreakMode];
        currentWidth = currentSize.width;
        
        if ( currentSize.height > self.font.lineHeight )
        {
            // We have to go to a new line
            linesDisplayed++;
            
            //NSLog(@"new line on: %d", i);
            
            // If i <= index that means we are on the correct letter's line
            // store that
            if ( i <= index )
            {
                lineStartsOn = i;
                lineNo++;
                currentLineLength = 1;
            }
            else
                isDoneWithLine = YES;
            
            currentLineStartsOn = i;
            currentCurrentLineLength = 1;
            i--;
        }
        else
        {
            // Okay with the same line
            
            currentCurrentLineLength++;
            
            if ( ! isDoneWithLine )
            {
                currentLineLength++;
            }
        }
    }
    
    // Make sure we didn't overstep the bounds
    while ( lineStartsOn + currentLineLength > len )
        currentLineLength--;
    
    // Check if linesDisplayed is faulty, if for example lines have been clipped
    CGSize totalSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 100000) lineBreakMode:self.lineBreakMode];
    
    if ( totalSize.height > self.frame.size.height )
    {
        // It has been clipped, calculate how many lines are actually shown
        
        linesDisplayed = 0;
        float ddLineHeight = 0;
        while ( ddLineHeight < self.frame.size.height )
        {
            ddLineHeight += self.font.lineHeight;
            linesDisplayed++;
        }
        
        linesDisplayed--;
        
        // Number of lines is not automatic, keep it within that range
        if ( self.numberOfLines > 0 )
            linesDisplayed = linesDisplayed > self.numberOfLines ? self.numberOfLines : linesDisplayed;
    }
    
    // Length of the substring up and including this letter
    NSUInteger currentLineSubstrLength = index - lineStartsOn + 1;
    
    currentWidth = [[self.text substringWithRange:NSMakeRange(lineStartsOn, currentLineLength)] sizeWithFont:self.font].width;
    
    NSString *lineSubstr = [self.text substringWithRange:NSMakeRange(lineStartsOn, currentLineSubstrLength)];
    
    float x = [lineSubstr sizeWithFont:self.font].width - [letter sizeWithFont:self.font].width;
    float y = self.frame.size.height/2 - (linesDisplayed*self.font.lineHeight)/2 + self.font.lineHeight*lineNo;
    
    if ( self.textAlignment == NSTextAlignmentCenter )
    {
        x = x + (self.frame.size.width-currentWidth)/2;
    }
    else if ( self.textAlignment == NSTextAlignmentRight )
    {
        x = self.frame.size.width-(currentWidth-x);
    }
    
    return CGRectMake(x, y, letterSize.width, letterSize.height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    int count = [touchableLocations count];
    for (int i=0; i < count; i++)
    {
        if (CGRectContainsPoint([[touchableLocations objectAtIndex:i] CGRectValue], touchLocation))
        {
            NSMutableAttributedString *newAttrString = [self.attributedText mutableCopy];
            [newAttrString removeAttribute:NSForegroundColorAttributeName range:[[touchableWordsRange objectAtIndex:i] rangeValue]];
            NSString *string = [touchableWords objectAtIndex:i];
            if([string hasPrefix:@"@"])
                [newAttrString addAttribute:NSForegroundColorAttributeName value:selectedMentionTextColor range:[[touchableWordsRange objectAtIndex:i] rangeValue]];
            else if ([string hasPrefix:@"#"])
                [newAttrString addAttribute:NSForegroundColorAttributeName value:selectedHashtagTextColor range:[[touchableWordsRange objectAtIndex:i] rangeValue]];
            else if ([string hasPrefix:@"http://"])
                [newAttrString addAttribute:NSForegroundColorAttributeName value:selectedLinkTextColor range:[[touchableWordsRange objectAtIndex:i] rangeValue]];
            else if ([string hasPrefix:@"https://"])
                [newAttrString addAttribute:NSForegroundColorAttributeName value:selectedLinkTextColor range:[[touchableWordsRange objectAtIndex:i] rangeValue]];
            else if ([string hasPrefix:@"www."])
                [newAttrString addAttribute:NSForegroundColorAttributeName value:selectedLinkTextColor range:[[touchableWordsRange objectAtIndex:i] rangeValue]];
            self.attributedText = newAttrString;
            
            currentSelectedRange = [[touchableWordsRange objectAtIndex:i] rangeValue];
            currentSelectedString = [touchableWords objectAtIndex:i];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(currentSelectedString != nil)
    {
        NSMutableAttributedString *newAttrString = [self.attributedText mutableCopy];
        [newAttrString removeAttribute:NSForegroundColorAttributeName range:currentSelectedRange];
        if([currentSelectedString hasPrefix:@"@"])
            [newAttrString addAttribute:NSForegroundColorAttributeName value:mentionTextColor range:currentSelectedRange];
        else if ([currentSelectedString hasPrefix:@"#"])
            [newAttrString addAttribute:NSForegroundColorAttributeName value:hashtagTextColor range:currentSelectedRange];
        else if ([currentSelectedString hasPrefix:@"http://"])
            [newAttrString addAttribute:NSForegroundColorAttributeName value:linkTextColor range:currentSelectedRange];
        else if ([currentSelectedString hasPrefix:@"https://"])
            [newAttrString addAttribute:NSForegroundColorAttributeName value:linkTextColor range:currentSelectedRange];
        else if ([currentSelectedString hasPrefix:@"www."])
            [newAttrString addAttribute:NSForegroundColorAttributeName value:linkTextColor range:currentSelectedRange];
        self.attributedText = newAttrString;
        
        // huh?
        //currentSelectedRange = nil;
        currentSelectedString = nil;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(currentSelectedString != nil)
    {
        NSMutableAttributedString *newAttrString = [self.attributedText mutableCopy];
        [newAttrString removeAttribute:NSForegroundColorAttributeName range:currentSelectedRange];
        if([currentSelectedString hasPrefix:@"@"])
        {
            [newAttrString addAttribute:NSForegroundColorAttributeName value:mentionTextColor range:currentSelectedRange];
            [delegate selectedMention:currentSelectedString];
        } else if ([currentSelectedString hasPrefix:@"#"])
        {
            [newAttrString addAttribute:NSForegroundColorAttributeName value:hashtagTextColor range:currentSelectedRange];
            [delegate selectedHashtag:currentSelectedString];
        } else if ([currentSelectedString hasPrefix:@"http://"])
        {
            [newAttrString addAttribute:NSForegroundColorAttributeName value:linkTextColor range:currentSelectedRange];
            [delegate selectedLink:currentSelectedString];
        } else if ([currentSelectedString hasPrefix:@"https://"])
        {
            [newAttrString addAttribute:NSForegroundColorAttributeName value:linkTextColor range:currentSelectedRange];
            [delegate selectedLink:currentSelectedString];
        } else if ([currentSelectedString hasPrefix:@"www."])
        {
            [newAttrString addAttribute:NSForegroundColorAttributeName value:linkTextColor range:currentSelectedRange];
            [delegate selectedLink:currentSelectedString];
        }
        self.attributedText = newAttrString;
        
        // huh?
        //currentSelectedRange = nil;
        currentSelectedString = nil;
    }
}

@end
