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

uniform highp vec4 ambient;
uniform highp vec4 diffuse;
uniform highp vec4 specular;

void main()
{
    highp vec3 lightPosition = vec3(0.0, 20.0, 20.0);
    highp vec4 lightColor = vec4(1.0, 1.0, 0.0, 1.0);
    
    highp vec3 eyePosition = vec3(viewProjection * modelMatrix * frag_position);
    highp vec3 eyeNormal = normalize(normalMatrix * frag_normal);
    highp vec3 eyeLightVec = vec3(viewProjection * vec4(lightPosition,1.0)) - vec3(eyePosition);
    highp float eyeLightDistance = distance(eyeLightVec,vec3(0,0,0));
    
    highp float brightness = max(0.0, 800.0 * dot(eyeNormal, normalize(eyeLightVec)));

    highp vec4 surfaceColor = diffuse;//texture2D( texture0,frag_uv );
    highp vec3 ambientColor = ambient.rgb;
    
    highp vec3 eyeReverseVec = normalize(vec3(0.0,0.0,0.0) - eyePosition);
    highp vec3 reflectLightVec = reflect(-normalize(eyeLightVec),eyeNormal);
    highp float cosAlpha = max(0.0 , dot( eyeReverseVec, reflectLightVec ));
    highp vec3 specularColor = specular.rgb * lightColor.rgb * brightness * pow(cosAlpha,50.0) / pow(eyeLightDistance, 2.0);
    
    gl_FragColor = vec4(lightColor.rgb * surfaceColor.rgb * brightness / pow(eyeLightDistance, 2.0) + ambientColor + specularColor,surfaceColor.a);
}
