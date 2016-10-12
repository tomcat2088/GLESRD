//
//  GLDefines.h
//  OpenESRD
//
//  Created by wangyang on 2016/9/30.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#ifndef GLDefines_h
#define GLDefines_h

enum {
    UNIFORM_VIEWPROJECTION,
    UNIFORM_MODEL_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    UNIFORM_AMBIENT,
    UNIFORM_DIFFUSE,
    UNIFORM_SPECULAR,
    NUM_UNIFORMS
};

// Attribute index.
enum {
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

#endif /* GLDefines_h */
