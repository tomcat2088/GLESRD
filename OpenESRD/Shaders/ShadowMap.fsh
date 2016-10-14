//
//  Shader.fsh
//  OpenESRD
//
//  Created by wangyang on 2016/9/30.
//  Copyright © 2016年 wangyang. All rights reserved.
//


varying highp vec4 frag_position;
varying highp vec3 frag_normal;
varying lowp vec2 frag_uv;

uniform sampler2D diffuseMap;
uniform sampler2D shadowMap;

uniform highp mat4 lightViewProjection;
uniform highp mat4 viewProjection;
uniform highp mat4 modelMatrix;
uniform highp mat3 normalMatrix;

uniform highp vec4 ambient;
uniform highp vec4 diffuse;
uniform highp vec4 specular;

uniform highp vec4 lightColor;
uniform highp vec3 lightPosition;
uniform highp float lightBrightness;
uniform lowp int renderAsShadow;

void main()
{
    highp vec4 surfaceColor = texture2D( diffuseMap,frag_uv );
    gl_FragColor = surfaceColor;
}
