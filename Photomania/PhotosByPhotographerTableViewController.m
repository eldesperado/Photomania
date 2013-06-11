//
//  PhotosByPhotographerTableViewController.m
//  Photomania
//
//  Created by El Desperado on 6/9/13.
//  Copyright (c) 2013 El Desperado. All rights reserved.
//

#import "PhotosByPhotographerTableViewController.h"
#import "Photo.h"

@interface PhotosByPhotographerTableViewController ()

@end

@implementation PhotosByPhotographerTableViewController

@synthesize photographer = _photographer;

- (void) setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"whoTooks.name = %@", self.photographer.name];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.photographer.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (void) setPhotographer:(Photographer *)photographer
{
    _photographer = photographer;
    self.title = photographer.name;
    [self setupFetchedResultsController];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    return cell;
}

@end
