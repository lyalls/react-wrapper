//
//  UIPickerViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/19.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIPickerViewController.h"

@interface UIPickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation UIPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom method

- (IBAction)cancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneBtnClick:(id)sender {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    switch (self.displayType) {
        case PickerDisplayTypeBankList: {
            [array addObject:[[UserDefaultsHelper sharedManager].bankList objectAtIndex:[self.pickerView selectedRowInComponent:0]]];
            break;
        }
        case PickerDisplayTypeAreaList: {
            NSDictionary *provinceDic = [[UserDefaultsHelper sharedManager].areaList objectAtIndex:[self.pickerView selectedRowInComponent:0]];
            NSDictionary *cityDic = [[provinceDic objectForKey:@"cityList"] objectAtIndex:[self.pickerView selectedRowInComponent:1]];
            [array addObject:provinceDic];
            [array addObject:cityDic];
            break;
        }
    }
    
    if (self.doneBlock) {
        self.doneBlock(array);
    }
    
    [self cancelBtnClick:nil];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (self.displayType) {
        case PickerDisplayTypeBankList: {
            return 1;
            break;
        }
        case PickerDisplayTypeAreaList: {
            return 2;
            break;
        }
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (self.displayType) {
        case PickerDisplayTypeBankList: {
            return [UserDefaultsHelper sharedManager].bankList.count;
            break;
        }
        case PickerDisplayTypeAreaList: {
            if (component == 0)
                return [UserDefaultsHelper sharedManager].areaList.count;
            else
                return [[[[UserDefaultsHelper sharedManager].areaList objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"cityList"] count];
            break;
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (self.displayType) {
        case PickerDisplayTypeBankList: {
            break;
        }
        case PickerDisplayTypeAreaList: {
            if (component == 0)
                [pickerView reloadComponent:1];
            break;
        }
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (self.displayType) {
        case PickerDisplayTypeBankList: {
            NSDictionary *dic = [[UserDefaultsHelper sharedManager].bankList objectAtIndex:row];
            
            return [dic objectForKey:@"bankName"];
            break;
        }
        case PickerDisplayTypeAreaList: {
            if (component == 0) {
                NSDictionary *dic = [[UserDefaultsHelper sharedManager].areaList objectAtIndex:row];
                return [dic objectForKey:@"provinceName"];
            } else {
                NSDictionary *dic = [[[[UserDefaultsHelper sharedManager].areaList objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"cityList"] objectAtIndex:row];
                return [dic objectForKey:@"cityName"];
            }
            break;
        }
    }
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
