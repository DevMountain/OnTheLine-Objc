//
//  CloudManager.m
//  OnTheLine-Objc
//
//  Created by Joshua Howland on 1/28/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "CloudManager.h"

NSString * const PhotoAssetRecordType = @"Photos";
NSString * const PhotoAssetField = @"photo";
NSString * const CreatedDateField = @"createdDate";
NSString * const MessagesField = @"comments";
NSString * const NameField = @"name";
NSString * const UserReferenceField = @"user";

NSString * const SenderKey = @"sender";

@interface CloudManager ()

@property (nonatomic, strong) CKDatabase *publicDatabase;

@property (nonatomic, strong) CKRecord *userRecord;
@property (nonatomic, strong) CKRecordID *userRecordID;
@property (nonatomic, strong) CKDiscoveredUserInfo *userInfo;

@property (nonatomic, assign) CKApplicationPermissionStatus permissionStatus;

@end

@implementation CloudManager

+ (CloudManager *)sharedInstance {
    static CloudManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CloudManager alloc] init];
        [sharedInstance setupContainer];
    });
    
    return sharedInstance;
}

- (void)setupContainer {

    CKContainer *container = [CKContainer defaultContainer];
    self.publicDatabase = [container publicCloudDatabase];
    
    [container requestApplicationPermission:CKApplicationPermissionUserDiscoverability completionHandler:^(CKApplicationPermissionStatus status, NSError *error){
        self.permissionStatus = status;
        
        if(self.permissionStatus == CKApplicationPermissionStatusGranted) {
            [self findMeWithCompletion:nil];
        }
        
        if(error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void)uploadAssetWithURL:(NSURL *)assetURL message:(NSString *)message completionHandler:(void (^)(CKRecord *record))completionHandler {
    
    CKRecord *assetRecord = [[CKRecord alloc] initWithRecordType:PhotoAssetRecordType];
    assetRecord[CreatedDateField] = [NSDate date];
    assetRecord[MessagesField] = @[message];
    
    CKAsset *photo = [[CKAsset alloc] initWithFileURL:assetURL];
    assetRecord[PhotoAssetField] = photo;
    
    if (self.userRecord) {
        CKReference *userReference = [[CKReference alloc] initWithRecordID:self.userRecord.recordID action:CKReferenceActionDeleteSelf];
        assetRecord[UserReferenceField] = userReference;
    }
    
    [self.publicDatabase saveRecord:assetRecord completionHandler:^(CKRecord *record, NSError *error) {
        if (error) {
            // In your app, masterfully handle this error.
            NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(record);
            });
        }
    }];
}

- (void)fetchRecordsWithType:(NSString *)recordType completionHandler:(void (^)(NSArray *records))completionHandler {
    
    NSPredicate *truePredicate = [NSPredicate predicateWithValue:YES];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:recordType predicate:truePredicate];
    query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO]];
    
    CKQueryOperation *queryOperation = [[CKQueryOperation alloc] initWithQuery:query];
    queryOperation.desiredKeys = @[NameField];
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    queryOperation.recordFetchedBlock = ^(CKRecord *record) {
        [results addObject:record];
    };
    
    queryOperation.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error) {
        if (error) {
            // In your app, this error needs love and care.
            NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(results);
            });
        }
    };
    
    [self.publicDatabase addOperation:queryOperation];
}

- (void)fetchRecordWithID:(NSString *)recordID completionHandler:(void (^)(CKRecord *record))completionHandler {
    
    CKRecordID *current = [[CKRecordID alloc] initWithRecordName:recordID];
    [self.publicDatabase fetchRecordWithID:current completionHandler:^(CKRecord *record, NSError *error) {
        
        if (error) {
            // In your app, handle this error gracefully.
            NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(record);
            });
        }
    }];
}

- (CKDiscoveredUserInfo *)findMeWithCompletion:(void(^)(CKDiscoveredUserInfo*info, NSError *error))completion {
    if(!self.userInfo) {
        CKContainer *container = [CKContainer defaultContainer];
        
        
        void(^fetchedMyRecord)(CKRecord *record, NSError *error) = ^(CKRecord *userRecord, NSError *error) {
            self.userRecord = userRecord;
            if (!userRecord[@"username"]) {
                userRecord[@"username"] = [self randomStringWithLength:8];
            }
            [self.publicDatabase saveRecord:userRecord completionHandler:^(CKRecord *record, NSError *error){
                NSLog(@"Saved record ID %@", record.recordID);
            }];
        };
        
        void (^discovered)(NSArray *, NSError *) = ^(NSArray *userInfo, NSError *error) {
            if (self.userRecordID) {
                if (userInfo.count > 0) {
                    NSInteger index = [userInfo indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                        CKDiscoveredUserInfo *info = obj;
                        return [info.userRecordID isEqual:self.userRecordID];
                    }];
                    
                    CKDiscoveredUserInfo *me = userInfo[index];
                    if(me) {
                        self.userInfo = me;
                        [self.publicDatabase fetchRecordWithID:self.userRecordID completionHandler:fetchedMyRecord];
                    }
                }
            }
        };
        
        if(self.permissionStatus == CKApplicationPermissionStatusGranted) {
            [container fetchUserRecordIDWithCompletionHandler:^(CKRecordID *recordID, NSError *error) {
                self.userRecordID = recordID;
                
                [self.publicDatabase fetchRecordWithID:self.userRecordID completionHandler:fetchedMyRecord];
            }];
            
            [container discoverAllContactUserInfosWithCompletionHandler:discovered];
            
        } else {
            if(completion) {
                completion(self.userInfo, nil);
            }
        }
    } else {
        if(completion) {
            completion(self.userInfo, nil);
        }
    }
    return self.userInfo;
}

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

- (NSString *)randomStringWithLength:(int)length {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}

@end
