//
//  PhotosListViewController.m
//  OnTheLine-Objc
//
//  Created by Joshua Howland on 1/26/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "PhotosListViewController.h"
#import "PhotoTableViewCell.h"

#import "SVProgressHUD.h"

@interface PhotosListViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) bool alreadyLaunched;
@property (nonatomic, assign) NSInteger photoCount;

@end

@implementation PhotosListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"On The Line";
    [self refresh:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (IBAction)takePhoto:(id)sender {

    self.photoCount++;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"Photo %ld", (long)indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        default:
            return self.photoCount;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PhotosListViewController photoCellHeight];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

+ (CGFloat)photoCellHeight {
    return 44;
}

#pragma mark - Simple PhotoController

- (IBAction)refresh:(id)sender {
    [self.tableView reloadData];
    [sender endRefreshing];
    
}

@end


