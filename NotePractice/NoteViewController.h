//
//  NoteViewController.h
//  NotePractice
//
//  Created by Yuan-Ching Chen on 2/23/16.
//  Copyright © 2016 Yuan-Ching Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@protocol NoteViewControllerDelegate <NSObject>

-(void)didFinishUpdateNote:(Note*)note;

@end

@interface NoteViewController : UIViewController
@property Note *note;
@property id<NoteViewControllerDelegate> delegate;
@end
