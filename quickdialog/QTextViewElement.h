//
//  QTextViewElement.h
//  QuickDialog
//
//  Created by Scott Mills on 21/06/12.
//  Copyright (c) 2012 Adapptor. All rights reserved.
//

#import "QLabelElement.h"

@interface QTextViewElement : QRootElement <UITextViewDelegate>

- (QTextViewElement *)initWithValue:(id)value;
//-(void) setDataDetectorType:(UIDataDetectorTypes *)dataDetectorType;

@end
