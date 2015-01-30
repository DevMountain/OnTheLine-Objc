//
//  PhotosListViewController.m
//  OnTheLine-Objc
//
//  Created by Joshua Howland on 1/26/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "PhotosListViewController.h"
#import "SimplePhotosController.h"
#import "PhotoTableViewCell.h"

@interface PhotosListViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) bool alreadyLaunched;

@end

@implementation PhotosListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 1;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Take Photo

- (IBAction)takePhoto:(id)sender {

    
}

+ (CGFloat)photoCellHeight {
    return 44;
}


#pragma mark - CloudKit PhotosController

- (IBAction)refresh:(id)sender {

    if (!self.alreadyLaunched) {
        self.alreadyLaunched = YES;
    }

    [sender endRefreshing];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
    return cell;
}

@end


