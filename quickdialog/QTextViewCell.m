//
//  QTextViewCell.m
//  QuickDialog
//
//  Created by Scott Mills on 21/06/12.
//  Copyright (c) 2012 Adapptor. All rights reserved.
//

#import "QTextViewCell.h"

@implementation QTextViewCell
@synthesize textView = _textView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textView = [[UITextView alloc] init];
        [self.contentView addSubview:_textView];
    }
    return self;
}

- (QTextViewCell *)init{
    self = [super init];
    if (self) {
        _textView = [[UITextView alloc] init];
        [self.contentView addSubview:_textView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (QTextViewCell *)initWithReuseIdentifier:(NSString *)string {
    self = [super initWithReuseIdentifier:string];
    if (self) {
        _textView = [[UITextView alloc] init];
        [self.contentView addSubview:_textView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
