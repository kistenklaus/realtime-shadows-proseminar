
float ShadowCalculation(vec4 fragPosLightSpace)
{
    // perform perspective divide
    vec3 projCoords = fragPosLightSpace.xyz / fragPosLightSpace.w;
    // transform to [0,1] range
    projCoords = projCoords * 0.5 + 0.5;
    // get depth of current fragment from light's perspective
    float currentDepth = projCoords.z;
    // transform from uv to texel space.
    ivec2 shadowTexel = projCoords.xy * vec2(shadowMapWidth, shadowMapHeight);
    // perform pcf filtering.
    float shadow = 0;
    for(int x=-1;x<=1;x++){
      for(int y=-1;y<=1;y++){
        // get closest depth value from light's perspective 
        float closestDepth = get_texel(shadowMap, shadowTexel + ivec2(x,y)).r; 
        // check whether current frag pos is in shadow
        if(currentDepth < closestDepth + BIAS){
          shadow += 1;
        }
      }
    }
    shadow /= 9;
    return shadow;
}  


