//
//  Photographer+Create.m
//  Photomania
//
//  Created by El Desperado on 6/9/13.
//  Copyright (c) 2013 El Desperado. All rights reserved.
//

#import "Photographer+Create.h"

@implementation Photographer (Create)

+ (Photographer *)photographerWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photographer *photographer = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *photographers = [context executeFetchRequest:request error:&error];
    
    if (!photographers || ([photographers count] > 1)) {
        // handle error
    } else if (![photographers count]) {
        photographer = [NSEntityDescription insertNewObjectForEntityForName:@"Photographer"
                                                     inManagedObjectContext:context];
        photographer.name = name;
    } else {
        photographer = [photographers lastObject];
    }
    
    return photographer;
}


@end
