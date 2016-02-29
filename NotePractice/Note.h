//
//  Note.h
//  NotePractice
//
//  Created by Yuan-Ching Chen on 2/23/16.
//  Copyright © 2016 Yuan-Ching Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@import CoreData;

//@interface Note : NSObject
@interface Note : NSManagedObject


@property (nonatomic) NSString *content;
//-------------------------ThumbnailImage Step1.----------------------------
@property (nonatomic) NSString *imageName;

-(UIImage*)image;
-(UIImage*)thumbnailImage;

//@property (nonatomic) UIImage *image;
@end
