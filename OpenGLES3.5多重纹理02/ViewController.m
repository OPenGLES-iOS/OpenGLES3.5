//
//  ViewController.m
//  OpenGLES3.5多重纹理02
//
//  Created by ShiWen on 2017/5/12.
//  Copyright © 2017年 ShiWen. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"

typedef struct {
    GLKVector3 postionCorrds;
    GLKVector2 vertureCorrds;
    
}Scens;

static Scens vertures[]={
    {{-0.5f,-0.5f,0.0f},{0.0f,0.0f}},
    {{-0.5f,0.5f,0.0f},{0.0f,1.0f}},
    {{0.5f,-0.5f,0.0f},{1.0f,0.0f}},
    
    {{0.5f,0.5f,0.0f},{1.0f,1.0f}},
    {{0.5f,-0.5f,0.0f},{1.0f,0.0f}},
    {{-0.5f,0.5f,0.0f},{0.0f,1.0f}},
};

@interface ViewController ()

@property (nonatomic,strong) AGLKVertexAttribArrayBuffer *mVertexBuffer;
@property (nonatomic,strong) GLKBaseEffect *mBaseEffect;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConfig];
}
-(void)setupConfig{
    GLKView *view = (GLKView *)self.view;
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:view.context];
    [((AGLKContext *)view.context) setClearColor:GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f)];
    
    self.mVertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStride:sizeof(Scens) numberOfVertices:sizeof(vertures)/sizeof(Scens) bytes:vertures usage:GL_STATIC_DRAW];
    self.mBaseEffect = [[GLKBaseEffect alloc] init];
    self.mBaseEffect.useConstantColor = GL_TRUE;
    self.mBaseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    CGImageRef imageRef0 = [[UIImage imageNamed:@"leaves.gif"] CGImage];
    NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:@(1),GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo *textureInfo0 = [GLKTextureLoader textureWithCGImage:imageRef0 options:options error:nil];
    self.mBaseEffect.texture2d0.target = textureInfo0.target;
    self.mBaseEffect.texture2d0.name = textureInfo0.name;
    
    CGImageRef imageRef1 = [[UIImage imageNamed:@"beetle.png"] CGImage];
    GLKTextureInfo *textureInfo1 = [GLKTextureLoader textureWithCGImage:imageRef1 options:options error:nil];
    self.mBaseEffect.texture2d1.target = textureInfo1.target;
    self.mBaseEffect.texture2d1.name = textureInfo1.name;
    //该模式会让两个纹理混合 默认为 GLKTextureEnvModeModulate 会让计算出来的颜色与纹理混合
    self.mBaseEffect.texture2d1.envMode = GLKTextureEnvModeDecal;
    
    
    
}
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [((AGLKContext *)view.context) clear:GL_COLOR_BUFFER_BIT];
    //矩形背景
    [self.mVertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(Scens, postionCorrds) shouldEnable:YES];
    //第一个纹理，叶子
    [self.mVertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(Scens, vertureCorrds) shouldEnable:YES];
    //第二个纹理，虫
    [self.mVertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord1 numberOfCoordinates:2 attribOffset:offsetof(Scens, vertureCorrds) shouldEnable:YES];
    [self.mBaseEffect prepareToDraw];
    [self.mVertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(vertures)/sizeof(Scens)];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
