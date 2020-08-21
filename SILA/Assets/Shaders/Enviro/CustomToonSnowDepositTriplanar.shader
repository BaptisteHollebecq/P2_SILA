// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/CustomToonSnowDepositTriplanar"
{
	Properties
	{
		[HDR]_BaseTint("Base Tint", Color) = (1,1,1,0)
		_BaseCellSharpness("Base Cell Sharpness", Range( 0.01 , 1)) = 0.01
		_BaseCellOffset("Base Cell Offset", Range( -1 , 1)) = 0
		_IndirectDiffuseContribution("Indirect Diffuse Contribution", Range( 0 , 1)) = 1
		_ShadowContribution("Shadow Contribution", Range( 0 , 1)) = 0.5
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
		_BiasDistance("BiasDistance", Float) = 0
		[HDR]_SnowEmissive("Snow Emissive", Color) = (0,0,0,0)
		_TriplanarTex("Triplanar Tex", 2D) = "white" {}
		_UVControl("UV Control", Vector) = (1,1,0,0)
		_TriplanarHardness("Triplanar Hardness", Range( 0 , 1)) = 0
		_CurvatureMap("Curvature Map", 2D) = "white" {}
		_CurvatureTint("Curvature Tint", Color) = (1,1,1,0)
		_SnowSoftEdge("SnowSoftEdge", Range( 0 , 1)) = 0
		_SnowNoiseScale("SnowNoiseScale", Float) = 0
		_SnowOffset("SnowOffset", Float) = 0
		_SnowHeight("SnowHeight", Float) = 0
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
		#include "Lighting.cginc"
		#pragma target 3.0
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
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
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

		uniform sampler2D _GlitterMask;
		uniform float4 _GlitterMask_ST;
		uniform float _Hardness;
		uniform float _distanceGlitter;
		uniform float _BiasDistance;
		uniform float4 _GlitterInt;
		uniform sampler2D _ToonRamp2;
		uniform float _NormalScale;
		uniform sampler2D _NormalMap;
		uniform float4 _ToonRampTint;
		uniform float _LightInfluence;
		uniform float4 _SnowEmissive;
		uniform float _SnowSoftEdge;
		uniform float _SnowHeight;
		uniform float _SnowOffset;
		uniform float _SnowDeposit;
		uniform float _SnowNoiseScale;
		uniform float _IndirectDiffuseContribution;
		uniform float _BaseCellOffset;
		uniform float _BaseCellSharpness;
		uniform float _ShadowContribution;
		uniform sampler2D _TriplanarTex;
		uniform float4 _UVControl;
		uniform float _TriplanarHardness;
		uniform float4 _BaseTint;
		uniform float _RimOffset;
		uniform float _RimPower;
		uniform float4 _RimColor;
		uniform sampler2D _CurvatureMap;
		uniform float4 _CurvatureMap_ST;
		uniform float4 _CurvatureTint;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
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
			float3 temp_cast_1 = (1.0).xxx;
			float3 tex2DNode146 = UnpackScaleNormal( tex2D( _NormalMap, i.uv_texcoord ), _NormalScale );
			float3 normalizeResult149 = normalize( (WorldNormalVector( i , tex2DNode146 )) );
			UnityGI gi180 = gi;
			float3 diffNorm180 = normalizeResult149;
			gi180 = UnityGI_Base( data, 1, diffNorm180 );
			float3 indirectDiffuse180 = gi180.indirect.diffuse + diffNorm180 * 0.0001;
			float3 lerpResult192 = lerp( temp_cast_1 , indirectDiffuse180 , _IndirectDiffuseContribution);
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float temp_output_187_0 = ( 1.0 - ( ( 1.0 - ase_lightAtten ) * _WorldSpaceLightPos0.w ) );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult154 = dot( normalizeResult149 , ase_worldlightDir );
			float lerpResult197 = lerp( temp_output_187_0 , ( saturate( ( ( dotResult154 + _BaseCellOffset ) / _BaseCellSharpness ) ) * ase_lightAtten ) , _ShadowContribution);
			float4 break1_g4 = _UVControl;
			float2 appendResult4_g4 = (float2(break1_g4.x , break1_g4.y));
			float3 break2_g4 = ase_worldPos;
			float2 appendResult6_g4 = (float2(break2_g4.y , break2_g4.z));
			float2 appendResult10_g4 = (float2(break1_g4.z , break1_g4.w));
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 temp_cast_2 = ((5.0 + (_TriplanarHardness - 0.0) * (100.0 - 5.0) / (1.0 - 0.0))).xxx;
			float3 temp_output_27_0_g4 = pow( abs( ase_worldNormal ) , temp_cast_2 );
			float3 break28_g4 = temp_output_27_0_g4;
			float3 break18_g4 = ( temp_output_27_0_g4 / ( break28_g4.x + break28_g4.y + break28_g4.z ) );
			float2 appendResult5_g4 = (float2(break2_g4.x , break2_g4.z));
			float2 appendResult3_g4 = (float2(break2_g4.x , break2_g4.y));
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult164 = dot( normalizeResult149 , ase_worldViewDir );
			float3 temp_output_223_0 = ( float3( 0,0,0 ) + ( ( ( lerpResult192 * ase_lightColor.a * temp_output_187_0 ) + ( ase_lightColor.rgb * lerpResult197 ) ) * (( ( ( tex2D( _TriplanarTex, ( ( appendResult4_g4 * appendResult6_g4 ) + appendResult10_g4 ) ) * break18_g4.x ) + ( tex2D( _TriplanarTex, ( ( appendResult4_g4 * appendResult5_g4 ) + appendResult10_g4 ) ) * break18_g4.y ) + ( tex2D( _TriplanarTex, ( ( appendResult3_g4 * appendResult4_g4 ) + appendResult10_g4 ) ) * break18_g4.z ) ) * _BaseTint )).rgb ) + ( ( saturate( dotResult154 ) * pow( ( 1.0 - saturate( ( dotResult164 + _RimOffset ) ) ) , _RimPower ) ) * float3( 0,0,0 ) * ( ase_lightColor.rgb * ase_lightAtten ) * (_RimColor).rgb ) );
			float2 uv_CurvatureMap = i.uv_texcoord * _CurvatureMap_ST.xy + _CurvatureMap_ST.zw;
			float4 smoothstepResult326 = smoothstep( float4( 0.490566,0.490566,0.490566,0 ) , float4( 1,1,1,0 ) , tex2D( _CurvatureMap, uv_CurvatureMap ));
			float dotResult242 = dot( ase_worldlightDir , (WorldNormalVector( i , tex2DNode146 )) );
			float2 appendResult261 = (float2(( ( 1.0 + dotResult242 ) / 2.0 ) , 0.0));
			float4 temp_output_275_0 = ( ( tex2D( _ToonRamp2, appendResult261 ) * _ToonRampTint ) * ( ( 1.0 - _LightInfluence ) + ( ase_lightColor * _LightInfluence ) ) );
			float2 uv_GlitterMask = i.uv_texcoord * _GlitterMask_ST.xy + _GlitterMask_ST.zw;
			float2 uv_TexCoord319 = i.uv_texcoord * float2( 3,3 );
			float smoothstepResult265 = smoothstep( _distanceGlitter , ( _distanceGlitter + _BiasDistance ) , distance( ase_worldPos , _WorldSpaceCameraPos ));
			float4 temp_output_280_0 = ( ( saturate( ( ( ( 1.0 - step( tex2D( _GlitterMask, uv_GlitterMask ).r , 0.84 ) ) * ( 1.0 - step( tex2D( _GlitterMask, uv_TexCoord319 ).r , 0.84 ) ) ) / _Hardness ) ) * ( 1.0 - smoothstepResult265 ) ) * _GlitterInt );
			float dotResult43 = dot( (WorldNormalVector( i , tex2DNode146 )) , float3(0,1,0) );
			float smoothstepResult327 = smoothstep( 0.0 , _SnowSoftEdge , ( dotResult43 + ( _SnowHeight + _SnowOffset ) ));
			float simplePerlin2D330 = snoise( i.uv_texcoord*_SnowNoiseScale );
			simplePerlin2D330 = simplePerlin2D330*0.5 + 0.5;
			float temp_output_47_0 = saturate( ( smoothstepResult327 * _SnowDeposit * simplePerlin2D330 ) );
			float4 lerpResult225 = lerp( ( float4( ( temp_output_223_0 * float3( 0,0,0 ) ) , 0.0 ) + float4( temp_output_223_0 , 0.0 ) + ( smoothstepResult326 * _CurvatureTint ) ) , ( temp_output_275_0 + temp_output_280_0 ) , temp_output_47_0);
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
			float2 uv_GlitterMask = i.uv_texcoord * _GlitterMask_ST.xy + _GlitterMask_ST.zw;
			float2 uv_TexCoord319 = i.uv_texcoord * float2( 3,3 );
			float3 ase_worldPos = i.worldPos;
			float smoothstepResult265 = smoothstep( _distanceGlitter , ( _distanceGlitter + _BiasDistance ) , distance( ase_worldPos , _WorldSpaceCameraPos ));
			float4 temp_output_280_0 = ( ( saturate( ( ( ( 1.0 - step( tex2D( _GlitterMask, uv_GlitterMask ).r , 0.84 ) ) * ( 1.0 - step( tex2D( _GlitterMask, uv_TexCoord319 ).r , 0.84 ) ) ) / _Hardness ) ) * ( 1.0 - smoothstepResult265 ) ) * _GlitterInt );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 tex2DNode146 = UnpackScaleNormal( tex2D( _NormalMap, i.uv_texcoord ), _NormalScale );
			float dotResult242 = dot( ase_worldlightDir , (WorldNormalVector( i , tex2DNode146 )) );
			float2 appendResult261 = (float2(( ( 1.0 + dotResult242 ) / 2.0 ) , 0.0));
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 temp_output_275_0 = ( ( tex2D( _ToonRamp2, appendResult261 ) * _ToonRampTint ) * ( ( 1.0 - _LightInfluence ) + ( ase_lightColor * _LightInfluence ) ) );
			float dotResult43 = dot( (WorldNormalVector( i , tex2DNode146 )) , float3(0,1,0) );
			float smoothstepResult327 = smoothstep( 0.0 , _SnowSoftEdge , ( dotResult43 + ( _SnowHeight + _SnowOffset ) ));
			float simplePerlin2D330 = snoise( i.uv_texcoord*_SnowNoiseScale );
			simplePerlin2D330 = simplePerlin2D330*0.5 + 0.5;
			float temp_output_47_0 = saturate( ( smoothstepResult327 * _SnowDeposit * simplePerlin2D330 ) );
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
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
481;73;1045;650;3572.208;1848.368;2.848292;True;False
Node;AmplifyShaderEditor.CommentaryNode;144;-7524.42,-2654.137;Inherit;False;1370.182;280;Comment;4;149;147;146;145;Normals;0.5220588,0.6044625,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;309;-7540.603,-2866.347;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;145;-7476.537,-2515.18;Float;False;Property;_NormalScale;Normal Scale;13;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;146;-7142.813,-2604.137;Inherit;True;Property;_NormalMap;Normal Map;6;2;[Normal];[NoScaleOffset];Create;True;0;0;False;0;-1;None;225bc0f37dc0a404ab8ee7b01b226ef9;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;148;-7396.955,-2073.007;Inherit;False;835.6508;341.2334;Comment;2;154;150;N dot L;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;147;-6824.031,-2598.896;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;151;-5396.547,-1979.621;Inherit;False;2744.931;803.0454;Comment;21;220;219;216;210;204;202;197;189;188;187;185;183;175;174;169;168;167;159;158;157;155;Base Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalizeNode;149;-6582.395,-2599.84;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;150;-7346.955,-1910.773;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;154;-7022.663,-1986.208;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;226;-11184.68,682.5519;Inherit;False;3733.628;3255.58;Comment;4;282;281;228;227;Snow Material;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;153;-4992.764,-877.7251;Inherit;False;1926.522;520.1537;Comment;13;221;214;213;207;203;201;194;191;177;171;170;164;161;Rim Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-5346.547,-1798.222;Float;False;Property;_BaseCellOffset;Base Cell Offset;2;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;228;-10656.68,810.5519;Inherit;False;2928.251;1084.928;Comment;19;279;276;275;274;273;269;268;267;266;261;259;258;248;246;245;242;239;238;233;Toon;1,1,1,1;0;0
Node;AmplifyShaderEditor.LightAttenuation;158;-5089.532,-1648.616;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;161;-4895.734,-665.9469;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;159;-5063.099,-1905.047;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;227;-11120.68,2442.552;Inherit;False;2973.907;1493.731;Comment;31;280;278;277;272;271;270;265;264;263;262;260;257;256;254;253;252;251;250;249;244;243;241;240;236;235;234;232;231;230;229;319;Glitter;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;157;-5044.472,-1808.536;Float;False;Property;_BaseCellSharpness;Base Cell Sharpness;1;0;Create;True;0;0;False;0;0.01;0.67;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;164;-4590.631,-730.8387;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;167;-4776.504,-1623.48;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;168;-5094.575,-1539.795;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;169;-4764.035,-1902.204;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;233;-10316.64,1239.756;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;319;-10166.77,3061.092;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;241;-10236.43,2788.052;Inherit;True;Property;_GlitterMask;GlitterMask;11;0;Create;True;0;0;False;0;None;1686cf316c886694c9a59b1a8c0563f3;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;238;-10336.68,1034.552;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;170;-4648.032,-613.6217;Float;False;Property;_RimOffset;Rim Offset;9;0;Create;True;0;0;False;0;0.6;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;171;-4367.033,-726.6217;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;176;-5365.191,-2626.859;Inherit;False;828.4254;361.0605;Comment;4;192;184;182;180;Indirect Diffuse;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;175;-4606.582,-1897.174;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;244;-9904.678,2730.552;Inherit;True;Property;_Mask_Glitter;Mask_Glitter;6;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;243;-9908.678,3020.552;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;239;-10048.68,938.5519;Inherit;False;Constant;_Float3;Float 3;8;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;-4585.96,-1587.844;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;242;-10000.68,1098.552;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;177;-4207.033,-726.6217;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;180;-5032.131,-2480.884;Inherit;False;World;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;245;-9792.678,874.5519;Inherit;False;Constant;_Float6;Float 6;8;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;246;-9808.678,986.5519;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;318;-4728.236,592.2162;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;182;-4935.579,-2576.859;Float;False;Constant;_Float4;Float 4;20;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;250;-9568.678,2794.552;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.84;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-4369.43,-1898.289;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;187;-4396.084,-1584.86;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;316;-4703.799,294.5207;Inherit;False;Property;_TriplanarHardness;Triplanar Hardness;23;0;Create;True;0;0;False;0;0;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;249;-9598.678,2985.552;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.84;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;315;-4680.451,76.20287;Inherit;False;Property;_UVControl;UV Control;22;0;Create;True;0;0;False;0;1,1,0,0;0.1,0.1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;317;-4724.516,426.3887;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;184;-5061.196,-2380.799;Float;False;Property;_IndirectDiffuseContribution;Indirect Diffuse Contribution;3;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;185;-4565.171,-1456.06;Float;False;Property;_ShadowContribution;Shadow Contribution;4;0;Create;True;0;0;False;0;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;314;-4602.916,-136.6681;Inherit;True;Property;_TriplanarTex;Triplanar Tex;21;0;Create;True;0;0;False;0;None;cf6cc13252a926143bbd18a389b9f0c6;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;253;-9568.678,3674.552;Inherit;False;Property;_distanceGlitter;distance Glitter;17;0;Create;True;0;0;False;0;0;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;191;-4031.032,-726.6217;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;251;-9408.678,2938.552;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;256;-9840.678,3354.552;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;252;-9536.678,3802.552;Inherit;False;Property;_BiasDistance;BiasDistance;19;0;Create;True;0;0;False;0;0;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;254;-9440.678,2842.552;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;197;-4013.375,-1582.784;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;248;-9584.678,922.5519;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;192;-4720.765,-2500.544;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;257;-9936.678,3546.552;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;312;-4173.075,-9.530684;Inherit;False;TriPlanar_Function;-1;;4;e83a3664c53c7d04993ca572e15cd8f8;0;5;40;SAMPLER2D;0,0,0,0;False;35;FLOAT4;0,0,0,0;False;38;FLOAT;0;False;37;FLOAT3;0,0,0;False;39;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;196;-7356.478,-1496.144;Inherit;False;717.6841;295.7439;Comment;3;211;208;206;Light Falloff;0.9947262,1,0.6176471,1;0;0
Node;AmplifyShaderEditor.ColorNode;189;-3793.502,-1387.541;Float;False;Property;_BaseTint;Base Tint;0;1;[HDR];Create;True;0;0;False;0;1,1,1,0;1.414214,1.414214,1.414214,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightColorNode;188;-4093.681,-1897.761;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;194;-4143.032,-598.6217;Float;False;Property;_RimPower;Rim Power;8;0;Create;True;0;0;False;0;0.4;0.4;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;263;-9632.678,3418.552;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;42;-5204.465,2157.055;Inherit;False;Constant;_Vector0;Vector 0;11;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;40;-5213.931,1992.853;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;261;-9104.678,938.5519;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;264;-9280.678,3674.552;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;207;-3839.031,-726.6217;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;-3443.81,-1469.266;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;346;-5125.395,2438.256;Inherit;False;Property;_SnowOffset;SnowOffset;28;0;Create;True;0;0;False;0;0;-0.68;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;202;-3671.949,-1929.621;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;259;-9008.678,1498.552;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;262;-9296.678,2858.552;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;204;-3669.648,-1705.24;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;206;-7260.775,-1446.144;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;201;-3829.639,-565.2179;Float;False;Property;_RimColor;Rim Color;7;1;[HDR];Create;True;0;0;False;0;1,1,1,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;258;-9008.678,1738.552;Inherit;False;Property;_LightInfluence;Light Influence;14;0;Create;True;0;0;False;0;0;0.37;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;203;-3849.808,-805.8651;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;208;-7306.478,-1310.4;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;344;-5125.392,2343.283;Inherit;False;Property;_SnowHeight;SnowHeight;29;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;260;-9306.078,3062.815;Inherit;False;Property;_Hardness;Hardness;16;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;267;-8928.678,874.5519;Inherit;True;Property;_ToonRamp2;ToonRamp2;10;0;Create;True;0;0;False;0;-1;None;ea8738c3ec6ed684188ae5136f811377;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;268;-8752.678,1466.552;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;216;-3296.641,-1485.469;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;265;-9088.678,3418.552;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;213;-3565.807,-513.4397;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;43;-4976.96,2097.11;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;270;-9136.678,2906.552;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;219;-3412.802,-1816.496;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;266;-8976.678,1194.552;Inherit;False;Property;_ToonRampTint;ToonRamp Tint;12;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;269;-8688.678,1626.552;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;211;-7072.479,-1379.983;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;345;-4855.091,2339.631;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;-3554.904,-797.8481;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;220;-3111.746,-1690.298;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;271;-8880.678,3290.552;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;273;-8560.678,986.5519;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;274;-8544.678,1514.552;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;343;-4747.334,2129.599;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;328;-4807.399,2531.527;Inherit;False;Property;_SnowSoftEdge;SnowSoftEdge;26;0;Create;True;0;0;False;0;0;0.53;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;331;-4493.493,1953.922;Inherit;False;Property;_SnowNoiseScale;SnowNoiseScale;27;0;Create;True;0;0;False;0;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;272;-8960.678,2906.552;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;221;-3249.949,-804.7961;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;333;-4565.16,1820.015;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;321;-2546.642,-903.1062;Inherit;True;Property;_CurvatureMap;Curvature Map;24;0;Create;True;0;0;False;0;-1;None;82b63fe14d96b3845b743b2c4578f9d2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;324;-2047.437,-600.0173;Inherit;False;Property;_CurvatureTint;Curvature Tint;25;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;275;-8464.678,1370.552;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;276;-8160.678,1690.552;Inherit;False;Property;_SnowEmissive;Snow Emissive;20;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.8352941,0.8352941,0.8352941,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;330;-4221.907,1889.798;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;223;-2193.093,-1695.861;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;278;-8496.678,2762.552;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-4198.021,2282.24;Inherit;False;Property;_SnowDeposit;Snow Deposit;5;0;Create;True;0;0;False;0;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;327;-4474.287,2147.969;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;277;-8640.678,2570.552;Inherit;False;Property;_GlitterInt;Glitter Int;15;1;[HDR];Create;True;0;0;False;0;1,1,1,0;3.283019,3.283019,3.283019,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;326;-2084.893,-875.1311;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0.490566,0.490566,0.490566,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-3924.578,2091.63;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;279;-7904.679,1610.552;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;280;-8320.679,2490.552;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;322;-1770.443,-876.6046;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;320;-1493.993,-872.1728;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;325;-993.6155,-772.667;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;47;-3480.4,2142.117;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;282;-7552.679,1882.552;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;281;-8224.679,1978.552;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector4Node;231;-10688.68,3258.552;Inherit;False;Property;_UVControlScreenMask;UV Control Screen Mask;18;0;Create;True;0;0;False;0;0,0,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;236;-10256.68,3066.552;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;286;21.23923,291.1288;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;230;-10880.68,2986.552;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;235;-10320.68,3370.552;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;229;-11072.68,2954.552;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;234;-10448.68,3130.552;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;232;-10720.68,3034.552;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;225;-98.70847,-48.75784;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;240;-10144.68,3226.552;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;875.1489,11.6877;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Custom/CustomToonSnowDepositTriplanar;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;146;1;309;0
WireConnection;146;5;145;0
WireConnection;147;0;146;0
WireConnection;149;0;147;0
WireConnection;154;0;149;0
WireConnection;154;1;150;0
WireConnection;159;0;154;0
WireConnection;159;1;155;0
WireConnection;164;0;149;0
WireConnection;164;1;161;0
WireConnection;167;0;158;0
WireConnection;169;0;159;0
WireConnection;169;1;157;0
WireConnection;233;0;146;0
WireConnection;171;0;164;0
WireConnection;171;1;170;0
WireConnection;175;0;169;0
WireConnection;244;0;241;0
WireConnection;243;0;241;0
WireConnection;243;1;319;0
WireConnection;174;0;167;0
WireConnection;174;1;168;2
WireConnection;242;0;238;0
WireConnection;242;1;233;0
WireConnection;177;0;171;0
WireConnection;180;0;149;0
WireConnection;246;0;239;0
WireConnection;246;1;242;0
WireConnection;250;0;244;1
WireConnection;183;0;175;0
WireConnection;183;1;158;0
WireConnection;187;0;174;0
WireConnection;249;0;243;1
WireConnection;191;0;177;0
WireConnection;251;0;249;0
WireConnection;254;0;250;0
WireConnection;197;0;187;0
WireConnection;197;1;183;0
WireConnection;197;2;185;0
WireConnection;248;0;246;0
WireConnection;248;1;245;0
WireConnection;192;0;182;0
WireConnection;192;1;180;0
WireConnection;192;2;184;0
WireConnection;312;40;314;0
WireConnection;312;35;315;0
WireConnection;312;38;316;0
WireConnection;312;37;317;0
WireConnection;312;39;318;0
WireConnection;263;0;256;0
WireConnection;263;1;257;0
WireConnection;40;0;146;0
WireConnection;261;0;248;0
WireConnection;264;0;253;0
WireConnection;264;1;252;0
WireConnection;207;0;191;0
WireConnection;207;1;194;0
WireConnection;210;0;312;0
WireConnection;210;1;189;0
WireConnection;202;0;192;0
WireConnection;202;1;188;2
WireConnection;202;2;187;0
WireConnection;262;0;254;0
WireConnection;262;1;251;0
WireConnection;204;0;188;1
WireConnection;204;1;197;0
WireConnection;203;0;154;0
WireConnection;267;1;261;0
WireConnection;268;0;259;0
WireConnection;268;1;258;0
WireConnection;216;0;210;0
WireConnection;265;0;263;0
WireConnection;265;1;253;0
WireConnection;265;2;264;0
WireConnection;213;0;201;0
WireConnection;43;0;40;0
WireConnection;43;1;42;0
WireConnection;270;0;262;0
WireConnection;270;1;260;0
WireConnection;219;0;202;0
WireConnection;219;1;204;0
WireConnection;269;0;258;0
WireConnection;211;0;206;1
WireConnection;211;1;208;0
WireConnection;345;0;344;0
WireConnection;345;1;346;0
WireConnection;214;0;203;0
WireConnection;214;1;207;0
WireConnection;220;0;219;0
WireConnection;220;1;216;0
WireConnection;271;0;265;0
WireConnection;273;0;267;0
WireConnection;273;1;266;0
WireConnection;274;0;269;0
WireConnection;274;1;268;0
WireConnection;343;0;43;0
WireConnection;343;1;345;0
WireConnection;272;0;270;0
WireConnection;221;0;214;0
WireConnection;221;2;211;0
WireConnection;221;3;213;0
WireConnection;275;0;273;0
WireConnection;275;1;274;0
WireConnection;330;0;333;0
WireConnection;330;1;331;0
WireConnection;223;1;220;0
WireConnection;223;2;221;0
WireConnection;278;0;272;0
WireConnection;278;1;271;0
WireConnection;327;0;343;0
WireConnection;327;2;328;0
WireConnection;326;0;321;0
WireConnection;44;0;327;0
WireConnection;44;1;45;0
WireConnection;44;2;330;0
WireConnection;279;0;275;0
WireConnection;279;1;276;0
WireConnection;280;0;278;0
WireConnection;280;1;277;0
WireConnection;322;0;326;0
WireConnection;322;1;324;0
WireConnection;320;0;223;0
WireConnection;325;0;320;0
WireConnection;325;1;223;0
WireConnection;325;2;322;0
WireConnection;47;0;44;0
WireConnection;282;0;280;0
WireConnection;282;1;279;0
WireConnection;281;0;275;0
WireConnection;281;1;280;0
WireConnection;236;0;232;0
WireConnection;236;1;234;0
WireConnection;286;0;282;0
WireConnection;286;1;47;0
WireConnection;230;0;229;1
WireConnection;230;1;229;2
WireConnection;235;0;231;3
WireConnection;235;1;231;4
WireConnection;234;0;231;1
WireConnection;234;1;231;2
WireConnection;232;0;230;0
WireConnection;232;1;229;4
WireConnection;225;0;325;0
WireConnection;225;1;281;0
WireConnection;225;2;47;0
WireConnection;240;0;236;0
WireConnection;240;1;235;0
WireConnection;0;2;286;0
WireConnection;0;13;225;0
ASEEND*/
//CHKSM=B30BB680BD9090393E354EE2ADC83B9435101D19