//
//  UIImage+ResizeAndCrop.h
//  WeShake
//
//  Created by Dafeng Jin on 13-11-11.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ResizeAndCrop)

- (UIImage *)resizeToSize:(CGSize)newSize thenCropWithRect:(CGRect)cropRect;

@end
