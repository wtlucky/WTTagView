//
//  WTInputTitleViewController.m
//  WTTagView
//
//  Created by wtlucky on 7/25/15.
//  Copyright (c) 2015 wtlucky. All rights reserved.
//

#import "WTInputTitleViewController.h"

@interface WTInputTitleViewController ()

@property (nonatomic, weak) IBOutlet UITextField *inputTextField;

@end

@implementation WTInputTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)inputTextEnd:(id)sender {
    [self.inputTextField endEditing:YES];
    !self.endInputTitleHandler ?: self.endInputTitleHandler(self.inputTextField.text);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
