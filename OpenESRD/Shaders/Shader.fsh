//
//  Shader.fsh
//  OpenESRD
//
//  Created by wangyang on 2016/9/30.
//  Copyright © 2016年 wangyang. All rights reserved.
//

varying lowp vec4 colorVarying;
varying lowp vec2 uvVarying;

uniform sampler2D s_texture;

void main()
{
    gl_FragColor = texture2D( s_texture,uvVarying ) + colorVarying;
}
