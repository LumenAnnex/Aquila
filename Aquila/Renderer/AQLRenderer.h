//
//  AQLRenderer.h
//  Aquila
//
//  Created by Lumen on 2021/10/2.
//

@import MetalKit;

@interface AQLRenderer : NSObject<MTKViewDelegate>

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView vertexShader:(nonnull NSString *)vertex fragmentShader:(nonnull NSString *)frag;

@end
