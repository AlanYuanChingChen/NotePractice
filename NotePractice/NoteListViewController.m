//
//  NoteListViewController.m
//  NotePractice
//
//  Created by Yuan-Ching Chen on 2/23/16.
//  Copyright © 2016 Yuan-Ching Chen. All rights reserved.
//

#import "NoteListViewController.h"
#import "Note.h"
#import "CoreDataHelper.h"


@interface NoteListViewController () <UITableViewDataSource, UITableViewDelegate, NoteViewControllerDelegate>

@property (nonatomic) NSMutableArray<Note*> *noteArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation NoteListViewController {
    NSFetchedResultsController *frc;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.noteArr = [NSMutableArray array];
        [self loadFromCoreData];
        //        for (int i = 0 ; i < 10 ; i++) {
        //             Note *note = [Note new];
        //            note.content = @"new";
        //            self.noteArr[i] = note;
        //        }
        
        /*
        NSManagedObjectContext *context = [[CoreDataHelper sharedInstance] managedObjectContext];
        NSFetchRequest *fetchRequest = [NSFetchRequest new];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
        
        frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext: context sectionNameKeyPath:nil cacheName:nil];
        */
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Note List";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - UIViewController setEditting
-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // delete data in core data
        [[[CoreDataHelper sharedInstance] managedObjectContext] deleteObject:self.noteArr[indexPath.row]];
        
        NSError *error = nil;
        
        if (!error){
            [[[CoreDataHelper sharedInstance] managedObjectContext] save:&error];
            // delete data in note Array
            [self.noteArr removeObjectAtIndex:indexPath.row];
            
            //delete row
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noteArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.noteArr[indexPath.row].content;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //-------------------------ThumbnailImage Step4.----------------------------
    cell.imageView.image = [self.noteArr[indexPath.row] thumbnailImage];
    
    
    //cell.imageView.image = self.noteArr[indexPath.row].image;
    
    return cell;
}

#pragma mark - CoreData
-(void)saveToCoreData {
    
    // managedObjectContext -> save
    NSError *error = nil;
    [[CoreDataHelper sharedInstance].managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"error occurs: %@",error);
    }
}

-(void)loadFromCoreData {
    
    // managedObjectContext -> excute request
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Note"];
    NSError *error = nil;
    
    // nspredicate index path
    
    
    NSArray *resultArray = [[CoreDataHelper sharedInstance].managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        // handling error
        self.noteArr = [NSMutableArray array];
    } else {
        self.noteArr = [NSMutableArray arrayWithArray:resultArray];
    }
}

#pragma mark - IBAction
- (IBAction)addNote:(id)sender {
    // add noteArr
    //Note *newNote = [Note new];
    
    Note *newNote = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext: [CoreDataHelper sharedInstance].managedObjectContext];

    newNote.content = @"new stuff";
    [self.noteArr insertObject:newNote atIndex:0];

    // core data
    [self saveToCoreData];
    
    
    // add tableView
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - NoteViewControllerDelegate
-(void)didFinishUpdateNote:(Note *)note{
    NSUInteger index = [self.noteArr indexOfObject:note];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    // core data
    [self saveToCoreData];
    
    // reload table
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showNoteDetailSegue"]) {
        NoteViewController* noteVC = segue.destinationViewController;
        
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        
        noteVC.note = self.noteArr[indexPath.row];
        noteVC.delegate = self;
    }
}

#pragma mark - NSFetchedResultsControllerDelegate
/*
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}



- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
           // [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}
*/
@end
