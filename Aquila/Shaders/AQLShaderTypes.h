//
//  AQLShaderTypes.h
//  Aquila
//
//  Created by liusiyuan on 2021/10/29.
//

#include <simd/simd.h>

typedef enum AQLVertexInputIndex
{
    AQLVertexInputIndexVertices     = 0,
    AQLVertexInputIndexViewportSize = 1,
} AQLVertexInputIndex;


typedef struct
{
    vector_float2 position;
    vector_float4 color;
} AQLVertex;
