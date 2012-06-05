// Copyright 2012 Adapptor - http://adapptor.com.au
// 
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this 
// file except in compliance with the License. You may obtain a copy of the License at 
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import "QImageElement.h"
static UIImage *NO_IMAGE;

// UIImage scaling extension based on solution from http://stackoverflow.com/a/4439449
@interface UIImage (UIImageFunctions)
- (UIImage *) scaleToSize: (CGSize)size;
- (UIImage *) scaleProportionalToSize: (CGSize)size;
@end

@implementation UIImage (UIImageFunctions)

- (UIImage *) scaleToSize: (CGSize)size
{
    if (size.width < 0) {
        size.width = self.size.width;
    }
    if (size.height < 0) {
        size.height = self.size.height;
    }
    // Scalling selected image to targeted size
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    
    if(self.imageOrientation == UIImageOrientationRight)
    {
        CGContextRotateCTM(context, -M_PI_2);
        CGContextTranslateCTM(context, -size.height, 0.0f);
        CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), self.CGImage);
    }
    else
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage);
    
    CGImageRef scaledImage=CGBitmapContextCreateImage(context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    UIImage *image = [UIImage imageWithCGImage: scaledImage];
    
    CGImageRelease(scaledImage);
    
    return image;
}

- (UIImage *) scaleProportionalToSize: (CGSize)size1
{
    if(self.size.width>self.size.height)
    {
        size1=CGSizeMake((self.size.width/self.size.height)*size1.height,size1.height);
    }
    else
    {
        size1=CGSizeMake(size1.width,(self.size.height/self.size.width)*size1.width);
    }
    return [self scaleToSize:size1];
}

@end


@implementation QImageElement {
    __unsafe_unretained QuickDialogController *_controller;
    NSString* _caption;
}
@synthesize hasRetrievedImage = _hasRetrievedImage;
@synthesize maxSize = _maxSize;
@synthesize allowsRemove = _allowsRemove;
@synthesize removeOnly = _removeOnly;
@synthesize originalImage = _originalImage;

- (QImageElement *)init {
    self = [super init];
    [super setHeight:100];
    @synchronized ([QImageElement class]) {
        if (!NO_IMAGE) {
            NSString* blankImagePath = [[NSBundle mainBundle] pathForResource:@"no_image" ofType:@"png"];
            if (blankImagePath) {
                NO_IMAGE = [UIImage imageWithContentsOfFile:blankImagePath];
            }
        }
    }
    [super setImage:NO_IMAGE];
    [self setHasRetrievedImage:NO];
    [self setMaxSize:CGSizeMake(-1, -1)];
    [self setAllowsRemove:YES];
    return self;
}
     
// Select an image using appropriate source
- (void)selected:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller indexPath:(NSIndexPath *)indexPath {
    NSString *removeBtn = [self allowsRemove] && [self image] ? @"Remove Image" : nil;
    _controller = controller;
    if ([self removeOnly]) {
        if (removeBtn) {
            [[[UIActionSheet alloc] initWithTitle:[self caption]
                                         delegate:self
                                cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:removeBtn
                                otherButtonTitles:nil] showInView:tableView];
        }
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // User has a camera
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            // User has a camera and a photo library
            [[[UIActionSheet alloc] initWithTitle:[self caption]
                                         delegate:self
                                cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:removeBtn
                                otherButtonTitles:@"Take Photo", @"Choose From Library", nil] showInView:tableView];
        }
        else {
            // User only has a camera
            if (removeBtn) {
                [[[UIActionSheet alloc] initWithTitle:[self caption]
                                             delegate:self
                                    cancelButtonTitle:@"Cancel"
                               destructiveButtonTitle:removeBtn
                                    otherButtonTitles:@"Take Photo", nil] showInView:tableView];
            }
            else {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
                [picker setDelegate:self];
                [controller presentModalViewController:picker animated:YES];
            }
        }
    }
    else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            // User doesn't have a camera, but has a photo library
            if (removeBtn) {
                [[[UIActionSheet alloc] initWithTitle:[self caption]
                                             delegate:self
                                    cancelButtonTitle:@"Cancel"
                               destructiveButtonTitle:removeBtn
                                    otherButtonTitles:@"Choose From Library", nil] showInView:tableView];
            }
            else {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [picker setDelegate:self];
                [controller presentModalViewController:picker animated:YES];
            }
        }
        else {
            // User has no means of acquiring an image
            if (removeBtn) {
                [[[UIActionSheet alloc] initWithTitle:[self caption]
                                             delegate:self
                                    cancelButtonTitle:@"Cancel"
                               destructiveButtonTitle:removeBtn
                                    otherButtonTitles:nil] showInView:tableView];
            }
            else {
                [[[UIAlertView alloc] initWithTitle:@"No Images Available" 
                                           message:@"Your device does not have a camera or any photos in the photo library, please add some photos or try again on another device" 
                                          delegate:nil 
                                  cancelButtonTitle:@"OK" otherButtonTitles:nil] 
                 show];
            }
        }
    }
    [super selected:tableView controller:controller indexPath:indexPath];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        if (buttonIndex == [actionSheet destructiveButtonIndex]) {
            [self setImage:nil];
            QuickDialogTableView *view = [_controller quickDialogTableView];
            [view reloadRowsAtIndexPaths:[NSArray arrayWithObject:[view indexForElement:self]]
                        withRowAnimation:UITableViewRowAnimationRight];
            [self setHasRetrievedImage:YES];
        }
        else {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            if (buttonIndex == [actionSheet firstOtherButtonIndex] 
                && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            }
            else {
                [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
            [picker setDelegate:self];
            [_controller presentModalViewController:picker animated:YES];
        }
    }
    else {
        _controller = nil;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker 
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(chosenImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    UIImage *originalImage = nil;
    if (_maxSize.height > 0 || _maxSize.width > 0) {
        if (chosenImage.size.height > _maxSize.height || chosenImage.size.width > _maxSize.width) {
            originalImage = chosenImage;
            chosenImage = [chosenImage scaleProportionalToSize:_maxSize];
        }
    }
    [self setImage:chosenImage];
    [self setOriginalImage:originalImage];
    NSLog(@"%@", [self originalImage]);
    [self setHasRetrievedImage:YES];
    [[_controller quickDialogTableView] reloadData];
    _controller = nil;
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
#ifdef DEBUG
    if (error)
        NSLog(@"Error saving image: %@", error);
#endif
}

- (UIImage *)image {
    UIImage *image = [super image];
    if (image == NO_IMAGE) {
        image = nil;
    }
    return image;
}
- (void)setImage:(UIImage *)image {
    [self setOriginalImage:nil];
    if (image) {
        [super setImage:image];
    }
    else {
        [super setImage:NO_IMAGE];
    }
}

// Manage default image for all instances
+ (void)setDefaultImage:(UIImage *)image {
    @synchronized ([QImageElement class]) {
        NO_IMAGE = image;
    }
}

- (void)setDefaultImage:(UIImage *)defaultImage {
    [QImageElement setDefaultImage:defaultImage];
}

- (UIImage *)defaultImage {
    return NO_IMAGE;
}

// Manage maximum size
- (void)setMaxWidth:(CGFloat)maxWidth {
    _maxSize.width = maxWidth;
}
- (CGFloat)maxWidth {
    return _maxSize.width;
}
- (void)setMaxHeight:(CGFloat)maxHeight {
    _maxSize.height = maxHeight;
}
- (CGFloat)maxHeight {
    return _maxSize.height;
}

- (void)setCaption:(NSString *)caption {
    _caption = caption;
}
- (NSString *)caption {
    if (_caption) {
        return _caption;
    }
    else {
        return [self title];
    }
}


@end
