//
//  ViewController.m
//  Sqlite
//
//  Created by Tecksky Techonologies on 12/21/16.
//  Copyright © 2016 Tecksky Technologies. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nametxt;
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property (weak, nonatomic) IBOutlet UITextField *searchTxt;
@property (weak, nonatomic) IBOutlet UIButton *search;
@property (weak, nonatomic) IBOutlet UILabel *serchname;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savedata:(id)sender
{
    BOOL res = [[DBManager getSharedInstance] insertData:_nametxt.text];
    if (res) {
        NSLog(@"Success");
    }
    else
    {
        NSLog(@"Error");
    }
}
- (IBAction)searchdata:(id)sender
{
    NSArray *records = [[DBManager getSharedInstance] searchStudent:[_searchTxt.text integerValue]];
    NSLog(@"%@",records);
    _serchname.text = [records objectAtIndex:0];
}

@end
