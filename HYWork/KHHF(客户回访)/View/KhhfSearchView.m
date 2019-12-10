//
//  KhhfSearchView.m
//  HYWork
//
//  Created by information on 2018/5/15.
//  Copyright © 2018年 hongyan. All rights reserved.
//
#import "KhhfSearchView.h"

@interface KhhfSearchView() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *khdmField;
@property (weak, nonatomic) IBOutlet UITextField *khmcField;


- (IBAction)search;
- (IBAction)reset;
- (IBAction)checkDistrict;
- (IBAction)checkFl;

@end

@implementation KhhfSearchView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.khdmField addTarget:self action:@selector(khdmChange:) forControlEvents:UIControlEventEditingChanged];
    [self.khmcField addTarget:self action:@selector(khmcChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.khdmField.delegate = self;
    self.khmcField.delegate = self;
    
}

+ (instancetype)searchView {
    return [[[NSBundle mainBundle] loadNibNamed:@"KhhfSearchView" owner:nil options:nil] lastObject];
}

- (void)khdmChange:(UITextField *)field {
    self.tableParam.khdm = field.text;
}

- (void)khmcChange:(UITextField *)field {
    self.tableParam.khmc = field.text;
}

- (IBAction)search {
    [self endEditing:YES];
    !_searchBlock ? : _searchBlock();
}

- (IBAction)reset {
    self.khdmField.text = @"";
    self.khmcField.text = @"";
    self.tableParam.khdm = @"";
    self.tableParam.khmc = @"";
    self.districtField.text = @"";
    self.tableParam.dq = @"";
}

- (IBAction)checkDistrict {
    !_districtBlock ? : _districtBlock();
}

- (IBAction)checkFl {
    !_classifyBlock ? : _classifyBlock();
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
