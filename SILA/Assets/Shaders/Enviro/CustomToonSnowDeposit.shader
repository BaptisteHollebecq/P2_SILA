// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/CustomToonSnowDeposit"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_BaseTint("Base Tint", Color) = (1,1,1,0)
		_BaseCellSharpness("Base Cell Sharpness", Range( 0.01 , 1)) = 0.01
		_BaseCellOffset("Base Cell Offset", Range( -1 , 1)) = 0
		_IndirectDiffuseContribution("Indirect Diffuse Contribution", Range( 0 , 1)) = 1
		_ShadowContribution("Shadow Contribution", Range( 0 , 1)) = 0.5
		[HDR]_HighlightTint("Highlight Tint", Color) = (1,1,1,1)
		_HighlightCellOffset("Highlight Cell Offset", Range( -1 , -0.5)) = -0.95
		_HighlightCellSharpness("Highlight Cell Sharpness", Range( 0.001 , 1)) = 0.01
		_SnowHeight("SnowHeight", Range( 0 , 1)) = 2
		_IndirectSpecularContribution("Indirect Specular Contribution", Range( 0 , 1)) = 1
		[Toggle(_STATICHIGHLIGHTS_ON)] _StaticHighLights("Static HighLights", Float) = 0
		_SnowDeposit("Snow Deposit", Float) = 0
		[Normal][NoScaleOffset]_NormalMap("Normal Map", 2D) = "bump" {}
		[HDR]_RimColor("Rim Color", Color) = (1,1,1,0)
		_RimPower("Rim Power", Range( 0.01 , 1)) = 0.4
		_RimOffset("Rim Offset", Range( 0 , 1)) = 0.6
		_ToonRamp2("ToonRamp2", 2D) = "white" {}
		_GlitterMask("GlitterMask", 2D) = "white" {}
		_ToonRampTint("ToonRamp Tint", Color) = (0,0,0,0)
		_NormalScale("Normal Scale", Range( 0 , 1)) = 1
		_LightInfluence("Light Influence", Range( 0 , 1)) = 0
		[HDR]_GlitterInt("Glitter Int", Color) = (1,1,1,0)
		_Hardness("Hardness", Float) = 0
		_distanceGlitter("distance Glitter", Float) = 0
		_UVControlScreenMask("UV Control Screen Mask", Vector) = (0,0,0,0)
		_BiasDistance("BiasDistance", Float) = 0
		[HDR]_SnowEmissive("Snow Emissive", Color) = (0,0,0,0)
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
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _STATICHIGHLIGHTS_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
			float3 worldPos;
			float4 screenPos;
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

		uniform float _IndirectDiffuseContribution;
		uniform float _NormalScale;
		uniform sampler2D _NormalMap;
		uniform float _BaseCellOffset;
		uniform float _BaseCellSharpness;
		uniform float _ShadowContribution;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _BaseTint;
		uniform float _SnowDeposit;
		uniform float _SnowHeight;
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
		uniform float4 _HighlightTint;
		uniform float _IndirectSpecularContribution;
		uniform float _HighlightCellOffset;
		uniform float _HighlightCellSharpness;
		uniform float _RimOffset;
		uniform float _RimPower;
		uniform float4 _RimColor;

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
			float3 temp_cast_2 = (1.0).xxx;
			float2 uv_NormalMap146 = i.uv_texcoord;
			float3 tex2DNode146 = UnpackScaleNormal( tex2D( _NormalMap, uv_NormalMap146 ), _NormalScale );
			float3 normalizeResult149 = normalize( (WorldNormalVector( i , tex2DNode146 )) );
			float3 indirectNormal199 = normalizeResult149;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 temp_output_163_0 = ( _HighlightTint * tex2D( _Albedo, uv_Albedo ) );
			float temp_output_172_0 = (temp_output_163_0).a;
			Unity_GlossyEnvironmentData g199 = UnityGlossyEnvironmentSetup( temp_output_172_0, data.worldViewDir, indirectNormal199, float3(0,0,0));
			float3 indirectSpecular199 = UnityGI_IndirectSpecular( data, 1.0, indirectNormal199, g199 );
			float3 lerpResult212 = lerp( temp_cast_2 , indirectSpecular199 , _IndirectSpecularContribution);
			float3 temp_output_218_0 = (temp_output_163_0).rgb;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_output_211_0 = ( ase_lightColor.rgb * ase_lightAtten );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult4_g3 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float dotResult173 = dot( normalizeResult4_g3 , normalizeResult149 );
			float dotResult154 = dot( normalizeResult149 , ase_worldlightDir );
			#ifdef _STATICHIGHLIGHTS_ON
				float staticSwitch179 = dotResult154;
			#else
				float staticSwitch179 = dotResult173;
			#endif
			float3 temp_cast_3 = (1.0).xxx;
			UnityGI gi180 = gi;
			float3 diffNorm180 = normalizeResult149;
			gi180 = UnityGI_Base( data, 1, diffNorm180 );
			float3 indirectDiffuse180 = gi180.indirect.diffuse + diffNorm180 * 0.0001;
			float3 lerpResult192 = lerp( temp_cast_3 , indirectDiffuse180 , _IndirectDiffuseContribution);
			float temp_output_187_0 = ( 1.0 - ( ( 1.0 - ase_lightAtten ) * _WorldSpaceLightPos0.w ) );
			float lerpResult197 = lerp( temp_output_187_0 , ( saturate( ( ( dotResult154 + _BaseCellOffset ) / _BaseCellSharpness ) ) * ase_lightAtten ) , _ShadowContribution);
			float4 tex2DNode195 = tex2D( _Albedo, uv_Albedo );
			float3 temp_output_220_0 = ( ( ( lerpResult192 * ase_lightColor.a * temp_output_187_0 ) + ( ase_lightColor.rgb * lerpResult197 ) ) * (( tex2DNode195 * _BaseTint )).rgb );
			float dotResult164 = dot( normalizeResult149 , ase_worldViewDir );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float dotResult242 = dot( ase_worldlightDir , BlendNormals( ase_worldNormal , float3( 0,0,0 ) ) );
			float2 appendResult261 = (float2(( ( ( 1.0 + dotResult242 ) / 2.0 ) * ase_lightAtten ) , 0.0));
			float4 temp_output_275_0 = ( ( tex2D( _ToonRamp2, appendResult261 ) * _ToonRampTint ) * ( ( 1.0 - _LightInfluence ) + ( ase_lightColor * _LightInfluence ) ) );
			float2 uv_GlitterMask = i.uv_texcoord * _GlitterMask_ST.xy + _GlitterMask_ST.zw;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 appendResult230 = (float2(ase_screenPosNorm.x , ase_screenPosNorm.y));
			float2 appendResult234 = (float2(_UVControlScreenMask.x , _UVControlScreenMask.y));
			float2 appendResult235 = (float2(_UVControlScreenMask.z , _UVControlScreenMask.w));
			float smoothstepResult265 = smoothstep( _distanceGlitter , ( _distanceGlitter + _BiasDistance ) , distance( ase_worldPos , _WorldSpaceCameraPos ));
			float4 temp_output_280_0 = ( ( saturate( ( ( ( 1.0 - step( tex2D( _GlitterMask, uv_GlitterMask ).r , 0.84 ) ) * ( 1.0 - step( tex2D( _GlitterMask, ( ( ( appendResult230 / ase_screenPosNorm.w ) * appendResult234 ) + appendResult235 ) ).r , 0.84 ) ) ) / _Hardness ) ) * ( 1.0 - smoothstepResult265 ) ) * _GlitterInt );
			float dotResult43 = dot( (WorldNormalVector( i , tex2DNode146 )) , float3(0,1,0) );
			float temp_output_47_0 = saturate( ( ( dotResult43 * _SnowDeposit ) + ( ( ( 1.0 - ( ( 1.0 - ( _SnowHeight + 0.3 ) ) * 70.0 ) ) + 6.0 ) * tex2DNode195.r ) ) );
			float4 lerpResult225 = lerp( float4( ( ( lerpResult212 * temp_output_218_0 * temp_output_211_0 * pow( temp_output_172_0 , 1.5 ) * saturate( ( ( staticSwitch179 + _HighlightCellOffset ) / ( ( 1.0 - temp_output_172_0 ) * _HighlightCellSharpness ) ) ) ) + temp_output_220_0 + ( ( saturate( dotResult154 ) * pow( ( 1.0 - saturate( ( dotResult164 + _RimOffset ) ) ) , _RimPower ) ) * temp_output_218_0 * temp_output_211_0 * (_RimColor).rgb ) ) , 0.0 ) , ( temp_output_275_0 + temp_output_280_0 ) , temp_output_47_0);
			c.rgb = lerpResult225.rgb;
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
			o.Normal = float3(0,0,1);
			float3 temp_cast_0 = (1.0).xxx;
			float3 lerpResult192 = lerp( temp_cast_0 , float3(0,0,0) , _IndirectDiffuseContribution);
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float temp_output_187_0 = ( 1.0 - ( ( 1.0 - 1 ) * _WorldSpaceLightPos0.w ) );
			float2 uv_NormalMap146 = i.uv_texcoord;
			float3 tex2DNode146 = UnpackScaleNormal( tex2D( _NormalMap, uv_NormalMap146 ), _NormalScale );
			float3 normalizeResult149 = normalize( (WorldNormalVector( i , tex2DNode146 )) );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult154 = dot( normalizeResult149 , ase_worldlightDir );
			float lerpResult197 = lerp( temp_output_187_0 , ( saturate( ( ( dotResult154 + _BaseCellOffset ) / _BaseCellSharpness ) ) * 1 ) , _ShadowContribution);
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 tex2DNode195 = tex2D( _Albedo, uv_Albedo );
			float3 temp_output_220_0 = ( ( ( lerpResult192 * ase_lightColor.a * temp_output_187_0 ) + ( ase_lightColor.rgb * lerpResult197 ) ) * (( tex2DNode195 * _BaseTint )).rgb );
			float dotResult43 = dot( (WorldNormalVector( i , tex2DNode146 )) , float3(0,1,0) );
			float temp_output_47_0 = saturate( ( ( dotResult43 * _SnowDeposit ) + ( ( ( 1.0 - ( ( 1.0 - ( _SnowHeight + 0.3 ) ) * 70.0 ) ) + 6.0 ) * tex2DNode195.r ) ) );
			o.Albedo = ( temp_output_220_0 * ( 1.0 - temp_output_47_0 ) );
			float2 uv_GlitterMask = i.uv_texcoord * _GlitterMask_ST.xy + _GlitterMask_ST.zw;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 appendResult230 = (float2(ase_screenPosNorm.x , ase_screenPosNorm.y));
			float2 appendResult234 = (float2(_UVControlScreenMask.x , _UVControlScreenMask.y));
			float2 appendResult235 = (float2(_UVControlScreenMask.z , _UVControlScreenMask.w));
			float smoothstepResult265 = smoothstep( _distanceGlitter , ( _distanceGlitter + _BiasDistance ) , distance( ase_worldPos , _WorldSpaceCameraPos ));
			float4 temp_output_280_0 = ( ( saturate( ( ( ( 1.0 - step( tex2D( _GlitterMask, uv_GlitterMask ).r , 0.84 ) ) * ( 1.0 - step( tex2D( _GlitterMask, ( ( ( appendResult230 / ase_screenPosNorm.w ) * appendResult234 ) + appendResult235 ) ).r , 0.84 ) ) ) / _Hardness ) ) * ( 1.0 - smoothstepResult265 ) ) * _GlitterInt );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float dotResult242 = dot( ase_worldlightDir , BlendNormals( ase_worldNormal , float3( 0,0,0 ) ) );
			float2 appendResult261 = (float2(( ( ( 1.0 + dotResult242 ) / 2.0 ) * 1 ) , 0.0));
			float4 temp_output_275_0 = ( ( tex2D( _ToonRamp2, appendResult261 ) * _ToonRampTint ) * ( ( 1.0 - _LightInfluence ) + ( ase_lightColor * _LightInfluence ) ) );
			o.Emission = ( ( temp_output_280_0 + ( temp_output_275_0 * _SnowEmissive ) ) * temp_output_47_0 ).rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
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
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
1920;0;1280;659;12745.45;2983.675;14.03274;True;False
Node;AmplifyShaderEditor.CommentaryNode;226;-7185.587,86.77788;Inherit;False;3733.628;3255.58;Comment;4;282;281;228;227;Snow Material;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;227;-7135.587,1848.626;Inherit;False;2973.907;1493.731;Comment;30;280;278;277;272;271;270;265;264;263;262;260;257;256;254;253;252;251;250;249;244;243;241;240;236;235;234;232;231;230;229;Glitter;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;144;-7123.741,-2872.689;Inherit;False;1370.182;280;Comment;4;149;147;146;145;Normals;0.5220588,0.6044625,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;229;-7085.587,2369.414;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;145;-7075.858,-2733.732;Float;False;Property;_NormalScale;Normal Scale;20;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;231;-6695.776,2671.077;Inherit;False;Property;_UVControlScreenMask;UV Control Screen Mask;25;0;Create;True;0;0;False;0;0,0,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;230;-6885.999,2398.137;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;146;-6742.134,-2822.689;Inherit;True;Property;_NormalMap;Normal Map;13;2;[Normal];[NoScaleOffset];Create;True;0;0;False;0;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;228;-6668.66,228.2559;Inherit;False;2928.251;1084.928;Comment;22;279;276;275;274;273;269;268;267;266;261;259;258;255;248;247;246;245;242;239;238;237;233;Toon;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;147;-6423.352,-2817.448;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;232;-6721.22,2445.521;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;148;-6996.276,-2291.559;Inherit;False;835.6508;341.2334;Comment;2;154;150;N dot L;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;234;-6449.707,2539.285;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;233;-6618.66,615.0378;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;151;-4995.869,-2198.173;Inherit;False;2744.931;803.0454;Comment;22;220;219;216;210;204;202;197;195;189;188;187;185;183;175;174;169;168;167;159;158;157;155;Base Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;150;-6946.276,-2129.325;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;236;-6262.707,2481.285;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendNormalsNode;237;-6267.806,644.6038;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;238;-6340.889,438.256;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;235;-6332.707,2781.285;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;149;-6181.716,-2818.392;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-2690.656,2173.736;Inherit;False;Constant;_Float2;Float 2;14;0;Create;True;0;0;False;0;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;154;-6621.984,-2204.76;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;153;-4592.086,-1096.277;Inherit;False;1926.522;520.1537;Comment;13;221;214;213;207;203;201;194;191;177;171;170;164;161;Rim Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;152;-5671.338,-3887.526;Inherit;False;2234.221;738.9581;Comment;15;222;218;217;209;193;190;186;181;179;178;173;166;163;162;160;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;242;-6004.889,502.2559;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;156;-6085.326,-3334.105;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-2865.613,1990.28;Inherit;False;Property;_SnowHeight;SnowHeight;9;0;Create;True;0;0;False;0;2;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;241;-6302.25,2196.644;Inherit;True;Property;_GlitterMask;GlitterMask;18;0;Create;True;0;0;False;0;None;1686cf316c886694c9a59b1a8c0563f3;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;239;-6052.889,342.2559;Inherit;False;Constant;_Float3;Float 3;8;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;240;-6146.707,2643.285;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-4945.869,-2016.774;Float;False;Property;_BaseCellOffset;Base Cell Offset;3;0;Create;True;0;0;False;0;0;0.06;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;162;-5059.356,-3670.712;Inherit;True;Property;_Highlight;Highlight;7;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;159;-4662.421,-2123.599;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;246;-5812.889,390.256;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;243;-5912.597,2417.774;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;161;-4495.055,-884.4987;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;244;-5909.223,2146.881;Inherit;True;Property;_Mask_Glitter;Mask_Glitter;6;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;157;-4643.794,-2027.088;Float;False;Property;_BaseCellSharpness;Base Cell Sharpness;2;0;Create;True;0;0;False;0;0.01;0.01;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;245;-5796.889,278.2559;Inherit;False;Constant;_Float6;Float 6;8;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;158;-4688.853,-1867.168;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;160;-4990.423,-3837.526;Float;False;Property;_HighlightTint;Highlight Tint;6;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;83;-2494.656,2040.736;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;249;-5604.11,2399.305;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.84;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;248;-5588.889,326.2559;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;247;-5700.889,502.2559;Inherit;True;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;169;-4363.356,-2120.756;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;250;-5582.11,2210.305;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.84;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;163;-4660.701,-3715.383;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;168;-4693.896,-1758.347;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;165;-4427.517,-4216.795;Inherit;False;287;165;Comment;1;172;Spec/Smooth;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;167;-4375.826,-1842.032;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;164;-4189.953,-949.3906;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;170;-4247.353,-832.1736;Float;False;Property;_RimOffset;Rim Offset;16;0;Create;True;0;0;False;0;0.6;0.65;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;166;-5621.338,-3391.672;Inherit;False;Blinn-Phong Half Vector;-1;;3;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-2277.541,2167.907;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;False;0;70;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;79;-2303.394,2033.771;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;175;-4205.903,-2115.726;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;255;-5396.889,422.256;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;172;-4377.517,-4166.795;Inherit;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;253;-5575.655,3079.673;Inherit;False;Property;_distanceGlitter;distance Glitter;24;0;Create;True;0;0;False;0;0;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;171;-3966.354,-945.1736;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;-4185.282,-1806.396;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;252;-5550.181,3219.731;Inherit;False;Property;_BiasDistance;BiasDistance;26;0;Create;True;0;0;False;0;0;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;256;-5854.719,2768.024;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;173;-5276.118,-3337.228;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;257;-5936.733,2962.96;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-2047.958,2008.343;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;251;-5414.11,2356.305;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;254;-5444.11,2255.305;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;176;-4964.512,-2845.411;Inherit;False;828.4254;361.0605;Comment;4;192;184;182;180;Indirect Diffuse;1,1,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;179;-5048.786,-3442.543;Float;False;Property;_StaticHighLights;Static HighLights;11;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;264;-5282.775,3089.358;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;177;-3806.354,-945.1736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;185;-4164.493,-1674.612;Float;False;Property;_ShadowContribution;Shadow Contribution;5;0;Create;True;0;0;False;0;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-3968.752,-2116.841;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;261;-5108.889,342.2559;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;260;-5328.605,2415.914;Inherit;False;Property;_Hardness;Hardness;23;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;259;-5012.634,911.3078;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;181;-4520.866,-3306.193;Float;False;Property;_HighlightCellSharpness;Highlight Cell Sharpness;8;0;Create;True;0;0;False;0;0.01;0.001;0.001;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;263;-5639.576,2823.889;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;262;-5296.634,2274.609;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;187;-3995.406,-1803.412;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;178;-4914.127,-3318.409;Float;False;Property;_HighlightCellOffset;Highlight Cell Offset;7;0;Create;True;0;0;False;0;-0.95;-0.747;-1;-0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;182;-4534.9,-2795.411;Float;False;Constant;_Float4;Float 4;20;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;78;-1846.934,2017.289;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;258;-5019.61,1155.151;Inherit;False;Property;_LightInfluence;Light Influence;21;0;Create;True;0;0;False;0;0;0.11;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;186;-4298.35,-3543.817;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-1817.313,2115.587;Inherit;False;Constant;_Float0;Float 0;14;0;Create;True;0;0;False;0;6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;180;-4631.453,-2699.436;Inherit;False;World;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;42;-1559.131,1686.684;Inherit;False;Constant;_Vector0;Vector 0;11;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;40;-1568.596,1522.482;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;184;-4660.517,-2599.351;Float;False;Property;_IndirectDiffuseContribution;Indirect Diffuse Contribution;4;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;265;-5103.655,2823.674;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;196;-6955.799,-1714.696;Inherit;False;717.6841;295.7439;Comment;3;211;208;206;Light Falloff;0.9947262,1,0.6176471,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;198;-4632.321,-4758.853;Inherit;False;1008.755;365.3326;Comment;4;212;205;200;199;Indirect Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-1627.33,2016.915;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;270;-5140.779,2316.449;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;193;-4559.35,-3446.323;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;267;-4932.889,278.2559;Inherit;True;Property;_ToonRamp2;ToonRamp2;17;0;Create;True;0;0;False;0;-1;None;ea8738c3ec6ed684188ae5136f811377;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;268;-4764.55,885.0038;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;195;-3384.779,-1782.567;Inherit;True;Property;_BaseColorRGBOutlineWidthA;Base Color (RGB) Outline Width (A);1;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;None;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightColorNode;188;-3693.003,-2116.313;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;45;-1302.232,1763.917;Inherit;False;Property;_SnowDeposit;Snow Deposit;12;0;Create;True;0;0;False;0;0;47.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;192;-4320.087,-2719.096;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;194;-3742.353,-817.1736;Float;False;Property;_RimPower;Rim Power;15;0;Create;True;0;0;False;0;0.4;0.358;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;266;-4984.887,600.4848;Inherit;False;Property;_ToonRampTint;ToonRamp Tint;19;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;269;-4693.932,1033.731;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;43;-1331.626,1626.739;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;197;-3612.697,-1801.336;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;-4203.437,-3312.857;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;189;-3344.153,-1578.838;Float;False;Property;_BaseTint;Base Tint;1;0;Create;True;0;0;False;0;1,1,1,0;0.6603774,0.6603774,0.6603774,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;191;-3630.353,-945.1736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;206;-6860.096,-1664.696;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;205;-4131.626,-4708.853;Float;False;Constant;_Float5;Float 5;20;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1109.202,1627.661;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;272;-4973.128,2322.252;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;201;-3428.961,-783.7697;Float;False;Property;_RimColor;Rim Color;14;1;[HDR];Create;True;0;0;False;0;1,1,1,0;1.009434,2,2,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;271;-4880.775,2701.358;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;-3043.131,-1687.818;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;208;-6905.799,-1528.952;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;204;-3268.969,-1923.792;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;207;-3438.353,-945.1736;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;273;-4561.187,400.9872;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;274;-4551.4,918.4249;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;209;-4211.113,-3454.016;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;203;-3449.13,-1024.417;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectSpecularLight;199;-4158.255,-4621.629;Inherit;False;World;3;0;FLOAT3;0,0,0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1340.822,2009.451;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;200;-4225.428,-4508.522;Float;False;Property;_IndirectSpecularContribution;Indirect Specular Contribution;10;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;202;-3271.271,-2148.173;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;277;-4644.224,1977.012;Inherit;False;Property;_GlitterInt;Glitter Int;22;1;[HDR];Create;True;0;0;False;0;1,1,1,0;2.996078,2.996078,2.996078,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;276;-4172.571,1106.184;Inherit;False;Property;_SnowEmissive;Snow Emissive;27;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.8649023,0.8649023,0.8649023,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;-3154.225,-1016.4;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;212;-3807.563,-4656.008;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;216;-2895.963,-1704.021;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;215;-4042.53,-4021.878;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;278;-4508.626,2173.173;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;218;-4421.001,-3711.566;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-822.2188,1980.054;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;219;-3012.124,-2035.048;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;217;-3995.229,-3450.303;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;213;-3165.129,-731.9916;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;275;-4473.907,783.5888;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;211;-6671.8,-1598.535;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;222;-3606.117,-3717.126;Inherit;False;5;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;280;-4330.68,1898.626;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;279;-3909.409,1028.831;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;221;-2849.271,-1023.348;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;220;-2711.068,-1908.85;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;47;-637.7464,2007.049;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;223;-1792.414,-1914.413;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;288;297.2581,-8.228523;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;281;-4229.325,1397.609;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;282;-3565.485,1294.753;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;294;262.1556,1968.463;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;287;425.0188,-218.0033;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldToObjectTransfNode;298;714.9424,2034.283;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;225;-98.70847,-48.75784;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;290;498.3596,2160.056;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;300;-293.9746,2026.098;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;286;-240.5355,357.2079;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;289;-316.5835,1895.935;Inherit;False;Property;_VolumSnowHeight;Volum Snow Height;28;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;308;-223.9526,2254.467;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;291;-68.56306,1971.377;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;875.1489,11.6877;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Custom/CustomToonSnowDeposit;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;230;0;229;1
WireConnection;230;1;229;2
WireConnection;146;5;145;0
WireConnection;147;0;146;0
WireConnection;232;0;230;0
WireConnection;232;1;229;4
WireConnection;234;0;231;1
WireConnection;234;1;231;2
WireConnection;236;0;232;0
WireConnection;236;1;234;0
WireConnection;237;0;233;0
WireConnection;235;0;231;3
WireConnection;235;1;231;4
WireConnection;149;0;147;0
WireConnection;154;0;149;0
WireConnection;154;1;150;0
WireConnection;242;0;238;0
WireConnection;242;1;237;0
WireConnection;240;0;236;0
WireConnection;240;1;235;0
WireConnection;162;0;156;0
WireConnection;159;0;154;0
WireConnection;159;1;155;0
WireConnection;246;0;239;0
WireConnection;246;1;242;0
WireConnection;243;0;241;0
WireConnection;243;1;240;0
WireConnection;244;0;241;0
WireConnection;83;0;33;0
WireConnection;83;1;84;0
WireConnection;249;0;243;1
WireConnection;248;0;246;0
WireConnection;248;1;245;0
WireConnection;169;0;159;0
WireConnection;169;1;157;0
WireConnection;250;0;244;1
WireConnection;163;0;160;0
WireConnection;163;1;162;0
WireConnection;167;0;158;0
WireConnection;164;0;149;0
WireConnection;164;1;161;0
WireConnection;79;0;83;0
WireConnection;175;0;169;0
WireConnection;255;0;248;0
WireConnection;255;1;247;0
WireConnection;172;0;163;0
WireConnection;171;0;164;0
WireConnection;171;1;170;0
WireConnection;174;0;167;0
WireConnection;174;1;168;2
WireConnection;173;0;166;0
WireConnection;173;1;149;0
WireConnection;75;0;79;0
WireConnection;75;1;74;0
WireConnection;251;0;249;0
WireConnection;254;0;250;0
WireConnection;179;1;173;0
WireConnection;179;0;154;0
WireConnection;264;0;253;0
WireConnection;264;1;252;0
WireConnection;177;0;171;0
WireConnection;183;0;175;0
WireConnection;183;1;158;0
WireConnection;261;0;255;0
WireConnection;263;0;256;0
WireConnection;263;1;257;0
WireConnection;262;0;254;0
WireConnection;262;1;251;0
WireConnection;187;0;174;0
WireConnection;78;0;75;0
WireConnection;186;0;172;0
WireConnection;180;0;149;0
WireConnection;40;0;146;0
WireConnection;265;0;263;0
WireConnection;265;1;253;0
WireConnection;265;2;264;0
WireConnection;76;0;78;0
WireConnection;76;1;72;0
WireConnection;270;0;262;0
WireConnection;270;1;260;0
WireConnection;193;0;179;0
WireConnection;193;1;178;0
WireConnection;267;1;261;0
WireConnection;268;0;259;0
WireConnection;268;1;258;0
WireConnection;195;0;156;0
WireConnection;192;0;182;0
WireConnection;192;1;180;0
WireConnection;192;2;184;0
WireConnection;269;0;258;0
WireConnection;43;0;40;0
WireConnection;43;1;42;0
WireConnection;197;0;187;0
WireConnection;197;1;183;0
WireConnection;197;2;185;0
WireConnection;190;0;186;0
WireConnection;190;1;181;0
WireConnection;191;0;177;0
WireConnection;44;0;43;0
WireConnection;44;1;45;0
WireConnection;272;0;270;0
WireConnection;271;0;265;0
WireConnection;210;0;195;0
WireConnection;210;1;189;0
WireConnection;204;0;188;1
WireConnection;204;1;197;0
WireConnection;207;0;191;0
WireConnection;207;1;194;0
WireConnection;273;0;267;0
WireConnection;273;1;266;0
WireConnection;274;0;269;0
WireConnection;274;1;268;0
WireConnection;209;0;193;0
WireConnection;209;1;190;0
WireConnection;203;0;154;0
WireConnection;199;0;149;0
WireConnection;199;1;172;0
WireConnection;32;0;76;0
WireConnection;32;1;195;1
WireConnection;202;0;192;0
WireConnection;202;1;188;2
WireConnection;202;2;187;0
WireConnection;214;0;203;0
WireConnection;214;1;207;0
WireConnection;212;0;205;0
WireConnection;212;1;199;0
WireConnection;212;2;200;0
WireConnection;216;0;210;0
WireConnection;215;0;172;0
WireConnection;278;0;272;0
WireConnection;278;1;271;0
WireConnection;218;0;163;0
WireConnection;39;0;44;0
WireConnection;39;1;32;0
WireConnection;219;0;202;0
WireConnection;219;1;204;0
WireConnection;217;0;209;0
WireConnection;213;0;201;0
WireConnection;275;0;273;0
WireConnection;275;1;274;0
WireConnection;211;0;206;1
WireConnection;211;1;208;0
WireConnection;222;0;212;0
WireConnection;222;1;218;0
WireConnection;222;2;211;0
WireConnection;222;3;215;0
WireConnection;222;4;217;0
WireConnection;280;0;278;0
WireConnection;280;1;277;0
WireConnection;279;0;275;0
WireConnection;279;1;276;0
WireConnection;221;0;214;0
WireConnection;221;1;218;0
WireConnection;221;2;211;0
WireConnection;221;3;213;0
WireConnection;220;0;219;0
WireConnection;220;1;216;0
WireConnection;47;0;39;0
WireConnection;223;0;222;0
WireConnection;223;1;220;0
WireConnection;223;2;221;0
WireConnection;288;0;47;0
WireConnection;281;0;275;0
WireConnection;281;1;280;0
WireConnection;282;0;280;0
WireConnection;282;1;279;0
WireConnection;294;0;291;0
WireConnection;294;1;308;2
WireConnection;287;0;220;0
WireConnection;287;1;288;0
WireConnection;298;0;290;0
WireConnection;225;0;223;0
WireConnection;225;1;281;0
WireConnection;225;2;47;0
WireConnection;290;0;308;1
WireConnection;290;1;294;0
WireConnection;290;2;308;3
WireConnection;300;0;47;0
WireConnection;286;0;282;0
WireConnection;286;1;47;0
WireConnection;291;0;289;0
WireConnection;291;1;300;0
WireConnection;0;0;287;0
WireConnection;0;2;286;0
WireConnection;0;13;225;0
ASEEND*/
//CHKSM=30027C29A35FE5AA9F1EBC57695E9A5014168FBE