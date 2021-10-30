//
//  AQLShaderTestViewController.m
//  Aquila
//
//  Created by liusiyuan on 2021/10/29.
//

#import "AQLShaderTestViewController.h"
#import "AQLRenderer.h"

@interface AQLShaderTestViewController()
@property (strong, nonatomic) MTKView *mtkView;
@property (strong, nonatomic) AQLRenderer *renderer;
@end

@implementation AQLShaderTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.mtkView = [MTKView new];
    self.mtkView.device = MTLCreateSystemDefaultDevice();
    
    [self.view addSubview:self.mtkView];
    self.mtkView.frame = self.view.frame;
    
    self.renderer = [[AQLRenderer alloc] initWithMetalKitView:self.mtkView vertexShader:@"TestVertexShader" fragmentShader:@"TestFragmentShader"];
    [self.renderer mtkView:self.mtkView drawableSizeWillChange:self.mtkView.drawableSize];
    self.mtkView.delegate = self.renderer;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


@end
