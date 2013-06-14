//
//  PhotographersTableViewController.m
//  Photomania
//
//  Created by El Desperado on 6/9/13.
//  Copyright (c) 2013 El Desperado. All rights reserved.
//

#import "PhotographersTableViewController.h"
#import "FlickrFetcher.h"
#import "Photographer.h"
#import "Photo+Flickr.h"
#import "PhotosByPhotographerTableViewController.h"

#import "ECSlidingViewController.h"
#import "MenuViewController.h"

#import "HomeTableViewCell.h"

@interface PhotographersTableViewController ()
@end

@implementation PhotographersTableViewController
@synthesize photoDatabase = _photoDatabase;

#pragma mark - Side Menu
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Remove table cell separator
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Assign our own backgroud for the view
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // Add padding to the top of the table view
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
    self.navigationItem.title = @"Flickr Photographers";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    //Add shadow to distiguise with navigation
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
}

- (void) setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.photoDatabase.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (void) fetchedFlickrDataIntoDocument: (UIManagedDocument *)document
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        [document.managedObjectContext performBlock:^{
            NSArray *photos = [FlickrFetcher recentGeoreferencedPhotos];
            for (NSDictionary *photoInfo in photos) {
                [Photo photoWithFlickrInfo:photoInfo inManagedObjectContext:document.managedObjectContext];
            }
        }];
    });

}

- (void) useDocument
{
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:[self.photoDatabase.fileURL path]]) {
        [self.photoDatabase saveToURL:self.photoDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            [self setupFetchedResultsController];
            [self fetchedFlickrDataIntoDocument:self.photoDatabase];
        }];
    } else if ( self.photoDatabase.documentState == UIDocumentStateClosed ) {
        [self.photoDatabase openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
    } else if ( self.photoDatabase.documentState == UIDocumentStateNormal ) {
        [self setupFetchedResultsController];
    }
}

- (void) setPhotoDatabase:(UIManagedDocument *)photoDatabase
{
    if ( _photoDatabase != photoDatabase) {
        _photoDatabase = photoDatabase;
        [self useDocument];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ( !self.photoDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"DefaultPhotoDB"];
        
        self.photoDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photographer Cell";
    HomeTableViewCell *cell = (HomeTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    Photographer *photographer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.postTitle.text = photographer.name;
    
    NSString *postDescription = [NSString stringWithFormat:@"%d photos", [photographer.photos count]];
    
    
    cell.postDescription = [NSString stringWithFormat:@"%d photos", [photographer.photos count]];

    // Assign our own background image for the cell
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    return cell;
}

// Set background for cells
- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_middle.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_middle.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Photographer *photographer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ( [segue.destinationViewController respondsToSelector:@selector(setPhotographer:)]) {
        [segue.destinationViewController setPhotographer:photographer];
    }
}

@end
