//
//  QImageTableViewCell.m
//  QuickDialog
//
//  Created by Michael Ensly on 7/06/12.
//  Copyright (c) 2012 Adapptor. All rights reserved.
//

#import "QImageTableViewCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation QImageTableViewCell
@synthesize imageFrame = _imageFrame;

- (QImageTableViewCell *)initWithReuseIdentifier:(NSString *)string {
    self = [super initWithReuseIdentifier:string];
    if (self) {
        _imageFrame = [[UIView alloc] init];
        [self.contentView addSubview:_imageFrame];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x - self.imageView.frame.size.width, 
                                      self.textLabel.frame.origin.y, 
                                      self.textLabel.frame.size.width, 
                                      self.textLabel.frame.size.height);
    self.imageView.frame = CGRectMake(self.contentView.frame.size.width - 60, 11, 46, 46);
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    
    self.imageFrame.frame = CGRectMake(self.contentView.frame.size.width - 64.5, 6.5, 55, 55);
    self.imageFrame.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.imageFrame.layer.borderWidth = 1.0;
}

@end
