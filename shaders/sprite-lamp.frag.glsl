#version 100
#ifdef GL_ES
precision mediump float;
#endif
 



// Sprite Lamp's basic shader, by Finn Morgan

varying vec2 texCoord;
varying vec4 color;

uniform vec3 position;
varying mat3 rotationMatrix;

uniform vec3 lightPos;
uniform vec3 lightColour;
uniform int lightCount;

uniform sampler2D tex;
uniform sampler2D normalDepthMap;
uniform sampler2D specGlossMap;
uniform sampler2D aoMap;
uniform sampler2D emissiveMap;


uniform float celLevel;
uniform float shininess;
uniform float wrapAroundLevel;
uniform float aoStrength;
uniform float emissiveStrength;
uniform float amplifyDepth;

uniform vec3 upperAmbientColour;
uniform vec3 lowerAmbientColour;

uniform vec2 resolution;

//uniform Light lights[255];
//uniform int lightCount;





void kore()
{
    //All the texture lookups we need done up front (not counting lookups for shadowing).
    vec4 diffuseColour = texture2D (tex, texCoord) * color;
    vec4 normalDepthColour = texture2D (normalDepthMap, texCoord);
    vec4 specGlossColour = texture2D (specGlossMap, texCoord);
    vec4 aoColour = texture2D (aoMap, texCoord);
    vec4 emissiveColour = texture2D (emissiveMap, texCoord);

    
    vec3 normal = normalDepthColour.rgb * 2.0 - 1.0;
    
    vec3 worldNormal = normal * rotationMatrix; //We need this for hemispheric ambience
    
    float ambientOcclusion = (aoColour.r * aoStrength) + (1.0 - aoStrength);
        
    float aspectRatio = resolution.x / resolution.y;
        
    //'upness' - 1.0 means the normal is facing straight up, 0.5 means horizontal, 0.0 straight down, etc.    
    float upness = worldNormal.y * 0.5 + 0.5;
    vec3 ambientColour = (lowerAmbientColour * (1.0 - upness) + upperAmbientColour * upness) * ambientOcclusion * diffuseColour.rgb;
    
    ambientColour += emissiveColour.rgb * emissiveStrength;
    
    vec3 colourFromLights = vec3(0.0, 0.0, 0.0);
    //Everything in this block is calculations for an individual light. This is the bit that
    //has to be looped through and added together 
   // for(int i=0; i < 1; i++)
   //{
		
        vec3 lightDirection = lightPos - position;
        float lightDistance = length(lightDirection);
        lightDirection = rotationMatrix * lightDirection; //We need the light direction in object space for shadow casting.
        lightDirection = normalize(lightDirection);
    
        //Start by calculating how much this is in shadow (1.0 meaning 'not in shadow at all' and 0.0 meaning 'fully in shadow')
        float shadowMult = 1.0;
                    
        vec3 moveVec = lightDirection.xyz * 0.006 * vec3(1.0, aspectRatio * -1.0, 1.0);
    
        float thisHeight = normalDepthColour.a * amplifyDepth;
        vec3 tapPos = vec3(texCoord, thisHeight + 0.1);
        //This loop traces along the light ray and checks if that ray is inside the depth map at each point.
        //If it is, darken that pixel a bit.
        /*for (int i = 0; i < 8; i++)
        {
            tapPos += moveVec;
            float tapDepth = texture2D(normalDepthMap, tapPos.xy).a * amplifyDepth;
            //phantomColour = texture2D(normalDepthMap, tapPos.xy).aaa;
            if (tapDepth > tapPos.z)
            {
                shadowMult -= 0.125;
            }
        }*/
       // shadowMult = clamp(shadowMult, 0.0, 1.0);
        shadowMult = 1.0;
        
        
        //Basic dot lighting.
        float normalDotLight = dot(normal, lightDirection);
        
        //Simple linear attenuation at the moment:
        float attenuation = 0.5 / lightDistance;
                
        //Slightly awkward maths for light wrap.
        float diffuseLevel = clamp(normalDotLight + wrapAroundLevel, 
                0.0, wrapAroundLevel + 1.0) / (wrapAroundLevel + 1.0) * shadowMult;
                //0.0, wrapAroundLevel + 1.0) / (wrapAroundLevel + 1.0) * attenuation * shadowMult;
        
        // Compute specular part of lighting
        float specularLevel;
        if (normalDotLight < 0.0)
        {
            // Light is on the wrong side, no specular reflection
            specularLevel = 0.0;
        }
        else
        {
            // For the moment, since this is 2D, we'll say the view vector is always (0, 0, -1).
            //This isn't really true when you're not using a orthographic camera though. FIXME.
            vec3 viewDirection = vec3(0.0, 0.0, 1.0);
            specularLevel = attenuation * pow(max(0.0, dot(reflect(-lightDirection, normal),
                viewDirection)), shininess * specGlossColour.a);
        }
                
                
        // Add cel-shading if enough levels were specified
        if (celLevel >= 2.0)
        {
            diffuseLevel = floor(diffuseLevel * celLevel) / (celLevel - 0.5);
            specularLevel = floor(specularLevel * celLevel) / (celLevel - 0.5);
        }
            
        //float diffuseLevel = normalDotLight;
        vec3 diffuseComponent = diffuseLevel * diffuseColour.rgb * lightColour;
        vec3 specularComponent = specularLevel * specGlossColour.rgb * lightColour;
        colourFromLights += diffuseComponent;
        colourFromLights += specularComponent;
    //}
    
    gl_FragColor = vec4(ambientColour + colourFromLights, diffuseColour.a);

}
