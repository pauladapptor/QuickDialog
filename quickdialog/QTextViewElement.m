//
//  QTextViewElement.m
//  QuickDialog
//
//  Created by Scott Mills on 21/06/12.
//  Copyright (c) 2012 Adapptor. All rights reserved.
//

#import "QTextViewElement.h"
#import "QTextViewCell.h"

@implementation QTextViewElement
//NSString *textStr;
//UIDataDetectorTypes *detectorType = UIDataDetectorTypeNone;

- (QTextViewElement *)initWithValue:(id)value {
    self = [super init];
    self.value = value;
    //textStr = (NSString *)value;
    //NSLog(@"Text: %@", textStr);
    //@"Test number: 08 9561 2929. Or 0405461606 Test email: smills29@gmail.com Test number: 08 9561 2929. Or 0405461606 Test email: smills29@gmail.com Test number: 08 9561 2929. Or 0405461606 Test email: smills29@gmail.com";//
    /*super.fra
    
    self = cell.contentView.frame;//CGRectMake(self.contentView.frame.size.width - 60, 11, 46, 46);
    CGRect frame1 = cell.contentView.frame;
    
	cell.textView.font = [UIFont systemFontOfSize:14.0];
	NSString *str  = cell.textView.text;
	CGSize textSize = { cell.contentView.frame.size.width, 9999.0f };
	CGSize size1 = [str sizeWithFont:cell.textView.font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
	
	frame1.size.height = size1.height;
	cell.textView.frame = frame1;
    cell.contentView.frame = frame1;
    [super setHeight:self];*/
    return self;
}

/*-(void)setImageNamed:(NSString *)name {
    self.image = [UIImage imageNamed:name];
}

- (NSString *)imageNamed {
    return nil;
}*/


- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
    //QTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"QuickformTextViewCell%@", self.key]];
    //if (cell == nil){
    QTextViewCell *cell = [[QTextViewCell alloc] init];// [[QTextViewCell alloc] initWithReuseIdentifier:[NSString stringWithFormat:@"QuickformTextViewCell%@", self.key]];
    //}
    cell.accessoryType = UITableViewCellAccessoryNone;//[super accessoryType] == (int) nil ? UITableViewCellAccessoryNone :  [super accessoryType];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.sele
    //[cell.textView setMultipleTouchEnabled:YES];
    //cell.textView.frame = cell.textLabel.frame;
    //cell.textView.textColor = [UIColor redColor];
    
    //cell.textLabel.backgroundColor = [UIColor blueColor];
    cell.textView.backgroundColor = [UIColor clearColor];
    cell.textView.dataDetectorTypes = UIDataDetectorTypeAll;
    cell.textView.delegate = self;
    cell.textView.font = [UIFont systemFontOfSize:15.0f];
    cell.textView.text = (NSString *)self.value;
    
    //cell.textLabel.textColor = [UIColor purpleColor];
    //cell.textLabel.text = @"";//@"A bunch of test text for textLabel";
    
    //[super setHeight:cell.textView.frame.size.height];
    
    //[[self value] description];
    
    //cell.textView.frame = cell.contentView.frame;//CGRectMake(self.contentView.frame.size.width - 60, 11, 46, 46);
    CGRect frame1 = cell.frame;
    
	//cell.textView.font = cell.detailTextLabel.font;
	NSString *str  = cell.textView.text;
	CGSize textSize = { frame1.size.width - 20.0f, 9999.0f };
	CGSize size1 = [str sizeWithFont:cell.textView.font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
	
	frame1.size.height = size1.height+25.0f;
    frame1.size.width -=20.0f;
	cell.textView.frame = frame1;
    
    cell.textLabel.userInteractionEnabled = NO;
    cell.detailTextLabel.userInteractionEnabled = NO;
    cell.userInteractionEnabled = YES;
    cell.textView.userInteractionEnabled = YES;
    
    cell.textView.scrollEnabled = NO;
    
    cell.textView.editable = NO;
    cell.textView.delaysContentTouches = NO;
    
    cell.textView.textColor = [UIColor darkGrayColor];
    
    
    //cell.contentView.frame = frame1;
    
    NSLog(@"cell.textView.frame: %f", frame1.size.height);
    NSLog(@"cell.textView.text: %@f", cell.textView.text);
    NSLog(@"text: %@f", (NSString *)self.value);
    
    return cell;
}





/*cell.selectionStyle = UITableViewCellSelectionStyleNone;
cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
cell.detailTextLabel.numberOfLines = 0;

cell.textLabel.adjustsFontSizeToFitWidth = YES;
cell.textLabel.text = self.title;
cell.detailTextLabel.font = _font;
cell.detailTextLabel.textColor = _color;
cell.detailTextLabel.text = _text;

return cell;
}*/


- (CGFloat)getRowHeightForTableView:(QuickDialogTableView *)tableView {
    
    if ((NSString *)self.value==nil || (NSString *)self.value == @""){
        return [super getRowHeightForTableView:tableView];
    }
    CGSize constraint = CGSizeMake(tableView.frame.size.width-(tableView.root.grouped ? 40.f : 20.f), 20000);
    CGSize  size= [(NSString *)self.value sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	CGFloat predictedHeight = size.height + 15.0f;
    //if (self.title!=nil)
        //predictedHeight+=30;
	return (_height >= predictedHeight) ? _height : predictedHeight;
}

- (QTextViewElement *)init {
    self = [super init];
    
    return self;
}

//-(void) setDataDetectorType:(UIDataDetectorTypes *)dataDetectorType{
//    detectorType = dataDetectorType;
//}


@end
