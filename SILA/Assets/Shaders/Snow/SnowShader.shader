// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SnowShader"
{
	Properties
	{
		_PositionPlayer("Position Player", Vector) = (0,0,0,0)
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 2
		_TessMaxDisp( "Max Displacement", Float ) = 25
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.37
		_Hardness("Hardness", Float) = 0
		_distanceGlitter("distance Glitter", Float) = 0
		_SnowHeight("Snow Height", Range( 0 , 1)) = 0
		_BiasDistance("BiasDistance", Float) = 0
		_ToonRamp2("ToonRamp2", 2D) = "white" {}
		_UVControlScreenMask("UV Control Screen Mask", Vector) = (0,0,0,0)
		_RenderTexture("RenderTexture", 2D) = "white" {}
		_GlitterMask("GlitterMask", 2D) = "white" {}
		_ToonRampTint("ToonRamp Tint", Color) = (0,0,0,0)
		_NormalDerivativeOffset("Normal Derivative Offset", Range( 0 , 1)) = 0
		_NormalScale("Normal Scale", Float) = 0
		_Debug_Height("Debug_Height", Float) = 0
		_LightInfluence("Light Influence", Range( 0 , 1)) = 0
		[HDR]_GlitterInt("Glitter Int", Color) = (1,1,1,0)
		[HDR]_SnowEmissive("Snow Emissive", Color) = (0,0,0,0)
		_CaptureSize("CaptureSize", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#pragma addshadow
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float4 screenPos;
			float3 worldNormal;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _RenderTexture;
		uniform float2 _PositionPlayer;
		uniform float _CaptureSize;
		uniform float _SnowHeight;
		uniform float _Debug_Height;
		uniform float _NormalDerivativeOffset;
		uniform float _NormalScale;
		uniform sampler2D _GlitterMask;
		uniform float4 _GlitterMask_ST;
		uniform float4 _UVControlScreenMask;
		uniform float _Hardness;
		uniform float _distanceGlitter;
		uniform float _BiasDistance;
		uniform float4 _GlitterInt;
		uniform sampler2D _ToonRamp2;
		uniform float4 _ToonRampTint;
		uniform float _LightInfluence;
		uniform float4 _SnowEmissive;
		uniform float _EdgeLength;
		uniform float _TessMaxDisp;
		uniform float _TessPhongStrength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTessCull (v0.vertex, v1.vertex, v2.vertex, _EdgeLength , _TessMaxDisp );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult425 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_429_0 = ( ( ( appendResult425 + _PositionPlayer ) + ( _CaptureSize / 2.0 ) ) / _CaptureSize );
			float4 tex2DNode394 = tex2Dlod( _RenderTexture, float4( temp_output_429_0, 0, 0.0) );
			float3 appendResult24 = (float3(0.0 , 0.0 , ( ( 1.0 - tex2DNode394.r ) * ( _SnowHeight + 0.1 ) )));
			v.vertex.xyz += ( appendResult24 * _Debug_Height );
			float temp_output_355_0 = (0.0 + (_NormalDerivativeOffset - 0.0) * (1.0 - 0.0) / (1.0 - 0.0));
			float2 appendResult356 = (float2(temp_output_355_0 , 0.0));
			float2 appendResult357 = (float2(0.0 , temp_output_355_0));
			float2 appendResult363 = (float2(tex2Dlod( _RenderTexture, float4( ( temp_output_429_0 - appendResult356 ), 0, 0.0) ).r , tex2Dlod( _RenderTexture, float4( ( temp_output_429_0 - appendResult357 ), 0, 0.0) ).r));
			float2 temp_cast_0 = (tex2DNode394.r).xx;
			float2 break367 = ( ( appendResult363 - temp_cast_0 ) * _NormalScale );
			float3 appendResult374 = (float3(break367.x , break367.y , sqrt( ( 1.0 - saturate( ( ( break367.x * break367.x ) + ( break367.y * break367.y ) ) ) ) )));
			v.normal = appendResult374;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_worldNormal = i.worldNormal;
			float dotResult436 = dot( ase_worldlightDir , ase_worldNormal );
			float2 appendResult443 = (float2(( ( ( 1.0 + dotResult436 ) / 2.0 ) * ase_lightAtten ) , 0.0));
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 temp_output_446_0 = ( ( tex2D( _ToonRamp2, appendResult443 ) * _ToonRampTint ) * ( ( 1.0 - _LightInfluence ) + ( ase_lightColor * _LightInfluence ) ) );
			float2 uv_GlitterMask = i.uv_texcoord * _GlitterMask_ST.xy + _GlitterMask_ST.zw;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 appendResult449 = (float2(ase_screenPosNorm.x , ase_screenPosNorm.y));
			float2 appendResult450 = (float2(_UVControlScreenMask.x , _UVControlScreenMask.y));
			float2 appendResult453 = (float2(_UVControlScreenMask.z , _UVControlScreenMask.w));
			float smoothstepResult467 = smoothstep( _distanceGlitter , ( _distanceGlitter + _BiasDistance ) , distance( ase_worldPos , _WorldSpaceCameraPos ));
			float4 temp_output_478_0 = ( ( saturate( ( ( ( 1.0 - step( tex2D( _GlitterMask, uv_GlitterMask ).r , 0.84 ) ) * ( 1.0 - step( tex2D( _GlitterMask, ( ( ( appendResult449 / ase_screenPosNorm.w ) * appendResult450 ) + appendResult453 ) ).r , 0.84 ) ) ) / _Hardness ) ) * ( 1.0 - smoothstepResult467 ) ) * _GlitterInt );
			c.rgb = ( temp_output_446_0 + temp_output_478_0 ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float2 uv_GlitterMask = i.uv_texcoord * _GlitterMask_ST.xy + _GlitterMask_ST.zw;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 appendResult449 = (float2(ase_screenPosNorm.x , ase_screenPosNorm.y));
			float2 appendResult450 = (float2(_UVControlScreenMask.x , _UVControlScreenMask.y));
			float2 appendResult453 = (float2(_UVControlScreenMask.z , _UVControlScreenMask.w));
			float3 ase_worldPos = i.worldPos;
			float smoothstepResult467 = smoothstep( _distanceGlitter , ( _distanceGlitter + _BiasDistance ) , distance( ase_worldPos , _WorldSpaceCameraPos ));
			float4 temp_output_478_0 = ( ( saturate( ( ( ( 1.0 - step( tex2D( _GlitterMask, uv_GlitterMask ).r , 0.84 ) ) * ( 1.0 - step( tex2D( _GlitterMask, ( ( ( appendResult449 / ase_screenPosNorm.w ) * appendResult450 ) + appendResult453 ) ).r , 0.84 ) ) ) / _Hardness ) ) * ( 1.0 - smoothstepResult467 ) ) * _GlitterInt );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_worldNormal = i.worldNormal;
			float dotResult436 = dot( ase_worldlightDir , ase_worldNormal );
			float2 appendResult443 = (float2(( ( ( 1.0 + dotResult436 ) / 2.0 ) * 1 ) , 0.0));
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 temp_output_446_0 = ( ( tex2D( _ToonRamp2, appendResult443 ) * _ToonRampTint ) * ( ( 1.0 - _LightInfluence ) + ( ase_lightColor * _LightInfluence ) ) );
			o.Emission = ( temp_output_478_0 + ( temp_output_446_0 * _SnowEmissive ) ).rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
425;73;1054;604;-74.2741;-938.195;1.597025;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;424;-7048.314,3103.638;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;425;-6801.626,3120.888;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;49;-6900.229,3303.901;Inherit;False;Property;_PositionPlayer;Position Player;1;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;428;-6614.352,3348.305;Inherit;False;Property;_CaptureSize;CaptureSize;28;0;Create;True;0;0;False;0;0;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;354;-7002.853,1323.786;Inherit;False;Property;_NormalDerivativeOffset;Normal Derivative Offset;22;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;431;-6526.501,3128.315;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;427;-6401.625,3221.377;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;447;-2250.203,4491.75;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;426;-6255.701,3104.17;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;355;-6665.66,1333.056;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;448;-1860.393,4793.412;Inherit;False;Property;_UVControlScreenMask;UV Control Screen Mask;13;0;Create;True;0;0;False;0;0,0,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;449;-2050.615,4520.472;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;356;-6372.246,1261.197;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;429;-6052.45,3175.243;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;357;-6367.664,1428.249;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;359;-6178.335,1430.819;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;451;-1885.836,4567.857;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;358;-6177.848,1260.736;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-7121.387,2859.726;Inherit;True;Property;_RenderTexture;RenderTexture;14;0;Create;True;0;0;False;0;None;9b8ae007f3a4a3e40b310c38adf70137;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DynamicAppendNode;450;-1614.323,4661.62;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;361;-5959.687,1438.781;Inherit;True;Property;_TextureSample2;Texture Sample 2;18;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;360;-5953.114,1228.642;Inherit;True;Property;_TextureSample1;Texture Sample 1;17;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;452;-1427.323,4603.62;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;434;-1349.124,-105.2806;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;435;-1360,-288;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;453;-1497.323,4903.62;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;363;-5607.435,1371.777;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;394;-5830.67,2811.191;Inherit;True;Property;_TextureSample4;Texture Sample 4;19;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;454;-1311.323,4765.62;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;455;-1466.867,4318.979;Inherit;True;Property;_GlitterMask;GlitterMask;15;0;Create;True;0;0;False;0;None;1686cf316c886694c9a59b1a8c0563f3;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DotProductOpNode;436;-1024,-224;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;437;-1072,-384;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;438;-832,-336;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;439;-816,-448;Inherit;False;Constant;_Float2;Float 2;8;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;366;-5453.072,1086.427;Inherit;False;Property;_NormalScale;Normal Scale;23;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;364;-5417.687,1368.48;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;456;-1077.213,4540.11;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;460;-1073.839,4269.217;Inherit;True;Property;_Mask_Glitter;Mask_Glitter;6;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;440;-608,-400;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;441;-720,-224;Inherit;True;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;487;-746.7266,4332.64;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.84;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;365;-5241.172,1130.625;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;485;-768.7266,4521.64;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.84;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;442;-416,-304;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;459;-1019.335,4890.359;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;457;-714.7974,5342.066;Inherit;False;Property;_BiasDistance;BiasDistance;10;0;Create;True;0;0;False;0;0;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;488;-608.7266,4377.64;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;458;-1101.35,5085.295;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;367;-5095.572,1225.527;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.OneMinusNode;486;-578.7266,4478.64;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;461;-740.2713,5202.009;Inherit;False;Property;_distanceGlitter;distance Glitter;8;0;Create;True;0;0;False;0;0;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;462;-461.2505,4396.945;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;444;-31.74495,185.052;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.DistanceOpNode;463;-804.1923,4946.224;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;465;-447.3911,5211.693;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;443;-128,-384;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;369;-4867.472,1498.622;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;464;-493.221,4538.25;Inherit;False;Property;_Hardness;Hardness;7;0;Create;True;0;0;False;0;0;0.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;474;-38.72073,428.8953;Inherit;False;Property;_LightInfluence;Light Influence;25;0;Create;True;0;0;False;0;0;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;368;-4805.572,1308.726;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;370;-4688.658,1422.549;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;473;216.3389,158.7484;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;347;-3.997557,-125.771;Inherit;False;Property;_ToonRampTint;ToonRamp Tint;20;0;Create;True;0;0;False;0;0,0,0,0;0.6705883,0.7607843,0.8235294,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;445;48,-448;Inherit;True;Property;_ToonRamp2;ToonRamp2;12;0;Create;True;0;0;False;0;-1;cadf74cfecacb6f48b4b21ae23815668;ea8738c3ec6ed684188ae5136f811377;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;36;-5644.293,3042.562;Inherit;False;Property;_SnowHeight;Snow Height;9;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;466;-305.3954,4438.784;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;467;-268.2715,4946.009;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;475;286.9579,307.4753;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;477;419.7027,-325.2689;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;476;429.4888,192.1694;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;469;-45.39096,4823.693;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;468;-137.7439,4444.587;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;30;-5388.292,2786.563;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;371;-4557.581,1501.609;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-5260.293,3042.562;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;372;-4407.832,1401.318;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-5004.294,2914.562;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;492;880.8654,1460.691;Inherit;False;Property;_SnowEmissive;Snow Emissive;27;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;446;506.9823,57.33267;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;480;159.5525,3861.076;Inherit;False;Property;_GlitterInt;Glitter Int;26;1;[HDR];Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;470;326.7578,4295.509;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;433;-4213.644,2951.104;Inherit;False;Property;_Debug_Height;Debug_Height;24;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;133;-1562.038,629.64;Inherit;False;953.9445;475.1312;Comment;5;137;135;136;376;134;N.L;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;478;473.0968,3782.69;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SqrtOpNode;373;-4230.605,1380.708;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-4748.294,2914.562;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;490;1144.027,1383.338;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;352;-1754.617,1270.857;Inherit;False;2035.682;560.9133;Comment;12;329;330;337;321;322;302;328;297;304;298;379;315;Glitter;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;182;-2370.407,3661.44;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LightColorNode;220;-1707.455,2838.236;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SaturateNode;137;-792.7621,774.7207;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;315;-1713.406,1529.165;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;163;-2176.475,2428.311;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;177;492.6093,2194.452;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;166;-1310.679,2320.639;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;304;-1263.58,1647.771;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;225;-2630.446,1405.807;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;135;-1020.271,771.416;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;221;-1149.854,2838.236;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;229;-2892.403,1506.905;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;346;778.7257,978.7869;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;227;-2519.432,1634.106;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;136;-1417.493,931.7491;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;345;430.4566,743.6326;Inherit;True;Property;_ToonRamp;ToonRamp;19;0;Create;True;0;0;False;0;-1;None;ea8738c3ec6ed684188ae5136f811377;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;230;-3195.612,1607.605;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;134;-1410.793,686.8013;Inherit;True;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;-785.6646,3429.589;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;228;-2714.548,1698.869;Float;False;Property;_Noise_Strength;Noise_Strength;11;0;Create;True;0;0;False;0;0;0.91;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;178;304.3008,2373.38;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;194;-550.2437,3419.57;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;180;-2125.1,3313.924;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;489;1437.677,1524.84;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;232;-2706.196,1536.571;Inherit;False;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;162;-2285.693,2247.12;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;219;-1309.854,2950.236;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;170;-1069.524,2472.011;Inherit;False;Property;_RimStrenght;RimStrenght;29;0;Create;True;0;0;False;0;0.27;0.48;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;379;-1524.349,1504.157;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;329;112.0655,1497.724;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;217;-1753.538,2975.628;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;192;-984.4307,3578.332;Inherit;False;Property;_SpecularStrenght;SpecularStrenght;18;0;Create;True;0;0;False;0;0;0.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;191;-1212.171,3579.457;Inherit;False;Property;_SpecularPower;SpecularPower;21;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;322;-614.7195,1630.51;Inherit;False;Property;_Glitter_Threshold;Glitter_Threshold;16;0;Create;True;0;0;False;0;0;0.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;189;-1009.665,3397.589;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;181;-2324.017,3506.815;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;374;-3927.014,1237.106;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;171;-732.1641,2368.664;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;432;-4003.681,2806.634;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;218;-1540.28,2923.231;Inherit;False;Tangent;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;302;-808.3046,1496.766;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;321;-314.7681,1483.98;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;298;-1556.64,1320.857;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMaxOpNode;186;-1578.685,3418.064;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;-883.0883,2370.54;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ReflectOpNode;297;-1223.863,1493.316;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;168;-1311.711,2435.472;Inherit;False;Property;_RimPower;RimPower;30;0;Create;True;0;0;False;0;13;8.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;164;-1983.788,2337.819;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;328;-1012.605,1651.677;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;167;-1107.088,2338.54;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;188;-1714.758,3444.446;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;173;-557.4971,2369.449;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;184;-1944.056,3575.243;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;258;-1604.33,2338.966;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;226;-2326.783,1527.607;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendNormalsNode;376;-1173.406,670.2157;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;377;-1889.193,3336.682;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;231;-3162.409,1430.906;Float;False;Property;_NoiseSize;Noise Size;0;0;Create;True;0;0;False;0;0,0;10000,10000;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;-389.2899,2367.311;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;185;-2091,3573.628;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;176;729.4958,1635.509;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;330;-126.3669,1587.281;Inherit;False;Property;_GlitterIntensity;Glitter Intensity;17;0;Create;True;0;0;False;0;0;2.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;337;-108.5068,1483.036;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1584.62,1459.856;Float;False;True;-1;6;ASEMaterialInspector;0;0;CustomLighting;SnowShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;3;2;10;25;True;0.37;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;2;0;False;0;0;False;-1;-1;0;False;-1;1;Pragma;addshadow;False;;Custom;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;349;-1262.171,3347.589;Inherit;False;926.609;359.417;Comment;0;Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;241;-3245.611,1355.808;Inherit;False;1062.447;468.6189;Comment;0;Noise Generator;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;183;-2438.165,3228.995;Inherit;False;979.6659;587.2239;Comment;0;N.H;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;348;-1654.33,2270.639;Inherit;False;1451.713;313.418;Comment;0;Rim Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;161;-2333.693,2199.12;Inherit;False;507.201;385.7996;Comment;0;N . V;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;216;-1805.855,2790.237;Inherit;False;812;304;Comment;0;Attenuation and Ambient;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;353;380.4566,693.6326;Inherit;False;567.269;552.9442;Comment;0;ToonRamp;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;378;-7052.853,1036.427;Inherit;False;3360.838;632.3541;Comment;0;Partial Derivative Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;116;-7228.294,2738.563;Inherit;False;3007;698.6722;Comment;0;Vertex OffSet;1,0.6687182,0,1;0;0
WireConnection;425;0;424;1
WireConnection;425;1;424;3
WireConnection;431;0;425;0
WireConnection;431;1;49;0
WireConnection;427;0;428;0
WireConnection;426;0;431;0
WireConnection;426;1;427;0
WireConnection;355;0;354;0
WireConnection;449;0;447;1
WireConnection;449;1;447;2
WireConnection;356;0;355;0
WireConnection;429;0;426;0
WireConnection;429;1;428;0
WireConnection;357;1;355;0
WireConnection;359;0;429;0
WireConnection;359;1;357;0
WireConnection;451;0;449;0
WireConnection;451;1;447;4
WireConnection;358;0;429;0
WireConnection;358;1;356;0
WireConnection;450;0;448;1
WireConnection;450;1;448;2
WireConnection;361;0;3;0
WireConnection;361;1;359;0
WireConnection;360;0;3;0
WireConnection;360;1;358;0
WireConnection;452;0;451;0
WireConnection;452;1;450;0
WireConnection;453;0;448;3
WireConnection;453;1;448;4
WireConnection;363;0;360;1
WireConnection;363;1;361;1
WireConnection;394;0;3;0
WireConnection;394;1;429;0
WireConnection;454;0;452;0
WireConnection;454;1;453;0
WireConnection;436;0;435;0
WireConnection;436;1;434;0
WireConnection;438;0;437;0
WireConnection;438;1;436;0
WireConnection;364;0;363;0
WireConnection;364;1;394;1
WireConnection;456;0;455;0
WireConnection;456;1;454;0
WireConnection;460;0;455;0
WireConnection;440;0;438;0
WireConnection;440;1;439;0
WireConnection;487;0;460;1
WireConnection;365;0;364;0
WireConnection;365;1;366;0
WireConnection;485;0;456;1
WireConnection;442;0;440;0
WireConnection;442;1;441;0
WireConnection;488;0;487;0
WireConnection;367;0;365;0
WireConnection;486;0;485;0
WireConnection;462;0;488;0
WireConnection;462;1;486;0
WireConnection;463;0;459;0
WireConnection;463;1;458;0
WireConnection;465;0;461;0
WireConnection;465;1;457;0
WireConnection;443;0;442;0
WireConnection;369;0;367;1
WireConnection;369;1;367;1
WireConnection;368;0;367;0
WireConnection;368;1;367;0
WireConnection;370;0;368;0
WireConnection;370;1;369;0
WireConnection;473;0;444;0
WireConnection;473;1;474;0
WireConnection;445;1;443;0
WireConnection;466;0;462;0
WireConnection;466;1;464;0
WireConnection;467;0;463;0
WireConnection;467;1;461;0
WireConnection;467;2;465;0
WireConnection;475;0;474;0
WireConnection;477;0;445;0
WireConnection;477;1;347;0
WireConnection;476;0;475;0
WireConnection;476;1;473;0
WireConnection;469;0;467;0
WireConnection;468;0;466;0
WireConnection;30;0;394;1
WireConnection;371;0;370;0
WireConnection;73;0;36;0
WireConnection;372;0;371;0
WireConnection;35;0;30;0
WireConnection;35;1;73;0
WireConnection;446;0;477;0
WireConnection;446;1;476;0
WireConnection;470;0;468;0
WireConnection;470;1;469;0
WireConnection;478;0;470;0
WireConnection;478;1;480;0
WireConnection;373;0;372;0
WireConnection;24;2;35;0
WireConnection;490;0;446;0
WireConnection;490;1;492;0
WireConnection;137;0;135;0
WireConnection;315;0;226;0
WireConnection;177;0;178;0
WireConnection;166;0;258;0
WireConnection;135;0;376;0
WireConnection;135;1;136;0
WireConnection;221;0;220;0
WireConnection;221;1;219;0
WireConnection;229;0;231;0
WireConnection;229;1;230;0
WireConnection;346;0;345;0
WireConnection;346;1;347;0
WireConnection;227;0;232;0
WireConnection;227;1;228;0
WireConnection;345;1;137;0
WireConnection;190;0;189;0
WireConnection;190;1;192;0
WireConnection;178;0;175;0
WireConnection;178;1;194;0
WireConnection;194;0;221;0
WireConnection;194;1;190;0
WireConnection;489;0;478;0
WireConnection;489;1;490;0
WireConnection;232;0;229;0
WireConnection;219;0;218;0
WireConnection;219;1;217;0
WireConnection;379;0;374;0
WireConnection;379;1;315;0
WireConnection;329;0;337;0
WireConnection;329;1;330;0
WireConnection;189;0;186;0
WireConnection;189;1;191;0
WireConnection;374;0;367;0
WireConnection;374;1;367;1
WireConnection;374;2;373;0
WireConnection;171;0;169;0
WireConnection;432;0;24;0
WireConnection;432;1;433;0
WireConnection;218;0;374;0
WireConnection;302;0;297;0
WireConnection;302;1;328;0
WireConnection;321;0;302;0
WireConnection;321;1;322;0
WireConnection;321;2;302;0
WireConnection;186;1;188;0
WireConnection;169;0;167;0
WireConnection;169;1;170;0
WireConnection;297;0;298;0
WireConnection;297;1;379;0
WireConnection;164;0;162;0
WireConnection;164;1;163;0
WireConnection;328;0;304;0
WireConnection;167;0;166;0
WireConnection;167;1;168;0
WireConnection;188;0;377;0
WireConnection;188;1;184;0
WireConnection;173;0;171;0
WireConnection;184;0;185;0
WireConnection;258;0;164;0
WireConnection;226;0;225;0
WireConnection;226;1;227;0
WireConnection;376;0;134;0
WireConnection;376;1;374;0
WireConnection;377;0;180;0
WireConnection;377;1;374;0
WireConnection;175;0;221;0
WireConnection;175;1;173;0
WireConnection;185;0;181;0
WireConnection;185;1;182;0
WireConnection;176;0;446;0
WireConnection;176;1;478;0
WireConnection;337;0;321;0
WireConnection;0;2;489;0
WireConnection;0;13;176;0
WireConnection;0;11;432;0
WireConnection;0;12;374;0
ASEEND*/
//CHKSM=0E7DE5519551413A3F85E6F65BE643AE1B709C02