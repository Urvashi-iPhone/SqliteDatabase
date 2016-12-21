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
@property (weak, nonatomic) IBOutlet UITextField *phonetxt;

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
    BOOL res = [[DBManager getSharedInstance]insertData:_nametxt.text :_phonetxt.text];
    if (res) {
        NSLog(@"Success");
    }
    else
    {
        NSLog(@"Error");
    }
}
- (IBAction)updateData:(id)sender
{
    BOOL res = [[DBManager getSharedInstance] updateData:[_searchTxt.text integerValue]:_nametxt.text];
    if (res) {
        NSLog(@"Success");
    }
    else
    {
        NSLog(@"Error");
    }
  
}
- (IBAction)deleteData:(id)sender
{
    BOOL res = [[DBManager getSharedInstance] deleteData:[_searchTxt.text integerValue]];
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
    _serchname.text = [[records objectAtIndex:0] valueForKey:@"name"];
}

@end
