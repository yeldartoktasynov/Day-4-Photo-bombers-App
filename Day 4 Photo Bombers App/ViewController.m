//
//  ViewController.m
//  Day 4 Photo Bombers App
//
//  Created by yeldar.toktasynov on 17.06.15.
//  Copyright (c) 2015 yeldar.toktasynov. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCollectionViewCell.h"
#import <SimpleAuth/SimpleAuth.h>
#import "DetailViewController.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSMutableArray *photos;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults objectForKey:@"accessToken"];
    
    // Do any additional setup after loading the view, typically from a nib.
    if(self.accessToken==nil){
        [SimpleAuth authorize:@"instagram" completion:^(NSDictionary *responseObject, NSError *error) {
            self.accessToken = responseObject[@"credentials"][@"token"];
            [userDefaults setObject:self.accessToken forKey:@"accessToken"];
            [userDefaults synchronize];
            //download images
            [self downloadImages];
            NSLog(@"saved credentials");
        }];
    } else {
        //download images
        NSLog(@"using previous credentials");
        [self downloadImages];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - helper methods

-(void) downloadImages
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/cars/media/recent?access_token=%@", self.accessToken];
    //NSLog(@"%@", urlString);
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        //NSLog(@"response is: %@", response);
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSLog(@"response dictionary is: %@", responseDictionary);
        self.photos = responseDictionary[@"data"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
    }];
    [task resume];
}

#pragma mark - UICollectionView methods

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.photos count];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //return newly created Cell
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
   // cell.imageView.image =[UIImage imageNamed:@"audi.jpg"];
   //now we need to parse image from NSDictionary
    
    NSDictionary *photo = self.photos[indexPath.row];
    cell.photo  = photo;
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *photo = self.photos[indexPath.row];
    DetailViewController *viewController = [DetailViewController new];
    viewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    viewController.photo = photo;
    [self presentViewController:viewController animated:YES completion:nil];
    
}


@end
