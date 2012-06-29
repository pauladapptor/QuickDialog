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
#import "QLabelElement.h"

@interface QImageElement : QLabelElement 
    <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property BOOL allowsEdit;
@property BOOL allowsRemove;
@property BOOL removeOnly;
@property BOOL hasRetrievedImage;
@property (strong, nonatomic) UIImage *defaultImage;
@property CGSize maxSize;
@property CGFloat maxWidth;
@property CGFloat maxHeight;
@property (copy) NSString *caption;
@property (strong, nonatomic) UIImage *originalImage;

+ (void)setDefaultImage:(UIImage *)image;

@end
