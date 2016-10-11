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

uniform sampler2D texture0;
uniform highp mat4 viewProjection;
uniform highp mat4 modelMatrix;
uniform highp mat3 normalMatrix;

void main()
{
    highp vec3 lightPosition = vec3(0.0, 0.0, 20.0);
    highp vec4 lightColor = vec4(1.0, 1.0, 0.0, 1.0);
    
    highp vec3 eyePosition = vec3(viewProjection * modelMatrix * frag_position);
    highp vec3 eyeNormal = normalize(normalMatrix * frag_normal);
//    highp vec3 eyeLightVec = vec3(viewProjection * vec4(lightPosition,1.0)) - vec3(eyePosition);
    highp vec3 eyeLightVec = vec3(viewProjection * vec4(lightPosition,1.0)) - vec3(eyePosition);
    
    highp float brightness = max(0.0, dot(eyeNormal, eyeLightVec));

    highp vec4 surfaceColor;
    surfaceColor = texture2D( texture0,frag_uv );
    gl_FragColor = surfaceColor;//vec4(lightColor.rgb * surfaceColor.rgb * brightness,surfaceColor.a);
}
