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
    const highp mat4 biasMat = mat4(0.5, 0.0, 0.0, 0.0,
                              0.0, 0.5, 0.0, 0.0,
                              0.0, 0.0, 1.0, 0.0,
                              0.5, 0.5, 0.0, 1.0);
    
    if ( renderAsShadow > 0 ) {
        highp vec4 v_v4TexCoord = lightViewProjection * modelMatrix * frag_position;
       highp float value = 100.0 - v_v4TexCoord.z;
       highp float v = floor(value);
       highp float f = value - v;
       highp float vn = v * 0.01;
        gl_FragColor = vec4(vn, f, 0.0, 1.0);
    } else {
        highp vec4 v_v4TexCoord = biasMat * lightViewProjection * modelMatrix * frag_position;
        
        /* Draw main scene - read and compare shadow map. */
        highp vec2 vfDepth = texture2DProj(shadowMap, v_v4TexCoord).xy;
        highp float fDepth = (vfDepth.x * 100.0 + vfDepth.y);
        /* Unpack the light distance. See how it is packed in the shadow.frag file. */
        highp float fLDepth = (100.0 - v_v4TexCoord.z) + 0.1 - fDepth ;
        highp float fLight = 1.0;
        if(fDepth > 0.0 && fLDepth < 0.0)
        {
            fLight = 0.2;
            /* Make sure there is no specular effect on obscured fragments. */
//            intensitySpecular = 0.0;
        }
        
        highp vec3 eyePosition = vec3(viewProjection * modelMatrix * frag_position);
        highp vec3 eyeNormal = normalize(normalMatrix * frag_normal);
        highp vec3 eyeLightVec = vec3(viewProjection * vec4(lightPosition,1.0)) - vec3(eyePosition);
        highp float eyeLightDistance = distance(eyeLightVec,vec3(0,0,0));
        
        highp float brightness = max(0.0, 1000.0 * lightBrightness * dot(eyeNormal, normalize(eyeLightVec)));
        
        
        highp vec4 surfaceColor = texture2D( diffuseMap,frag_uv ) + diffuse;
        highp vec3 ambientColor = ambient.rgb;
        
        highp vec3 eyeReverseVec = normalize(vec3(0.0,0.0,0.0) - eyePosition);
        highp vec3 reflectLightVec = reflect(-normalize(eyeLightVec),eyeNormal);
        highp float cosAlpha = max(0.0 , dot( eyeReverseVec, reflectLightVec ));
        highp vec3 specularColor = specular.rgb * lightColor.rgb * brightness * pow(cosAlpha,50.0) / pow(eyeLightDistance, 2.0);
        
        highp vec3 finalColor = lightColor.rgb * surfaceColor.rgb * brightness / pow(eyeLightDistance, 2.0) + ambientColor + specularColor;
        gl_FragColor = vec4(finalColor * fLight,surfaceColor.a);
    }
}
