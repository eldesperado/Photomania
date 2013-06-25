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

#import "MyCustomCell.h"

@interface PhotographersTableViewController ()
@end

@implementation PhotographersTableViewController
@synthesize photoDatabase = _photoDatabase;

#pragma mark - Side Menu
- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
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
    static NSString *CellIdentifier = @"PhotoCell";
    MyCustomCell *cell = (MyCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    Photographer *photographer = [self.fetchedResultsController objectAtIndexPath:indexPath];

    Photo* photo = [[photographer.photos allObjects] objectAtIndex:0];
    NSString *featureImageURL = photo.imageURL;
    UIImage *featureImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:featureImageURL]]];
    
    cell.userName.text = photographer.name;
    [cell setLoveCountText:[NSString stringWithFormat:@"%d Photo", [photographer.photos count]]];
    [cell.featuredImage setImage:featureImage];
    cell.postTitle.text = photo.title;
    return cell;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 612.0f;
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *fetchedObjects = [[self.fetchedResultsController fetchedObjects] valueForKey:@"name"];
    
    return [HomeTableViewCell heightForCellWithText:[fetchedObjects objectAtIndex:indexPath.row]];
} */

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Photographer *photographer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ( [segue.destinationViewController respondsToSelector:@selector(setPhotographer:)]) {
        [segue.destinationViewController setPhotographer:photographer];
    }
}

@end
