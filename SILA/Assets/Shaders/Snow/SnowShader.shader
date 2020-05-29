// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/SnowShader"
{
	Properties
	{
		_PositionPlayer("Position Player", Vector) = (0,0,0,0)
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 2
		_TessMaxDisp( "Max Displacement", Float ) = 25
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.37
		_SnowHeight("Snow Height", Range( 0 , 1)) = 0
		_ToonRamp2("ToonRamp2", 2D) = "white" {}
		_RenderTexture("RenderTexture", 2D) = "white" {}
		_GlitterMask("GlitterMask", 2D) = "white" {}
		_ToonRampTint("ToonRamp Tint", Color) = (0,0,0,0)
		_NormalDerivativeOffset("Normal Derivative Offset", Range( 0 , 1)) = 0
		_NormalScale("Normal Scale", Float) = 0
		_Debug_Height("Debug_Height", Float) = 0
		_LightInfluence("Light Influence", Range( 0 , 1)) = 0
		[HDR]_GlitterInt("Glitter Int", Color) = (1,1,1,0)
		_Hardness("Hardness", Float) = 0
		_distanceGlitter("distance Glitter", Float) = 0
		_UVControlScreenMask("UV Control Screen Mask", Vector) = (0,0,0,0)
		_BiasDistance("BiasDistance", Float) = 0
		[HDR]_SnowEmissive("Snow Emissive", Color) = (0,0,0,0)
		_CaptureSize("CaptureSize", Float) = 0
		_Vignette("Vignette", 2D) = "white" {}
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
		#include "UnityStandardUtils.cginc"
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
		uniform sampler2D _Vignette;
		uniform float4 _Vignette_ST;
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
			float2 uv_Vignette = v.texcoord * _Vignette_ST.xy + _Vignette_ST.zw;
			float3 appendResult24 = (float3(0.0 , 0.0 , ( ( ( 1.0 - tex2DNode394.r ) * tex2Dlod( _Vignette, float4( uv_Vignette, 0, 0.0) ).r ) * ( _SnowHeight + 0.1 ) )));
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
			float2 appendResult425 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_429_0 = ( ( ( appendResult425 + _PositionPlayer ) + ( _CaptureSize / 2.0 ) ) / _CaptureSize );
			float temp_output_355_0 = (0.0 + (_NormalDerivativeOffset - 0.0) * (1.0 - 0.0) / (1.0 - 0.0));
			float2 appendResult356 = (float2(temp_output_355_0 , 0.0));
			float2 appendResult357 = (float2(0.0 , temp_output_355_0));
			float2 appendResult363 = (float2(tex2D( _RenderTexture, ( temp_output_429_0 - appendResult356 ) ).r , tex2D( _RenderTexture, ( temp_output_429_0 - appendResult357 ) ).r));
			float4 tex2DNode394 = tex2D( _RenderTexture, temp_output_429_0 );
			float2 temp_cast_2 = (tex2DNode394.r).xx;
			float2 break367 = ( ( appendResult363 - temp_cast_2 ) * _NormalScale );
			float3 appendResult374 = (float3(break367.x , break367.y , sqrt( ( 1.0 - saturate( ( ( break367.x * break367.x ) + ( break367.y * break367.y ) ) ) ) )));
			float dotResult436 = dot( ase_worldlightDir , BlendNormals( ase_worldNormal , appendResult374 ) );
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
			float2 appendResult425 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_429_0 = ( ( ( appendResult425 + _PositionPlayer ) + ( _CaptureSize / 2.0 ) ) / _CaptureSize );
			float temp_output_355_0 = (0.0 + (_NormalDerivativeOffset - 0.0) * (1.0 - 0.0) / (1.0 - 0.0));
			float2 appendResult356 = (float2(temp_output_355_0 , 0.0));
			float2 appendResult357 = (float2(0.0 , temp_output_355_0));
			float2 appendResult363 = (float2(tex2D( _RenderTexture, ( temp_output_429_0 - appendResult356 ) ).r , tex2D( _RenderTexture, ( temp_output_429_0 - appendResult357 ) ).r));
			float4 tex2DNode394 = tex2D( _RenderTexture, temp_output_429_0 );
			float2 temp_cast_0 = (tex2DNode394.r).xx;
			float2 break367 = ( ( appendResult363 - temp_cast_0 ) * _NormalScale );
			float3 appendResult374 = (float3(break367.x , break367.y , sqrt( ( 1.0 - saturate( ( ( break367.x * break367.x ) + ( break367.y * break367.y ) ) ) ) )));
			float dotResult436 = dot( ase_worldlightDir , BlendNormals( ase_worldNormal , appendResult374 ) );
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
335;73;1037;656;4895.866;-287.2717;5.710472;True;False
Node;AmplifyShaderEditor.CommentaryNode;116;-5810.51,2586.318;Inherit;False;3007;698.6722;Comment;16;24;35;73;30;36;394;3;429;426;427;431;428;49;425;424;494;Vertex OffSet;1,0.6687182,0,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;424;-5630.529,2951.393;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;49;-5482.444,3151.656;Inherit;False;Property;_PositionPlayer;Position Player;0;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;428;-5196.567,3196.06;Inherit;False;Property;_CaptureSize;CaptureSize;21;0;Create;True;0;0;False;0;0;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;425;-5383.842,2968.643;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;354;-5585.068,1171.54;Inherit;False;Property;_NormalDerivativeOffset;Normal Derivative Offset;11;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;431;-5108.717,2976.07;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;427;-4983.841,3069.132;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;355;-5247.876,1180.81;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;426;-4837.917,2951.925;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;357;-4949.88,1276.003;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;429;-4634.666,3022.998;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;356;-4954.462,1108.951;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-5703.603,2707.481;Inherit;True;Property;_RenderTexture;RenderTexture;8;0;Create;True;0;0;False;0;None;9b8ae007f3a4a3e40b310c38adf70137;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;358;-4760.063,1108.49;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;359;-4760.551,1278.573;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;361;-4541.902,1286.535;Inherit;True;Property;_TextureSample2;Texture Sample 2;18;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;360;-4535.329,1076.396;Inherit;True;Property;_TextureSample1;Texture Sample 1;17;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;394;-4412.886,2658.946;Inherit;True;Property;_TextureSample4;Texture Sample 4;19;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;363;-4189.65,1219.531;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;366;-4035.287,934.1814;Inherit;False;Property;_NormalScale;Normal Scale;12;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;364;-3999.902,1216.234;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;365;-3823.386,978.3794;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;367;-3677.786,1073.281;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;368;-3387.786,1156.48;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;369;-3449.687,1346.376;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;370;-3270.873,1270.303;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;500;-1805.896,537.6331;Inherit;False;3733.628;3255.58;Comment;4;499;498;489;176;Snow Material;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;498;-1755.896,2299.481;Inherit;False;2973.907;1493.731;Comment;30;470;447;449;448;450;451;452;453;454;455;460;456;485;487;486;457;488;458;459;461;465;463;462;464;466;467;468;469;480;478;Glitter;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;371;-3139.795,1349.363;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;372;-2990.046,1249.072;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;447;-1705.896,2820.269;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;448;-1316.086,3121.932;Inherit;False;Property;_UVControlScreenMask;UV Control Screen Mask;18;0;Create;True;0;0;False;0;0,0,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;449;-1506.308,2848.992;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;499;-1288.97,679.111;Inherit;False;2928.251;1084.928;Comment;22;492;490;434;496;435;436;437;439;438;441;440;442;443;444;474;347;445;473;475;477;476;446;Toon;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;378;-5635.068,884.1815;Inherit;False;3360.838;632.3541;Comment;1;374;Partial Derivative Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.SqrtOpNode;373;-2812.819,1228.462;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;450;-1070.016,2990.14;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;434;-1238.97,1065.893;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;374;-2567.343,1065.489;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;451;-1341.529,2896.376;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;453;-953.0162,3232.14;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;452;-883.0162,2932.14;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendNormalsNode;496;-888.1154,1095.459;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;435;-961.1984,889.111;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;455;-922.5602,2647.499;Inherit;True;Property;_GlitterMask;GlitterMask;9;0;Create;True;0;0;False;0;None;1686cf316c886694c9a59b1a8c0563f3;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;437;-673.1988,793.111;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;454;-767.0162,3094.14;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;436;-625.1989,953.111;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;438;-433.1989,841.111;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;439;-417.1989,729.111;Inherit;False;Constant;_Float2;Float 2;8;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;456;-532.9061,2868.629;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;460;-529.5323,2597.736;Inherit;True;Property;_Mask_Glitter;Mask_Glitter;6;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightAttenuation;441;-321.1989,953.111;Inherit;True;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;440;-209.1989,777.111;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;485;-224.4199,2850.16;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.84;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;487;-202.4199,2661.16;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.84;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;459;-475.0284,3218.879;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;442;-17.19884,873.111;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;488;-64.41995,2706.16;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;458;-557.0431,3413.815;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;457;-170.4907,3670.586;Inherit;False;Property;_BiasDistance;BiasDistance;19;0;Create;True;0;0;False;0;0;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;486;-34.41998,2807.16;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;461;-195.9646,3530.528;Inherit;False;Property;_distanceGlitter;distance Glitter;17;0;Create;True;0;0;False;0;0;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;474;360.0805,1606.006;Inherit;False;Property;_LightInfluence;Light Influence;14;0;Create;True;0;0;False;0;0;0.11;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;444;367.0562,1362.163;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;464;51.0856,2866.769;Inherit;False;Property;_Hardness;Hardness;16;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;443;270.8012,793.111;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;462;83.05612,2725.464;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;463;-259.8856,3274.744;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;465;96.91553,3540.213;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-4177.606,2934.33;Inherit;False;Property;_SnowHeight;Snow Height;6;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;493;-4043.708,2318.638;Inherit;True;Property;_Vignette;Vignette;22;0;Create;True;0;0;False;0;-1;None;d4ef717bdd61a1b4bb34a8626107aefe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;466;238.9112,2767.304;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;475;685.759,1484.586;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;473;615.1401,1335.859;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;347;394.8036,1051.34;Inherit;False;Property;_ToonRampTint;ToonRamp Tint;10;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;467;276.0352,3274.529;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;30;-3845.064,2645.628;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;445;446.8012,729.111;Inherit;True;Property;_ToonRamp2;ToonRamp2;7;0;Create;True;0;0;False;0;-1;None;ea8738c3ec6ed684188ae5136f811377;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;469;498.9157,3152.213;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;468;406.5627,2773.107;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-3842.508,2890.317;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;494;-3652.047,2624.13;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;477;818.5038,851.8422;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;476;828.29,1369.28;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;446;905.7834,1234.444;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-3586.509,2762.317;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;492;1207.119,1557.039;Inherit;False;Property;_SnowEmissive;Snow Emissive;20;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.8649023,0.8649023,0.8649023,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;480;735.4666,2427.867;Inherit;False;Property;_GlitterInt;Glitter Int;15;1;[HDR];Create;True;0;0;False;0;1,1,1,0;2.996078,2.996078,2.996078,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;470;871.0645,2624.028;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;478;1049.011,2349.481;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;433;-2795.858,2798.859;Inherit;False;Property;_Debug_Height;Debug_Height;13;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-3330.509,2762.317;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;490;1470.281,1479.686;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;176;1150.365,1848.464;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;489;1770.465,1679.996;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;432;-2585.895,2654.389;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1997.572,1767.988;Float;False;True;-1;6;ASEMaterialInspector;0;0;CustomLighting;Custom/SnowShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;3;2;10;25;True;0.37;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;1;0;False;0;0;False;-1;-1;0;False;-1;1;Pragma;addshadow;False;;Custom;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;425;0;424;1
WireConnection;425;1;424;3
WireConnection;431;0;425;0
WireConnection;431;1;49;0
WireConnection;427;0;428;0
WireConnection;355;0;354;0
WireConnection;426;0;431;0
WireConnection;426;1;427;0
WireConnection;357;1;355;0
WireConnection;429;0;426;0
WireConnection;429;1;428;0
WireConnection;356;0;355;0
WireConnection;358;0;429;0
WireConnection;358;1;356;0
WireConnection;359;0;429;0
WireConnection;359;1;357;0
WireConnection;361;0;3;0
WireConnection;361;1;359;0
WireConnection;360;0;3;0
WireConnection;360;1;358;0
WireConnection;394;0;3;0
WireConnection;394;1;429;0
WireConnection;363;0;360;1
WireConnection;363;1;361;1
WireConnection;364;0;363;0
WireConnection;364;1;394;1
WireConnection;365;0;364;0
WireConnection;365;1;366;0
WireConnection;367;0;365;0
WireConnection;368;0;367;0
WireConnection;368;1;367;0
WireConnection;369;0;367;1
WireConnection;369;1;367;1
WireConnection;370;0;368;0
WireConnection;370;1;369;0
WireConnection;371;0;370;0
WireConnection;372;0;371;0
WireConnection;449;0;447;1
WireConnection;449;1;447;2
WireConnection;373;0;372;0
WireConnection;450;0;448;1
WireConnection;450;1;448;2
WireConnection;374;0;367;0
WireConnection;374;1;367;1
WireConnection;374;2;373;0
WireConnection;451;0;449;0
WireConnection;451;1;447;4
WireConnection;453;0;448;3
WireConnection;453;1;448;4
WireConnection;452;0;451;0
WireConnection;452;1;450;0
WireConnection;496;0;434;0
WireConnection;496;1;374;0
WireConnection;454;0;452;0
WireConnection;454;1;453;0
WireConnection;436;0;435;0
WireConnection;436;1;496;0
WireConnection;438;0;437;0
WireConnection;438;1;436;0
WireConnection;456;0;455;0
WireConnection;456;1;454;0
WireConnection;460;0;455;0
WireConnection;440;0;438;0
WireConnection;440;1;439;0
WireConnection;485;0;456;1
WireConnection;487;0;460;1
WireConnection;442;0;440;0
WireConnection;442;1;441;0
WireConnection;488;0;487;0
WireConnection;486;0;485;0
WireConnection;443;0;442;0
WireConnection;462;0;488;0
WireConnection;462;1;486;0
WireConnection;463;0;459;0
WireConnection;463;1;458;0
WireConnection;465;0;461;0
WireConnection;465;1;457;0
WireConnection;466;0;462;0
WireConnection;466;1;464;0
WireConnection;475;0;474;0
WireConnection;473;0;444;0
WireConnection;473;1;474;0
WireConnection;467;0;463;0
WireConnection;467;1;461;0
WireConnection;467;2;465;0
WireConnection;30;0;394;1
WireConnection;445;1;443;0
WireConnection;469;0;467;0
WireConnection;468;0;466;0
WireConnection;73;0;36;0
WireConnection;494;0;30;0
WireConnection;494;1;493;1
WireConnection;477;0;445;0
WireConnection;477;1;347;0
WireConnection;476;0;475;0
WireConnection;476;1;473;0
WireConnection;446;0;477;0
WireConnection;446;1;476;0
WireConnection;35;0;494;0
WireConnection;35;1;73;0
WireConnection;470;0;468;0
WireConnection;470;1;469;0
WireConnection;478;0;470;0
WireConnection;478;1;480;0
WireConnection;24;2;35;0
WireConnection;490;0;446;0
WireConnection;490;1;492;0
WireConnection;176;0;446;0
WireConnection;176;1;478;0
WireConnection;489;0;478;0
WireConnection;489;1;490;0
WireConnection;432;0;24;0
WireConnection;432;1;433;0
WireConnection;0;2;489;0
WireConnection;0;13;176;0
WireConnection;0;11;432;0
WireConnection;0;12;374;0
ASEEND*/
//CHKSM=F8B0D3706EDA9FA3F2F5008236872F547EEB829B