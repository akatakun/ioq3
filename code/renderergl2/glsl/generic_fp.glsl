uniform sampler2D u_DiffuseMap;

#if defined(USE_LIGHTMAP)
uniform sampler2D u_LightMap;

uniform int       u_Texture1Env;
#endif

#if defined(USE_RGBAGEN)
uniform int       u_AlphaTest;
#endif

varying vec2      var_DiffuseTex;

#if defined(USE_LIGHTMAP)
varying vec2      var_LightTex;
#endif

varying vec4      var_Color;


void main()
{
	vec4 color  = texture2D(u_DiffuseMap, var_DiffuseTex);
#if defined(USE_LIGHTMAP)
	vec4 color2 = texture2D(u_LightMap, var_LightTex);
  #if defined(RGBM_LIGHTMAP)
	color2.rgb *= 32.0 * color2.a;
	color2.a = 1.0;
  #endif

	if (u_Texture1Env == TEXENV_MODULATE)
	{
		color *= color2;
	}
	else if (u_Texture1Env == TEXENV_ADD)
	{
		color += color2;
	}
	else if (u_Texture1Env == TEXENV_REPLACE)
	{
		color = color2;
	}
	
	//color = color * (u_Texture1Env.xxxx + color2 * u_Texture1Env.z) + color2 * u_Texture1Env.y;
#endif

	gl_FragColor = color * var_Color;

#if defined(USE_RGBAGEN)
	if ((u_AlphaTest == ATEST_GT_0 && gl_FragColor.a <= 0.0) ||
	    (u_AlphaTest == ATEST_LT_80 && gl_FragColor.a >= 0.5) ||
	    (u_AlphaTest == ATEST_GE_80 && gl_FragColor.a < 0.5))
	{
		discard;
	}
#endif
}
