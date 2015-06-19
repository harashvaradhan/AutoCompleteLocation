//
//  ViewController.m
//  CompleteLocation
//
//  Created by GNR solution PVT.LTD on 19/06/15.
//  Copyright (c) 2015 Harshavardhan Edke. All rights reserved.
//

#import "ViewController.h"
#import "Common/Constants.h"
#import "Place.h"

@interface ViewController (){
    NSMutableArray *response;
    Place *place;
    NSMutableArray *places;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self.txtSearchField becomeFirstResponder];
    self.tableViewSearchResult.hidden = YES;
}
#pragma mark - Search For Location on Google API
-(void)searchForResult:(NSString *)input{
    NSString *urlString = [NSString stringWithFormat:@"%@input=%@&key=%@",GOOGLE_AUTOCOMPLETE,input,GOOGLE_API_KEY];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            if (data) {
                NSError *error;
                NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                if (!error) {
//                    NSLog(@"Respone Data : %@",responseData);
                    if ([[responseData objectForKey:@"status"] isEqualToString:@"OK"]) {
                        places = [[NSMutableArray alloc]init];
                        for (NSDictionary *dict in [responseData objectForKey:@"predictions"]) {
                            place = [[Place alloc]init];
                            place.placeID = [dict objectForKey:@"place_id"];
                            place.placeName = [dict objectForKey:@"description"];
                            [places addObject:place];
                        }
                        if ([places count]> 0) {
                            [self.tableViewSearchResult performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                            self.tableViewSearchResult.hidden = NO;
                        }
                    }else{
                        NSLog(@"%@ : %@",[responseData objectForKey:@"status"],[responseData objectForKey:@"error_message"]);
                    }
                }else{
                    NSLog(@"Connection Error : %@",connectionError);
                }
            }else{
                NSLog(@"No Respone Data");
            }
        }else{
            NSLog(@"Connection Error : %@",connectionError);
        }
    }];
}

#pragma mark - UITextField Delgate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (![string isEqualToString:@""] && [string length]>0) {
        NSString *keyword = [textField.text stringByAppendingString:string];
        NSLog(@"String : %@",keyword);
        if ([keyword length]>=3) {
            [self searchForResult:keyword];
        }
    }
    return YES;
}
#pragma mark - UITableViewDelegate 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    place = [places objectAtIndex:indexPath.row];
    self.txtSearchField.text = place.placeName;
    NSLog(@"Selected placeID : %@",place.placeID);
    self.tableViewSearchResult.hidden = YES;
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"cell"];
    }
    place = [places objectAtIndex:indexPath.row];
    NSLog(@"Place ID : %@, Place Name : %@",place.placeID,place.placeName);
    cell.textLabel.text = [place placeName];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [places count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
