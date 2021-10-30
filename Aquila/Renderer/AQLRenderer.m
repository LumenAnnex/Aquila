//
//  AQLRenderer.m
//  Aquila
//
//  Created by Lumen on 2021/10/2.
//

@import simd;
@import MetalKit;

#import "AQLRenderer.h"
#import "AQLShaderTypes.h"

@interface AQLRenderer()
@property(strong, nonatomic) id<MTLDevice> device;
@property(strong, nonatomic) id<MTLRenderPipelineState> pipelineState;
@property(strong, nonatomic) id<MTLCommandQueue> commandQueue;
@property(assign, nonatomic) vector_uint2 viewportSize;
@end

@implementation AQLRenderer

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView vertexShader:(nonnull NSString *)vertex fragmentShader:(nonnull NSString *)frag
{
    self = [super init];
    if(self)
    {
        NSError *error;

        self.device = mtkView.device;

        id<MTLLibrary> defaultLibrary = [self.device newDefaultLibrary];

        id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:vertex];
        id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:frag];

        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineStateDescriptor.label = @"Simple Pipeline";
        pipelineStateDescriptor.vertexFunction = vertexFunction;
        pipelineStateDescriptor.fragmentFunction = fragmentFunction;
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;

        self.pipelineState = [self.device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor
                                                                 error:&error];
                
        NSAssert(self.pipelineState, @"Failed to create pipeline state: %@", error);

        self.commandQueue = [self.device newCommandQueue];
    }

    return self;
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size
{
    _viewportSize.x = size.width;
    _viewportSize.y = size.height;
}

- (void)drawInMTKView:(nonnull MTKView *)view
{
    static const AQLVertex triangleVertices[] =
    {
        { {  250,  -250 }, { 1, 0, 0, 1 } },
        { { -250,  -250 }, { 0, 1, 0, 1 } },
        { {    0,   250 }, { 0, 0, 1, 1 } },
    };

    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"MyCommand";

    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;

    if(renderPassDescriptor != nil)
    {
        id<MTLRenderCommandEncoder> renderEncoder =
        [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        renderEncoder.label = @"MyRenderEncoder";

        [renderEncoder setViewport:(MTLViewport){0.0, 0.0, _viewportSize.x, _viewportSize.y, 0.0, 1.0 }];
        
        [renderEncoder setRenderPipelineState:_pipelineState];

        [renderEncoder setVertexBytes:triangleVertices
                               length:sizeof(triangleVertices)
                              atIndex:AQLVertexInputIndexVertices];
        
        [renderEncoder setVertexBytes:&_viewportSize
                               length:sizeof(_viewportSize)
                              atIndex:AQLVertexInputIndexViewportSize];

        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:3];

        [renderEncoder endEncoding];

        [commandBuffer presentDrawable:view.currentDrawable];
    }

    [commandBuffer commit];
}

@end
