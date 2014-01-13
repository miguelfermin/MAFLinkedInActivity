//
//  MFLinkedInAccount.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/6/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFLinkedInAccount.h"

#import "UICKeyChainStore.h"


@implementation MFLinkedInAccount


- (id)init {
    self = [super init];
    
    if (self) {
        // Initialize self.
        
        // Uncomment to see all items in keychain
        NSLog(@"_keychainStore: %@", [UICKeyChainStore keyChainStoreWithService:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"]);
        
        // Uncomment to remove all items from keychain
        //[self removeAllItemsFromKeyChain];
        //NSLog(@"AFTER--_keychainStore: %@", [UICKeyChainStore keyChainStoreWithService:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"]);
    }
    return self;
}


#pragma mark - Custom Getters, To abstract the keychain operation

-(NSString*)username {
    
    return [UICKeyChainStore stringForKey:@"user_name" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}

-(NSString*)accessToken {
    
    return [UICKeyChainStore stringForKey:@"access_token" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}

-(NSString*)expiresIn {
    
    return [UICKeyChainStore stringForKey:@"expires_in" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}

-(NSString*)tokenIssueDateString {
    
    return [UICKeyChainStore stringForKey:@"token_issue_date_string" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}




#pragma mark - Custom Setters

-(void)setUsername:(NSString *)username {
    
    [UICKeyChainStore setString:username forKey:@"user_name" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}

-(void)setAccessToken:(NSString *)accessToken {
    
    [UICKeyChainStore setString:accessToken forKey:@"access_token" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}

-(void)setExpiresIn:(NSString *)expiresIn {
    
    [UICKeyChainStore setString:expiresIn forKey:@"expires_in" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}

-(void)setTokenIssueDateString:(NSString *)tokenIssueDateString {
    
    [UICKeyChainStore setString:tokenIssueDateString forKey:@"token_issue_date_string" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}





#pragma mark - Access Token Refresh Mechanism

-(BOOL)tokenNeedsToBeRefreshed {
    
    // *** NOTE: Below is a Pseudocode describing the Process needed in order to determine if an access token needs to be refreshed
    //           This code could move somewhere else when working on that section of the project.
    
#pragma mark - 1. Store expires_in in keychain as a NSString
    //[_keychainStore setString:@"5183999" forKey:@"expires_in"];
    
    
#pragma mark - 2. Convert current date "token_issue_date_string" to a NSString and store in keychain
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init]; // Format is very important!!
    [dateFormatter2 setDateFormat:@"dd-MM-yyyy"];
    NSString *stringFromDate = [dateFormatter2 stringFromDate:[NSDate date]];
    NSLog(@"stringFromDate:      %@",stringFromDate);
    //[_keychainStore setString:stringFromDate forKey:@"date_token_was_issue"]; // ***
    
#pragma mark - 3. Fetch expires_in NSString from keychain
    //[_keychainStore stringForKey:@"expires_in"]; // ***
    
#pragma mark - 4. Fetch "date_token_was_issue" NSString from keychain
    //[_keychainStore stringForKey:@"date_token_was_issue"]; // ***
    
#pragma mark - 5. Convert "token_issue_date_string" NSString to NSDate
    //NSString *dateString = @"01-02-2010";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // Format is very important!!
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:stringFromDate];
    NSLog(@"dateFromString:      %@",dateFromString);
    
#pragma mark - 6. Convert expires_in NSString to NSDate using the timestamp
    NSString *str = @"5183999";
    NSNumber *num = [NSNumber numberWithInt:[str intValue]];
    NSTimeInterval expires_in = [num intValue];
    NSDate *tokenExpirationDate = [NSDate dateWithTimeInterval:expires_in sinceDate:dateFromString];
    NSLog(@"tokenExpirationDate: %@",tokenExpirationDate);
    
#pragma mark - 7. Compare present date to expires_in (recunstructed) date to determine if token needs refresh.
    // The two operands are equal.
    // The tokenExpirationDate and the Current Date are exactly equal to each other,
    if ([tokenExpirationDate compare:[NSDate date]] == NSOrderedSame) {
        //NSLog(@"tokenExpirationDate: %@",tokenExpirationDate);
    }
    // The left operand is smaller than the right operand.
    // The tokenExpirationDate is earlier in time than the Current Date,
    if ([tokenExpirationDate compare:[NSDate date]] == NSOrderedAscending) {
        //NSLog(@"tokenExpirationDate: %@",tokenExpirationDate);
    }
    // The left operand is greater than the right operand.
    // The tokenExpirationDate is later in time than the Current Date,
    if ([tokenExpirationDate compare:[NSDate date]] == NSOrderedDescending) {
        //NSLog(@"tokenExpirationDate: %@",tokenExpirationDate);
    }
    
    return YES;
}



#pragma mark - Helper Methods

-(NSString*)stringFromDate:(NSDate *)date {
          
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // Format is very important!!
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    return [dateFormatter stringFromDate:[NSDate date]];
}


#pragma mark - Delete Account From Keychain

-(void)removeAllItemsFromKeyChain {
    
    [UICKeyChainStore removeAllItemsForService:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}


@end
