//
//  SampleViewController.m
//  OnTheLine-Objc
//
//  Created by Caleb Hicks on 1/29/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "SampleViewController.h"
#import "SampleDetailViewController.h"

@interface SampleViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendNameButton;

@end

@implementation SampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SampleDetailViewController *destinationViewController = segue.destinationViewController;
    
    destinationViewController.name = self.nameTextField.text;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
