//
//  Note.m
//  NotePractice
//
//  Created by Yuan-Ching Chen on 2/23/16.
//  Copyright © 2016 Yuan-Ching Chen. All rights reserved.
//

#import "Note.h"

@implementation Note {
    UIImage *smallImage;
}

// let coredata set up the setter & getter, not compiler
@dynamic content;
@dynamic imageName;


//-------------------------ThumbnailImage Step2.----------------------------
-(UIImage*)image{
    NSString *documentPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imagePath = [documentPath stringByAppendingPathComponent:self.imageName];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    return image;
}

-(UIImage*)thumbnailImage{
    UIImage *image = [self image];
    if (!image) {
        return nil;
    }
    
    if (smallImage) {
        return smallImage;
    }
    
    
    // ratio -> get the final size -> draw
    CGSize thumbnalSize = CGSizeMake(60, 50);
    CGFloat widthRatio  = thumbnalSize.width/image.size.width;
    CGFloat heightRatio = thumbnalSize.height/image.size.height;
    CGFloat ratio       = MAX(widthRatio, heightRatio);
    
    UIGraphicsBeginImageContextWithOptions(thumbnalSize, NO, [UIScreen mainScreen].scale);
    CGSize resultlSize  = CGSizeMake(image.size.width*ratio, image.size.height*ratio);
    
    CGRect resultRect   = CGRectMake(-(resultlSize.width-60)/2, -(resultlSize.height-50)/2, resultlSize.width, resultlSize.height);
    
    
    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 60, 50)];
    [circle addClip];
    
    [image drawInRect:resultRect];
    
    smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return smallImage;
}


@end
