//
//  NoteViewController.m
//  NotePractice
//
//  Created by Yuan-Ching Chen on 2/23/16.
//  Copyright © 2016 Yuan-Ching Chen. All rights reserved.
//

#import "NoteViewController.h"

@interface NoteViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // show text
    self.textView.text = self.note.content;
    
    
    // show origin image
    NSString *documentPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imageFilePath = [documentPath stringByAppendingPathComponent:self.note.imageName];
    self.imageView.image = [UIImage imageWithContentsOfFile:imageFilePath];
    
    // add camera button
    self.navigationController.toolbarHidden = NO;
    self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(camera:)]];
    
    // add save button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
}

#pragma mark - IBAction

-(IBAction)camera:(id)sender{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary] ) {
        // the PhotoLibrary is available tp use
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

// save the note, show on the NoteListVC(PROTOCOL), pop VC
-(IBAction)save:(id)sender {
    self.note.content = self.textView.text;
    
    //-------------------------ThumbnailImage Step3.----------------------------
    //self.note.image   = self.imageView.image;
    // generate image name -> homedirectory ->compress to NSData -> write to file
    NSUUID *uuid = [NSUUID UUID];
    NSString *imageName = [NSString stringWithFormat: @"%@.jpg",uuid.UUIDString];
    self.note.imageName = imageName;
    
    NSString *documentPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imagePath = [documentPath stringByAppendingPathComponent:imageName];
    
    NSLog(@"imagePath: %@", imagePath);
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.6);
    [imageData writeToFile:imagePath atomically:YES];
    
    
    [self.delegate didFinishUpdateNote:self.note];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.imageView.image = info[UIImagePickerControllerOriginalImage];
    
    // dismiss picker
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
