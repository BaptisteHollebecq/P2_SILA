// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Ice_Stylized_Zaxis"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 1
		[HDR]_SnowColor("Snow Color", Color) = (0,0,0,0)
		_Surfacecolor("Surface color", Color) = (0.4111784,0.4943226,0.5283019,0)
		[HDR]_Fresnel("Fresnel", Color) = (1,1,1,0)
		_Specular("Specular", Float) = 50
		_SpecularInt("Specular Int", Float) = 1
		[HDR]_Deepcolor("Deep color", Color) = (1,1,1,0)
		_Noise01("Noise01", 2D) = "white" {}
		_AO("AO", 2D) = "white" {}
		_HeightScale("HeightScale", Range( -2 , 2)) = 0
		_Heightmuliplier("Height muliplier", Range( -2 , 2)) = -0.2482721
		_Normal("Normal", 2D) = "bump" {}
		_Normalscale("Normal scale", Range( 0 , 3)) = 0.25
		_SnowCavity("Snow Cavity", Float) = 0.1
		_Snowdeposit("Snow deposit", Float) = 0
		_MeltingNormal("Melting Normal", 2D) = "bump" {}
		[HDR]_MeltingEmissionColor("Melting Emission Color", Color) = (0,0,0,0)
		_Melting("Melting", Range( 0 , 1)) = 0
		_Param_Lenght("Param_Lenght", Float) = -0.03
		_HeightLimit("Height Limit", Float) = 4.56
		_MeltingColorLimit("Melting Color Limit", Float) = 0.2
		[Header(Translucency)]
		_Translucency("Strength", Range( 0 , 50)) = 1
		_TransNormalDistortion("Normal Distortion", Range( 0 , 1)) = 0.1
		_TransScattering("Scaterring Falloff", Range( 1 , 50)) = 2
		_TransDirect("Direct", Range( 0 , 1)) = 1
		_TransAmbient("Ambient", Range( 0 , 1)) = 0.2
		_TransShadow("Shadow", Range( 0 , 1)) = 0.9
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
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

		struct SurfaceOutputStandardCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			half3 Translucency;
		};

		uniform float _Melting;
		uniform float _HeightLimit;
		uniform float _Param_Lenght;
		uniform float4 _Deepcolor;
		uniform float4 _Surfacecolor;
		uniform sampler2D _Noise01;
		uniform float _Heightmuliplier;
		uniform sampler2D _AO;
		uniform float4 _AO_ST;
		uniform float _HeightScale;
		uniform float _Normalscale;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float4 _SnowColor;
		uniform sampler2D _MeltingNormal;
		uniform float4 _MeltingNormal_ST;
		uniform float _MeltingColorLimit;
		uniform float _Snowdeposit;
		uniform float _SnowCavity;
		uniform float4 _Fresnel;
		uniform float _SpecularInt;
		uniform float _Specular;
		uniform float4 _MeltingEmissionColor;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;
		uniform float _TessValue;

		float4 tessFunction( )
		{
			return _TessValue;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float myVarName292 = ( ( ( 1.0 - _Melting ) * _HeightLimit ) + _Param_Lenght );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 appendResult262 = (float4(0.0 , 0.0 , ( myVarName292 - ase_vertex3Pos.z ) , 0.0));
			float smoothstepResult261 = smoothstep( ( myVarName292 - 0.0 ) , ( myVarName292 + 0.0 ) , ase_vertex3Pos.z);
			v.vertex.xyz += ( appendResult262 * smoothstepResult261 ).xyz;
		}

		inline half4 LightingStandardCustom(SurfaceOutputStandardCustom s, half3 viewDir, UnityGI gi )
		{
			#if !DIRECTIONAL
			float3 lightAtten = gi.light.color;
			#else
			float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, _TransShadow );
			#endif
			half3 lightDir = gi.light.dir + s.Normal * _TransNormalDistortion;
			half transVdotL = pow( saturate( dot( viewDir, -lightDir ) ), _TransScattering );
			half3 translucency = lightAtten * (transVdotL * _TransDirect + gi.indirect.diffuse * _TransAmbient) * s.Translucency;
			half4 c = half4( s.Albedo * translucency * _Translucency, 0 );

			SurfaceOutputStandard r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Metallic = s.Metallic;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandard (r, viewDir, gi) + c;
		}

		inline void LightingStandardCustom_GI(SurfaceOutputStandardCustom s, UnityGIInput data, inout UnityGI gi )
		{
			#if defined(UNITY_PASS_DEFERRED) && UNITY_ENABLE_REFLECTION_BUFFERS
				gi = UnityGlobalIllumination(data, s.Occlusion, s.Normal);
			#else
				UNITY_GLOSSY_ENV_FROM_SURFACE( g, s, data );
				gi = UnityGlobalIllumination( data, s.Occlusion, s.Normal, g );
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandardCustom o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_AO = i.uv_texcoord * _AO_ST.xy + _AO_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float2 appendResult21 = (float2(ase_worldViewDir.x , ase_worldViewDir.y));
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 tex2DNode19 = UnpackScaleNormal( tex2D( _Normal, uv_Normal ), _Normalscale );
			float2 appendResult22 = (float2(tex2DNode19.r , tex2DNode19.g));
			float3 appendResult24 = (float3(( appendResult21 + appendResult22 ) , ase_worldViewDir.z));
			float3 normalizeResult25 = normalize( appendResult24 );
			float2 paralaxOffset15 = ParallaxOffset( ( _Heightmuliplier * tex2D( _AO, uv_AO ).g ) , _HeightScale , normalizeResult25 );
			float4 lerpResult6 = lerp( _Deepcolor , _Surfacecolor , tex2D( _Noise01, ( i.uv_texcoord + paralaxOffset15 ) ).g);
			float4 temp_output_8_0 = saturate( lerpResult6 );
			float2 uv_MeltingNormal = i.uv_texcoord * _MeltingNormal_ST.xy + _MeltingNormal_ST.zw;
			float myVarName292 = ( ( ( 1.0 - _Melting ) * _HeightLimit ) + _Param_Lenght );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float smoothstepResult265 = smoothstep( ( myVarName292 - _MeltingColorLimit ) , ( myVarName292 + _MeltingColorLimit ) , ase_vertex3Pos.z);
			float4 lerpResult340 = lerp( float4( tex2DNode19 , 0.0 ) , tex2D( _MeltingNormal, uv_MeltingNormal ) , smoothstepResult265);
			float dotResult372 = dot( (WorldNormalVector( i , lerpResult340.rgb )) , float3(0,1,0) );
			float temp_output_423_0 = saturate( ( _Melting * 2.0 ) );
			float4 tex2DNode61 = tex2D( _AO, uv_AO );
			float4 temp_cast_2 = (temp_output_423_0).xxxx;
			float4 temp_cast_3 = (( temp_output_423_0 * 0.5 )).xxxx;
			float4 temp_output_428_0 = ( saturate( ( ( ( dotResult372 * _Snowdeposit ) - temp_output_423_0 ) + ( ( _SnowCavity * tex2DNode61 ) - temp_cast_2 ) ) ) - temp_cast_3 );
			float4 lerpResult349 = lerp( temp_output_8_0 , _SnowColor , temp_output_428_0);
			o.Albedo = lerpResult349.rgb;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_tangentToWorldFast = float3x3(ase_worldTangent.x,ase_worldBitangent.x,ase_worldNormal.x,ase_worldTangent.y,ase_worldBitangent.y,ase_worldNormal.y,ase_worldTangent.z,ase_worldBitangent.z,ase_worldNormal.z);
			float fresnelNdotV64 = dot( mul(ase_tangentToWorldFast,lerpResult340.rgb), ase_worldViewDir );
			float fresnelNode64 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV64, 5.0 ) );
			float3 normalizeResult75 = normalize( (WorldNormalVector( i , lerpResult340.rgb )) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult97 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float dotResult76 = dot( normalizeResult75 , normalizeResult97 );
			float clampResult86 = clamp( dotResult76 , 0.0 , 1.0 );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 lerpResult299 = lerp( ( ( fresnelNode64 * _Fresnel ) + float4( ( ( _SpecularInt * pow( clampResult86 , _Specular ) ) * ase_lightColor.rgb ) , 0.0 ) ) , _MeltingEmissionColor , saturate( smoothstepResult265 ));
			o.Emission = lerpResult299.rgb;
			o.Occlusion = tex2DNode61.r;
			float4 temp_cast_10 = (( temp_output_423_0 * 0.5 )).xxxx;
			float4 lerpResult356 = lerp( temp_output_8_0 , _SnowColor , temp_output_428_0);
			o.Translucency = lerpResult356.rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustom keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 

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
				vertexDataFunc( v );
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
				SurfaceOutputStandardCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardCustom, o )
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
305;73;792;632;5506.708;-2668.81;1.367394;True;False
Node;AmplifyShaderEditor.CommentaryNode;391;-5487.749,2871.592;Inherit;False;954.1831;343.7849;0 -> 1 à -.03 -> 0,22;6;417;387;388;389;390;244;Melting Parameter;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;244;-5465.516,2972.043;Inherit;False;Property;_Melting;Melting;21;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;417;-5154.377,2964.19;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;390;-5116.462,3106.999;Inherit;False;Property;_HeightLimit;Height Limit;23;0;Create;True;0;0;False;0;4.56;0.88;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;388;-4902.381,3126.011;Inherit;False;Property;_Param_Lenght;Param_Lenght;22;0;Create;True;0;0;False;0;-0.03;-0.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;389;-4902.755,2928.214;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;301;-4440.248,2531.071;Inherit;False;1081.841;886.6306;;10;246;292;276;253;270;259;257;278;265;261;Melting Limits;0,0.8927178,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;387;-4703.02,2986.332;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;26;-4062.393,99.71986;Inherit;False;1558.738;471.7725;Comment;8;20;23;18;22;21;24;25;19;Adjusted viewdir;1,0,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;292;-4369.675,2990.111;Inherit;False;myVarName;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;276;-4320.455,3214.58;Inherit;False;Property;_MeltingColorLimit;Melting Color Limit;24;0;Create;True;0;0;False;0;0.2;0.44;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-4012.392,371.7875;Inherit;False;Property;_Normalscale;Normal scale;16;0;Create;True;0;0;False;0;0.25;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;246;-4408.721,2591.287;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;270;-3818.158,3284.701;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;278;-3824.933,3126.595;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;20;-3504.204,149.7198;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;19;-3685.18,331.1309;Inherit;True;Property;_Normal;Normal;15;0;Create;True;0;0;False;0;-1;None;b6e80cc11f1918a47a91b0085d74fada;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;341;-3823.274,799.7783;Inherit;True;Property;_MeltingNormal;Melting Normal;19;0;Create;True;0;0;False;0;-1;None;None;True;0;False;bump;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;98;-3077.825,1039.925;Inherit;False;1600.682;765.8125;Comment;12;73;96;94;74;75;97;76;86;89;77;88;78;Specular;1,0.1462264,0.8905144,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;22;-3301.463,414.4662;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-3224.834,163.9251;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;265;-3630.685,3178.545;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-3030.693,189.9683;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;340;-3413.894,788.4506;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;17;-2798.179,-560.6173;Inherit;False;1128.283;507.8719;Comment;7;12;13;14;15;16;10;11;Parallax mapping;1,0.7389395,0,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;73;-3027.825,1626.739;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;96;-2998.247,1448.845;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;12;-2748.179,-403.0483;Inherit;True;Property;_AO;AO;12;0;Create;True;0;0;False;0;-1;None;4f1d207702904b649add98781a4d6928;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;74;-2900.173,1202.203;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;444;-764.5244,241.199;Inherit;False;1616.367;339.4286;;8;436;435;428;375;379;423;419;420;Snow Melting;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-2860.228,192.3359;Inherit;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2726.279,-510.6174;Inherit;False;Property;_Heightmuliplier;Height muliplier;14;0;Create;True;0;0;False;0;-0.2482721;2;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;442;-368.1601,-219.5293;Inherit;False;817.7429;405.5242;;6;371;370;377;372;376;429;Snow deposit;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;440;-5057.839,3482.125;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;94;-2764.983,1558.997;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;75;-2631.979,1252.361;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-2390.628,-461.4238;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;25;-2688.65,184.5093;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;420;-702.1672,353.1458;Inherit;False;Constant;_Float2;Float 2;19;0;Create;True;0;0;False;0;2;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;443;-376.5854,654.3093;Inherit;False;924.4448;478.8614;;4;61;365;426;366;Snow Cavity;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;371;-318.16,1.994907;Inherit;False;Constant;_Vector0;Vector 0;18;0;Create;True;0;0;False;0;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;11;-2699.027,-166.2295;Inherit;False;Property;_HeightScale;HeightScale;13;0;Create;True;0;0;False;0;0;0.15;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;441;-3056.256,3425.344;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;370;-318.1601,-169.5293;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;97;-2645.112,1487.722;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;366;-135.5135,713.0781;Inherit;False;Property;_SnowCavity;Snow Cavity;17;0;Create;True;0;0;False;0;0.1;-10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxOffsetHlpNode;15;-2142.531,-269.2709;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-2140.099,-485.7467;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;377;-60.0081,49.92525;Inherit;False;Property;_Snowdeposit;Snow deposit;18;0;Create;True;0;0;False;0;0;33.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;76;-2438.503,1364.278;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;61;-326.5854,903.1707;Inherit;True;Property;_AmbientOcclusion;Ambient Occlusion;12;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Instance;12;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;419;-475.0985,350.4753;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;372;-82.0643,-75.76205;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;86;-2274.619,1311.313;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;376;125.2261,-67.77952;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;365;115.3019,717.9155;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;423;-279.5874,354.6151;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;9;-1457.86,-867.0738;Inherit;False;861.4401;736.4835;Comment;5;8;6;3;2;5;Main Color;0.1273585,1,0.9477144,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;338;-3904.989,1993.15;Inherit;False;837.8975;314.239;;4;250;258;262;274;Melting Displacement;0,0.4082808,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;253;-4286.974,2789.911;Inherit;False;Constant;_Float9;Float 9;18;0;Create;True;0;0;False;0;0;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-1823.898,-356.8344;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-2245.625,1545.206;Inherit;False;Property;_Specular;Specular;8;0;Create;True;0;0;False;0;50;46.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;71;-2099.887,484.4883;Inherit;False;615.9517;484.543;Comment;3;67;65;64;Fresnel;0,0,0,1;0;0
Node;AmplifyShaderEditor.PowerNode;77;-1916.065,1246.489;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-1329.708,-817.0738;Inherit;False;Property;_Deepcolor;Deep color;10;1;[HDR];Create;True;0;0;False;0;1,1,1,0;0,1.011765,1.780392,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;250;-3854.989,2149.142;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;429;275.5829,-58.41042;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1922.458,1118.534;Inherit;False;Property;_SpecularInt;Specular Int;9;0;Create;True;0;0;False;0;1;1.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;258;-3724.281,2070.923;Inherit;False;Constant;_Float10;Float 10;16;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;426;334.0975,713.3461;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;5;-1407.86,-373.4475;Inherit;True;Property;_Noise01;Noise01;11;0;Create;True;0;0;False;0;-1;None;4f1d207702904b649add98781a4d6928;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;257;-3782.018,2835.223;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;259;-3795.57,2731.326;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-1388.331,-593.0122;Inherit;False;Property;_Surfacecolor;Surface color;6;0;Create;True;0;0;False;0;0.4111784,0.4943226,0.5283019,0;0,0.5368862,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;67;-1987.969,771.2018;Inherit;False;Property;_Fresnel;Fresnel;7;1;[HDR];Create;True;0;0;False;0;1,1,1,0;0,27.31876,27.60784,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-1672.891,1096.477;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;262;-3480.992,2043.149;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FresnelNode;64;-2049.887,534.4884;Inherit;True;Standard;TangentNormal;ViewDir;True;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;436;346.0451,465.6275;Inherit;False;Constant;_Float3;Float 3;19;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;457;-1429.866,1225.991;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;379;346.9797,314.6782;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;261;-3558.407,2726.807;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;6;-1012.504,-412.5234;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;274;-3264.526,2054.387;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-1660.235,590.5526;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;8;-760.7145,-408.1335;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;300;-577.2941,1822.057;Inherit;False;327.0181;279.455;Comment;1;281;Melting Emission;0,1,0.02043915,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;435;525.0037,396.3115;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;375;511.3395,314.0838;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;456;-1393.01,1041.713;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;445;1230.374,-405.3765;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;281;-527.2939,1898.097;Inherit;False;Property;_MeltingEmissionColor;Melting Emission Color;20;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.3867548,2.623205,3.564869,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;438;-1663.123,1984.457;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;453;-904.3123,2254.326;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;347;1111.547,18.87025;Inherit;False;Property;_SnowColor;Snow Color;5;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1.498039,1.498039,1.498039,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;81;-1214.289,900.7476;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;428;681.7424,291.1989;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;356;1543.984,394.4034;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;299;9.376459,1887.807;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;349;1392.224,-480.9261;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;439;-666.1636,1356.416;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2039.473,357.7273;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Custom/Ice_Stylized_Zaxis;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;1;1;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;25;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;385;2408.583,456.6282;Inherit;False;721.9266;100;Pour adapter : changer axes y -> z   modifier le float melting  modifier melting limits;0;Comment;1,1,1,1;0;0
WireConnection;417;0;244;0
WireConnection;389;0;417;0
WireConnection;389;1;390;0
WireConnection;387;0;389;0
WireConnection;387;1;388;0
WireConnection;292;0;387;0
WireConnection;270;0;292;0
WireConnection;270;1;276;0
WireConnection;278;0;292;0
WireConnection;278;1;276;0
WireConnection;19;5;18;0
WireConnection;22;0;19;1
WireConnection;22;1;19;2
WireConnection;21;0;20;1
WireConnection;21;1;20;2
WireConnection;265;0;246;3
WireConnection;265;1;278;0
WireConnection;265;2;270;0
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;340;0;19;0
WireConnection;340;1;341;0
WireConnection;340;2;265;0
WireConnection;74;0;340;0
WireConnection;24;0;23;0
WireConnection;24;2;20;3
WireConnection;440;0;244;0
WireConnection;94;0;96;0
WireConnection;94;1;73;0
WireConnection;75;0;74;0
WireConnection;13;0;10;0
WireConnection;13;1;12;2
WireConnection;25;0;24;0
WireConnection;441;0;440;0
WireConnection;370;0;340;0
WireConnection;97;0;94;0
WireConnection;15;0;13;0
WireConnection;15;1;11;0
WireConnection;15;2;25;0
WireConnection;76;0;75;0
WireConnection;76;1;97;0
WireConnection;419;0;441;0
WireConnection;419;1;420;0
WireConnection;372;0;370;0
WireConnection;372;1;371;0
WireConnection;86;0;76;0
WireConnection;376;0;372;0
WireConnection;376;1;377;0
WireConnection;365;0;366;0
WireConnection;365;1;61;0
WireConnection;423;0;419;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;77;0;86;0
WireConnection;77;1;78;0
WireConnection;250;0;292;0
WireConnection;250;1;246;3
WireConnection;429;0;376;0
WireConnection;429;1;423;0
WireConnection;426;0;365;0
WireConnection;426;1;423;0
WireConnection;5;1;16;0
WireConnection;257;0;292;0
WireConnection;257;1;253;0
WireConnection;259;0;292;0
WireConnection;259;1;253;0
WireConnection;88;0;89;0
WireConnection;88;1;77;0
WireConnection;262;0;258;0
WireConnection;262;1;258;0
WireConnection;262;2;250;0
WireConnection;262;3;258;0
WireConnection;64;0;340;0
WireConnection;379;0;429;0
WireConnection;379;1;426;0
WireConnection;261;0;246;3
WireConnection;261;1;259;0
WireConnection;261;2;257;0
WireConnection;6;0;2;0
WireConnection;6;1;3;0
WireConnection;6;2;5;2
WireConnection;274;0;262;0
WireConnection;274;1;261;0
WireConnection;65;0;64;0
WireConnection;65;1;67;0
WireConnection;8;0;6;0
WireConnection;435;0;423;0
WireConnection;435;1;436;0
WireConnection;375;0;379;0
WireConnection;456;0;88;0
WireConnection;456;1;457;1
WireConnection;445;0;8;0
WireConnection;438;0;274;0
WireConnection;453;0;265;0
WireConnection;81;0;65;0
WireConnection;81;1;456;0
WireConnection;428;0;375;0
WireConnection;428;1;435;0
WireConnection;356;0;445;0
WireConnection;356;1;347;0
WireConnection;356;2;428;0
WireConnection;299;0;81;0
WireConnection;299;1;281;0
WireConnection;299;2;453;0
WireConnection;349;0;8;0
WireConnection;349;1;347;0
WireConnection;349;2;428;0
WireConnection;439;0;438;0
WireConnection;0;0;349;0
WireConnection;0;2;299;0
WireConnection;0;5;61;0
WireConnection;0;7;356;0
WireConnection;0;11;439;0
ASEEND*/
//CHKSM=7BAFE2BCB7BD503AC316DADBF8B5C850866312F1