// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/WaterSample"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 4
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
		_TextureSample5("Texture Sample 5", 2D) = "bump" {}
		_WaterNormal("Water Normal", 2D) = "bump" {}
		_NormalScale("Normal Scale", Float) = 0
		_NormalScaleDistort("Normal Scale Distort", Float) = 0
		_WaveSpeed("Wave Speed", Float) = 0
		_WaterSpecular("Water Specular", Range( 0 , 1)) = 0
		_Specular("Specular", Float) = 50
		_SpecularInt("Specular Int", Float) = 1
		_WaterSmoothness("Water Smoothness", Range( 0 , 1)) = 0
		_Distortion("Distortion", Float) = 0.5
		_Albedo("Albedo", 2D) = "white" {}
		[HDR]_IceColor("Ice Color", Color) = (0,2.682353,4,0)
		[NoScaleOffset]_IceParallax("Ice Parallax", 2D) = "white" {}
		[HDR]_Color1("Color 1", Color) = (0,0,0,0)
		_IceSpecular("Ice Specular", Range( 0 , 1)) = 0
		_IceSmoothness("Ice Smoothness", Range( 0 , 1)) = 0
		_Glaciation("Glaciation", Range( 0 , 1)) = 0
		_DepthTransparency("Depth Transparency", Float) = 0
		_Float0("Float 0", Range( 0 , 1)) = 0
		_IceNormal("Ice Normal", 2D) = "bump" {}
		_ToonRamp("Toon Ramp", 2D) = "white" {}
		_ToonRampTint("Toon Ramp Tint", Color) = (0,0,0,0)
		_Float1("Float 1", Range( 0 , 1)) = 0
		_WaterColor("Water Color", Color) = (0,0,0,0)
		_FoamDepth("Foam Depth", Float) = 0
		_WaterDistortionInt("Water Distortion Int", Range( 0 , 1)) = 0
		_FoamFalloff("Foam Falloff", Float) = 0
		_FoamColor("Foam Color", Color) = (0,0,0,0)
		_Vignette("Vignette", 2D) = "white" {}
		_HeightParallax("Height Parallax", Float) = 0
		_HeightParallax2("Height Parallax 2", Float) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf StandardSpecular keepalpha vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			half3 viewDir;
			INTERNAL_DATA
			float4 screenPos;
			half3 worldNormal;
			float3 worldPos;
		};

		uniform sampler2D _IceNormal;
		uniform half4 _IceNormal_ST;
		uniform sampler2D _WaterNormal;
		uniform float _NormalScaleDistort;
		uniform half _WaveSpeed;
		uniform float4 _WaterNormal_ST;
		uniform sampler2D _Vignette;
		uniform half4 _Vignette_ST;
		uniform half _Glaciation;
		uniform sampler2D _IceParallax;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform half _HeightParallax;
		uniform half _HeightParallax2;
		uniform half4 _Color1;
		uniform half4 _IceColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform half _DepthTransparency;
		uniform half _Float0;
		uniform half _Float1;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _Distortion;
		uniform half _WaterDistortionInt;
		uniform half4 _WaterColor;
		uniform sampler2D _ToonRamp;
		uniform half4 _ToonRampTint;
		uniform half _SpecularInt;
		uniform float _NormalScale;
		uniform sampler2D _TextureSample5;
		uniform half _Specular;
		uniform half4 _FoamColor;
		uniform half _FoamDepth;
		uniform half _FoamFalloff;
		uniform float _IceSpecular;
		uniform float _WaterSpecular;
		uniform float _IceSmoothness;
		uniform float _WaterSmoothness;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_IceNormal = i.uv_texcoord * _IceNormal_ST.xy + _IceNormal_ST.zw;
			half2 temp_cast_0 = (_WaveSpeed).xx;
			float2 uv0_WaterNormal = i.uv_texcoord * _WaterNormal_ST.xy + _WaterNormal_ST.zw;
			half2 panner22 = ( 0.5 * _Time.y * temp_cast_0 + uv0_WaterNormal);
			half2 temp_cast_1 = (_WaveSpeed).xx;
			half2 panner19 = ( 1.0 * _Time.y * temp_cast_1 + uv0_WaterNormal);
			half3 temp_output_24_0 = BlendNormals( UnpackScaleNormal( tex2D( _WaterNormal, panner22 ), _NormalScaleDistort ) , UnpackScaleNormal( tex2D( _WaterNormal, panner19 ), _NormalScaleDistort ) );
			float2 uv_Vignette = i.uv_texcoord * _Vignette_ST.xy + _Vignette_ST.zw;
			half clampResult259 = clamp( tex2D( _Vignette, uv_Vignette ).r , 0.0 , ( 1.0 - _Glaciation ) );
			half temp_output_336_0 = saturate( clampResult259 );
			half3 lerpResult181 = lerp( UnpackNormal( tex2D( _IceNormal, uv_IceNormal ) ) , temp_output_24_0 , temp_output_336_0);
			o.Normal = lerpResult181;
			float2 uv0_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			half2 Offset341 = ( ( 1.0 - 1 ) * i.viewDir.xy * 1.0 ) + uv0_Albedo;
			half2 Offset263 = ( ( _HeightParallax - 1 ) * ( i.viewDir.xy / i.viewDir.z ) * 1.0 ) + ( uv0_Albedo + half2( 0.25,0.25 ) );
			half2 Offset264 = ( ( _HeightParallax2 - 1 ) * ( i.viewDir.xy / i.viewDir.z ) * 1.0 ) + ( uv0_Albedo + half2( 0.75,0.75 ) );
			half4 temp_output_222_0 = ( ( ( saturate( ( tex2D( _IceParallax, Offset341 ).r + tex2D( _IceParallax, Offset263 ).r + tex2D( _IceParallax, Offset264 ).r ) ) * _Color1 ) + ( tex2D( _Albedo, uv0_Albedo ) * _IceColor ) ) + float4( 0,0,0,0 ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			half4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth244 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half distanceDepth244 = abs( ( screenDepth244 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthTransparency ) );
			half clampResult246 = clamp( distanceDepth244 , _Float0 , _Float1 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			half4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor65 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( half3( (ase_grabScreenPosNorm).xy ,  0.0 ) + ( temp_output_24_0 * _Distortion ) ).xy);
			half2 temp_cast_4 = (_WaveSpeed).xx;
			half2 panner303 = ( 0.5 * _Time.y * temp_cast_4 + uv0_WaterNormal);
			half2 temp_cast_5 = (_WaveSpeed).xx;
			half2 panner302 = ( 1.0 * _Time.y * temp_cast_5 + uv0_WaterNormal);
			half3 normalizeResult287 = normalize( (WorldNormalVector( i , BlendNormals( UnpackScaleNormal( tex2D( _WaterNormal, panner303 ), _NormalScale ) , UnpackScaleNormal( tex2D( _TextureSample5, panner302 ), _NormalScale ) ) )) );
			float3 ase_worldPos = i.worldPos;
			half3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			half3 ase_worldlightDir = 0;
			#else //aseld
			half3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			half3 normalizeResult286 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			half dotResult288 = dot( normalizeResult287 , normalizeResult286 );
			half clampResult290 = clamp( dotResult288 , 0.0 , 1.0 );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			half4 ase_lightColor = 0;
			#else //aselc
			half4 ase_lightColor = _LightColor0;
			#endif //aselc
			half eyeDepth314 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_grabScreenPosNorm.xy ));
			half4 lerpResult335 = lerp( ( ( screenColor65 * _WaterDistortionInt * _WaterColor ) + ( ( tex2D( _ToonRamp, panner19 ) * _ToonRampTint ) + half4( ( ( _SpecularInt * pow( clampResult290 , _Specular ) ) * ase_lightColor.rgb ) , 0.0 ) ) ) , _FoamColor , saturate( pow( ( abs( ( eyeDepth314 - ase_screenPos.w ) ) + _FoamDepth ) , _FoamFalloff ) ));
			half4 lerpResult338 = lerp( ( temp_output_222_0 + clampResult246 ) , lerpResult335 , temp_output_336_0);
			o.Albedo = lerpResult338.rgb;
			half lerpResult130 = lerp( _IceSpecular , _WaterSpecular , temp_output_336_0);
			half3 temp_cast_8 = (lerpResult130).xxx;
			o.Specular = temp_cast_8;
			half lerpResult133 = lerp( _IceSmoothness , _WaterSmoothness , temp_output_336_0);
			o.Smoothness = lerpResult133;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
202;73;1261;656;5525.777;4051.181;1.396505;True;False
Node;AmplifyShaderEditor.CommentaryNode;151;-4175.445,-1284.343;Inherit;False;1281.603;457.1994;Blend panning normals to fake noving ripples;8;19;23;24;21;22;17;48;167;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;299;-4738.579,232.0132;Inherit;False;1281.603;457.1994;Blend panning normals to fake noving ripples;7;307;306;305;304;303;302;301;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;301;-4688.579,309.3123;Inherit;False;0;17;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;167;-4116.553,-1005.637;Inherit;False;Property;_WaveSpeed;Wave Speed;9;0;Create;True;0;0;False;0;0;0.003;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;302;-4413.579,394.5123;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.04,0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;303;-4415.88,282.0132;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.03,0;False;1;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;307;-4359.979,519.1122;Float;False;Property;_NormalScale;Normal Scale;7;0;Create;True;0;0;False;0;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;305;-4058.977,500.2133;Inherit;True;Property;_TextureSample5;Texture Sample 5;5;0;Create;True;0;0;False;0;-1;None;7396d8283d9546a47b19041de42366c3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;281;-3013.878,248.9924;Inherit;False;1600.682;765.8125;Comment;12;293;292;291;290;289;288;287;286;285;284;283;282;Specular;1,0.1462264,0.8905144,1;0;0
Node;AmplifyShaderEditor.SamplerNode;304;-4071.878,290.3123;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;False;0;-1;None;None;True;0;True;bump;Auto;True;Instance;17;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;282;-2963.878,835.8063;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;283;-2934.3,657.9122;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-4125.445,-1207.044;Inherit;False;0;17;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;306;-3680.604,410.9423;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;343;-4856.85,-4199.209;Inherit;False;Constant;_Vector0;Vector 0;34;0;Create;True;0;0;False;0;0.25,0.25;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;272;-4921.53,-4350.472;Inherit;False;0;212;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;-3796.846,-997.2441;Float;False;Property;_NormalScaleDistort;Normal Scale Distort;8;0;Create;True;0;0;False;0;0;0.005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;345;-4834.507,-3410.185;Inherit;False;Constant;_Vector1;Vector 1;34;0;Create;True;0;0;False;0;0.75,0.75;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;285;-2701.036,768.0642;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;22;-3852.746,-1234.343;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.03,0;False;1;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;19;-3850.445,-1121.844;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.04,0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;284;-2836.226,411.2704;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;270;-4828.725,-3539.056;Inherit;False;Property;_HeightParallax2;Height Parallax 2;37;0;Create;True;0;0;False;0;0.5;0.98;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;267;-4819.542,-3927.199;Inherit;False;Constant;_Float2;Float 2;22;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;286;-2581.165,696.7893;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;268;-4835.054,-4041.481;Inherit;False;Property;_HeightParallax;Height Parallax;36;0;Create;True;0;0;False;0;0;0.99;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-3495.845,-1016.143;Inherit;True;Property;_WaterNormal;Water Normal;6;0;Create;True;0;0;False;0;-1;None;7396d8283d9546a47b19041de42366c3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;287;-2568.032,461.4283;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;265;-4844.922,-3800.647;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;150;-2270.976,-1001.342;Inherit;False;985.6011;418.6005;Get screen color for refraction and disturbe it with normals;7;96;97;98;65;149;164;165;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;23;-3508.746,-1226.044;Inherit;True;Property;_Normal2;Normal2;6;0;Create;True;0;0;False;0;-1;None;None;True;0;True;bump;Auto;True;Instance;17;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;342;-4545.43,-4204.795;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;344;-4414.16,-3785.845;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;288;-2374.556,573.3452;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;193;-4808.824,-4678.856;Inherit;True;Property;_IceParallax;Ice Parallax;18;1;[NoScaleOffset];Create;True;0;0;False;0;None;77b5ab2a32417dd4a88fd15902b3a59d;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ParallaxMappingNode;264;-4294.629,-3649.281;Inherit;False;Planar;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxMappingNode;341;-4270.322,-4302.024;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendNormalsNode;24;-3150.624,-1065.631;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GrabScreenPosition;164;-2226.869,-941.9843;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxMappingNode;263;-4315.044,-4002.499;Inherit;False;Planar;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenDepthNode;314;-1282.009,-2080.452;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;313;-1541.622,-1896.955;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;261;-3788.286,-3996.372;Inherit;True;Property;_TextureSample3;Texture Sample 3;23;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;289;-2181.678,754.2733;Inherit;False;Property;_Specular;Specular;11;0;Create;True;0;0;False;0;50;66.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;149;-2250.677,-688.4409;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;262;-3806.661,-3659.49;Inherit;True;Property;_TextureSample4;Texture Sample 4;24;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;290;-2210.672,520.3803;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;260;-3788.285,-4318.963;Inherit;True;Property;_TextureSample2;Texture Sample 2;22;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;97;-2028.076,-702.7418;Float;False;Property;_Distortion;Distortion;14;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-1849.975,-779.3419;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;165;-1923.522,-884.8502;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;271;-3168.805,-4305.427;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;291;-1858.511,327.6014;Inherit;False;Property;_SpecularInt;Specular Int;12;0;Create;True;0;0;False;0;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;292;-1852.118,455.5564;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;315;-974.8225,-2008.413;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;214;-1557.152,-3959.16;Inherit;False;Property;_Color1;Color 1;19;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.3570065,0.5737604,0.8117648,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;212;-2499.775,-4635.896;Inherit;True;Property;_Albedo;Albedo;15;0;Create;True;0;0;False;0;-1;None;732858e138af22f4b8954569440f82b9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;293;-1608.944,305.5444;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;280;-1420.14,-47.54319;Inherit;False;Property;_ToonRampTint;Toon Ramp Tint;28;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;96;-1696.876,-846.2421;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;276;-1671.685,-317.5851;Inherit;True;Property;_ToonRamp;Toon Ramp;27;0;Create;True;0;0;False;0;-1;None;ea8738c3ec6ed684188ae5136f811377;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;317;-800.9974,-2006.804;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;320;-754.2337,-1881.749;Inherit;False;Property;_FoamDepth;Foam Depth;31;0;Create;True;0;0;False;0;0;-1.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;294;-1365.919,435.0583;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;213;-2403.775,-4379.896;Inherit;False;Property;_IceColor;Ice Color;17;1;[HDR];Create;True;0;0;False;0;0,2.682353,4,0;4,4,4,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;211;-2547.775,-4027.896;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;321;-453.4246,-1867.252;Inherit;False;Property;_FoamFalloff;Foam Falloff;33;0;Create;True;0;0;False;0;0;-0.78;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;65;-1511.899,-836.9934;Float;False;Global;_WaterGrab;WaterGrab;-1;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;218;-1654.694,-4635.856;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;318;-491.4784,-2006.784;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;245;-1007.962,-3555.68;Inherit;False;Property;_DepthTransparency;Depth Transparency;24;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;226;-932.4536,1525.408;Inherit;False;Property;_Glaciation;Glaciation;23;0;Create;False;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;295;-1329.063,250.7803;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;298;-1300.017,-729.646;Inherit;False;Property;_WaterDistortionInt;Water Distortion Int;32;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;309;-1368.327,-611.3779;Inherit;False;Property;_WaterColor;Water Color;30;0;Create;True;0;0;False;0;0,0,0,0;0.1308295,0.1948718,0.7924528,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;219;-1305.747,-4188.704;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;278;-1084.412,-381.5083;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;221;-774.2805,-4218.703;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;253;-443.1987,-3307.251;Inherit;False;Property;_Float1;Float 1;29;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;319;-248.6574,-1988.663;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;274;100.4995,1301.252;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;297;-1027.866,-840.3235;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;296;-641.28,-450.1678;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;244;-703.5444,-3580.508;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;258;6.024719,759.0924;Inherit;True;Property;_Vignette;Vignette;35;0;Create;True;0;0;False;0;-1;None;d4ef717bdd61a1b4bb34a8626107aefe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;251;-427.0464,-3432.063;Inherit;False;Property;_Float0;Float 0;25;0;Create;True;0;0;False;0;0;0.788;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;323;-27.58144,-1974.166;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;277;-726.5443,-857.7704;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;222;-369.5121,-4299.476;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;259;643.6525,817.5399;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;333;609.2841,-1178;Inherit;False;Property;_FoamColor;Foam Color;34;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;246;-85.19934,-3581.367;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;1219.234,293.6367;Float;False;Property;_IceSmoothness;Ice Smoothness;21;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;275;1019.839,-815.1949;Inherit;True;Property;_IceNormal;Ice Normal;26;0;Create;True;0;0;False;0;-1;None;cd93b77a2b8fe68489720b1c3bb3b3e1;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;257;317.3427,-3530.927;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;335;1000.018,-1377.281;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;131;1061.033,25.9361;Float;False;Property;_IceSpecular;Ice Specular;20;0;Create;True;0;0;False;0;0;0.651;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;1058.833,-72.36517;Float;False;Property;_WaterSpecular;Water Specular;10;0;Create;True;0;0;False;0;0;0.377;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;336;759.944,417.991;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;1225.032,213.9312;Float;False;Property;_WaterSmoothness;Water Smoothness;13;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;231;-1977.974,-3177.75;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;133;1618.021,317.2888;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;168;-438.8938,1252.892;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;233;-1675.472,-3158.405;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;229;-655.0575,1269.512;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;181;1422.758,-635.0784;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;312;-1548.379,-2094.188;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;232;-1410.358,-3155.617;Inherit;False;Global;_GrabScreen0;Grab Screen 0;18;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;130;1399.96,18.09989;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;171;-155.6092,1267.445;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;236;-1038,-3426.146;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;237;-1482.745,-3359.205;Inherit;False;Property;_IceTransparency;Ice Transparency;22;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;108;-371.551,-2737.206;Float;False;Constant;_Color0;Color 0;-1;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;243;276.6246,-3824.867;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;338;1609.103,-1079.156;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;169;-872.4147,1293.15;Inherit;False;Property;_Dist;Dist;16;0;Create;True;0;0;False;0;1500;650;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2377.013,-788.6786;Half;False;True;-1;6;ASEMaterialInspector;0;0;StandardSpecular;Custom/WaterSample;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Translucent;0.5;True;False;0;False;Opaque;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;174;-2406.737,-1235.138;Inherit;False;100;100;Comment;0;Water Material;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;175;-2313.285,-3301.952;Inherit;False;100;100;Comment;0;Ice Material;1,1,1,1;0;0
WireConnection;302;0;301;0
WireConnection;302;2;167;0
WireConnection;303;0;301;0
WireConnection;303;2;167;0
WireConnection;305;1;302;0
WireConnection;305;5;307;0
WireConnection;304;1;303;0
WireConnection;304;5;307;0
WireConnection;306;0;304;0
WireConnection;306;1;305;0
WireConnection;285;0;283;0
WireConnection;285;1;282;0
WireConnection;22;0;21;0
WireConnection;22;2;167;0
WireConnection;19;0;21;0
WireConnection;19;2;167;0
WireConnection;284;0;306;0
WireConnection;286;0;285;0
WireConnection;17;1;19;0
WireConnection;17;5;48;0
WireConnection;287;0;284;0
WireConnection;23;1;22;0
WireConnection;23;5;48;0
WireConnection;342;0;272;0
WireConnection;342;1;343;0
WireConnection;344;0;272;0
WireConnection;344;1;345;0
WireConnection;288;0;287;0
WireConnection;288;1;286;0
WireConnection;264;0;344;0
WireConnection;264;1;270;0
WireConnection;264;2;267;0
WireConnection;264;3;265;0
WireConnection;341;0;272;0
WireConnection;341;3;265;0
WireConnection;24;0;23;0
WireConnection;24;1;17;0
WireConnection;263;0;342;0
WireConnection;263;1;268;0
WireConnection;263;2;267;0
WireConnection;263;3;265;0
WireConnection;314;0;164;0
WireConnection;261;0;193;0
WireConnection;261;1;263;0
WireConnection;149;0;24;0
WireConnection;262;0;193;0
WireConnection;262;1;264;0
WireConnection;290;0;288;0
WireConnection;260;0;193;0
WireConnection;260;1;341;0
WireConnection;98;0;149;0
WireConnection;98;1;97;0
WireConnection;165;0;164;0
WireConnection;271;0;260;1
WireConnection;271;1;261;1
WireConnection;271;2;262;1
WireConnection;292;0;290;0
WireConnection;292;1;289;0
WireConnection;315;0;314;0
WireConnection;315;1;313;4
WireConnection;212;1;272;0
WireConnection;293;0;291;0
WireConnection;293;1;292;0
WireConnection;96;0;165;0
WireConnection;96;1;98;0
WireConnection;276;1;19;0
WireConnection;317;0;315;0
WireConnection;211;0;271;0
WireConnection;65;0;96;0
WireConnection;218;0;212;0
WireConnection;218;1;213;0
WireConnection;318;0;317;0
WireConnection;318;1;320;0
WireConnection;295;0;293;0
WireConnection;295;1;294;1
WireConnection;219;0;211;0
WireConnection;219;1;214;0
WireConnection;278;0;276;0
WireConnection;278;1;280;0
WireConnection;221;0;219;0
WireConnection;221;1;218;0
WireConnection;319;0;318;0
WireConnection;319;1;321;0
WireConnection;274;0;226;0
WireConnection;297;0;65;0
WireConnection;297;1;298;0
WireConnection;297;2;309;0
WireConnection;296;0;278;0
WireConnection;296;1;295;0
WireConnection;244;0;245;0
WireConnection;323;0;319;0
WireConnection;277;0;297;0
WireConnection;277;1;296;0
WireConnection;222;0;221;0
WireConnection;259;0;258;1
WireConnection;259;2;274;0
WireConnection;246;0;244;0
WireConnection;246;1;251;0
WireConnection;246;2;253;0
WireConnection;257;0;222;0
WireConnection;257;1;246;0
WireConnection;335;0;277;0
WireConnection;335;1;333;0
WireConnection;335;2;323;0
WireConnection;336;0;259;0
WireConnection;133;0;132;0
WireConnection;133;1;26;0
WireConnection;133;2;336;0
WireConnection;168;0;229;0
WireConnection;233;0;231;0
WireConnection;229;0;169;0
WireConnection;229;1;226;0
WireConnection;181;0;275;0
WireConnection;181;1;24;0
WireConnection;181;2;336;0
WireConnection;232;0;233;0
WireConnection;130;0;131;0
WireConnection;130;1;104;0
WireConnection;130;2;336;0
WireConnection;171;0;168;0
WireConnection;236;0;232;0
WireConnection;236;1;237;0
WireConnection;243;0;222;0
WireConnection;243;1;246;0
WireConnection;338;0;257;0
WireConnection;338;1;335;0
WireConnection;338;2;336;0
WireConnection;0;0;338;0
WireConnection;0;1;181;0
WireConnection;0;3;130;0
WireConnection;0;4;133;0
ASEEND*/
//CHKSM=5A9C7939862CDB81D197873ACBB1E1F0A17BA8BB