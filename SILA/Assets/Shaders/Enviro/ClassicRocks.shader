// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/ClassicRocks"
{
	Properties
	{
		_AlbedoColor("Albedo Color", Color) = (0.3490566,0.3490566,0.3490566,0)
		_CurvatureTex("Curvature Tex", 2D) = "white" {}
		_EdgeColor("Edge Color", Color) = (0.6132076,0.6132076,0.6132076,0)
		_EdgeThreshold("Edge Threshold", Range( 0 , 1)) = 1
		_SpecularScale("Specular Scale", Float) = 1
		_SpecularInt("Specular Int", Float) = 1
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_AOTex("AO Tex", 2D) = "white" {}
		_SnowHeight("SnowHeight", Range( 0 , 1)) = 2
		_SnowDeposit("Snow Deposit", Float) = 0
		_SnowColor("Snow Color", Color) = (0.7830189,0.7830189,0.7830189,0)
		_SnowSmoothness("Snow Smoothness", Range( 0 , 1)) = 0
		[Normal]_NormalTex("Normal Tex", 2D) = "bump" {}
		_SnowEmission("Snow Emission", Float) = 0
		_SnowNormalTex("Snow Normal Tex", 2D) = "bump" {}
		_NormalSnowInt("Normal Snow Int", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
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
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		uniform sampler2D _NormalTex;
		uniform float4 _NormalTex_ST;
		uniform float _NormalSnowInt;
		uniform sampler2D _SnowNormalTex;
		uniform float4 _SnowNormalTex_ST;
		uniform float _SnowDeposit;
		uniform float _SnowHeight;
		uniform sampler2D _AOTex;
		uniform float4 _AOTex_ST;
		uniform float4 _AlbedoColor;
		uniform float _EdgeThreshold;
		uniform sampler2D _CurvatureTex;
		uniform float4 _CurvatureTex_ST;
		uniform float4 _EdgeColor;
		uniform float4 _SnowColor;
		uniform float _SpecularInt;
		uniform float _SpecularScale;
		uniform float _SnowEmission;
		uniform float _Smoothness;
		uniform float _SnowSmoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalTex = i.uv_texcoord * _NormalTex_ST.xy + _NormalTex_ST.zw;
			float3 tex2DNode65 = UnpackScaleNormal( tex2D( _NormalTex, uv_NormalTex ), 1.0 );
			float2 uv_SnowNormalTex = i.uv_texcoord * _SnowNormalTex_ST.xy + _SnowNormalTex_ST.zw;
			float dotResult43 = dot( (WorldNormalVector( i , tex2DNode65 )) , float3(0,1,0) );
			float temp_output_44_0 = ( dotResult43 * _SnowDeposit );
			float2 uv_AOTex = i.uv_texcoord * _AOTex_ST.xy + _AOTex_ST.zw;
			float temp_output_47_0 = saturate( ( temp_output_44_0 + ( ( ( 1.0 - ( ( 1.0 - ( _SnowHeight + 0.3 ) ) * 70.0 ) ) + 6.0 ) * tex2D( _AOTex, uv_AOTex ).r ) ) );
			float3 lerpResult85 = lerp( tex2DNode65 , UnpackScaleNormal( tex2D( _SnowNormalTex, uv_SnowNormalTex ), _NormalSnowInt ) , temp_output_47_0);
			o.Normal = lerpResult85;
			float2 uv_CurvatureTex = i.uv_texcoord * _CurvatureTex_ST.xy + _CurvatureTex_ST.zw;
			float clampResult70 = clamp( tex2D( _CurvatureTex, uv_CurvatureTex ).r , 0.53 , 1.0 );
			float smoothstepResult5 = smoothstep( ( 1.0 - _EdgeThreshold ) , 1.0 , clampResult70);
			float4 lerpResult48 = lerp( ( _AlbedoColor + ( saturate( smoothstepResult5 ) * _EdgeColor ) ) , _SnowColor , temp_output_47_0);
			o.Albedo = lerpResult48.rgb;
			float3 normalizeResult20 = normalize( (WorldNormalVector( i , lerpResult85 )) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult18 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float dotResult19 = dot( normalizeResult20 , normalizeResult18 );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			o.Emission = ( ( ( _SpecularInt * pow( saturate( dotResult19 ) , _SpecularScale ) ) * ase_lightColor ) + ( saturate( temp_output_47_0 ) * _SnowEmission ) ).rgb;
			float lerpResult57 = lerp( _Smoothness , _SnowSmoothness , saturate( temp_output_44_0 ));
			o.Smoothness = lerpResult57;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
1920;0;1280;659;4612.196;137.2389;1.380332;True;False
Node;AmplifyShaderEditor.RangedFloatNode;84;-2656.226,1856.919;Inherit;False;Constant;_Float2;Float 2;14;0;Create;True;0;0;False;0;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-2831.183,1673.463;Inherit;False;Property;_SnowHeight;SnowHeight;8;0;Create;True;0;0;False;0;2;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;-2460.226,1723.919;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;79;-2268.964,1716.954;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-3995.285,111.8189;Inherit;False;Constant;_NormalInt;Normal Int;14;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-2243.111,1851.09;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;False;0;70;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;65;-3793.61,-152.7899;Inherit;True;Property;_NormalTex;Normal Tex;12;1;[Normal];Create;True;0;0;False;0;-1;None;148864b2a1816c94f8d8df7df892589b;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-2013.529,1691.526;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;42;-1520.974,918.7651;Inherit;False;Constant;_Vector0;Vector 0;11;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;72;-1782.884,1798.77;Inherit;False;Constant;_Float0;Float 0;14;0;Create;True;0;0;False;0;6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;78;-1812.505,1700.472;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;40;-1530.439,754.5637;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;45;-1264.075,995.9982;Inherit;False;Property;_SnowDeposit;Snow Deposit;9;0;Create;True;0;0;False;0;0;47.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;31;-1685.783,1888.252;Inherit;True;Property;_AOTex;AO Tex;7;0;Create;True;0;0;False;0;-1;84b09f278b59aa14fa3eba97a0d0cde9;1eca7ca6420dc99478f43dc124c8370b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;43;-1293.469,858.8199;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-1592.901,1700.098;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1071.045,859.742;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1306.393,1692.634;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-4071.105,387.2874;Inherit;False;Property;_NormalSnowInt;Normal Snow Int;15;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-784.0616,1212.135;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;47;-594.5892,1218.13;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;86;-3803.775,270.3135;Inherit;True;Property;_SnowNormalTex;Snow Normal Tex;14;0;Create;True;0;0;False;0;-1;None;3c4991510198ff64caafc97788a8cf44;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;85;-3313.969,-109.1773;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;16;-3177.813,582.9574;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;15;-3132.257,341.8923;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;60;-2987.109,120.3194;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-2877.906,520.3185;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2056.884,-448.4186;Inherit;False;Property;_EdgeThreshold;Edge Threshold;3;0;Create;True;0;0;False;0;1;0.474;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;18;-2707.073,512.726;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;4;-2177.884,-845.4186;Inherit;True;Property;_CurvatureTex;Curvature Tex;1;0;Create;True;0;0;False;0;-1;3a4dfb4be8fedd84cb3621a660b5d4d9;6663670eeab43b745b7fb8da11445442;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;20;-2657.721,229.9013;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;19;-2443.229,311.5218;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;6;-1772.884,-518.4185;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;70;-1831.374,-776.2842;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.53;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;5;-1575.884,-623.4185;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;21;-2193.43,322.117;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-2214.784,575.9184;Inherit;False;Property;_SpecularScale;Specular Scale;4;0;Create;True;0;0;False;0;1;2.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-1338.884,-404.4186;Inherit;False;Property;_EdgeColor;Edge Color;2;0;Create;True;0;0;False;0;0.6132076,0.6132076,0.6132076,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;22;-1899.116,339.6739;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;8;-1325.884,-580.4185;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1779.497,211.4948;Inherit;False;Property;_SpecularInt;Specular Int;5;0;Create;True;0;0;False;0;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;30;-1463.108,498.5942;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;69;-720.3632,371.5304;Inherit;False;Property;_SnowEmission;Snow Emission;13;0;Create;True;0;0;False;0;0;0.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;66;-691.7308,573.5166;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-1158.263,-769.1295;Inherit;False;Property;_AlbedoColor;Albedo Color;0;0;Create;True;0;0;False;0;0.3490566,0.3490566,0.3490566,0;0.2666667,0.4117647,0.5411765,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1132.884,-527.4185;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1553.464,263.2943;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;50;-477.9971,-192.4818;Inherit;False;Property;_SnowColor;Snow Color;10;0;Create;True;0;0;False;0;0.7830189,0.7830189,0.7830189,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;25.04001,155.746;Inherit;False;Property;_Smoothness;Smoothness;6;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1;-856.6105,-552.2275;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1216.769,232.6855;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-42.5248,238.6029;Inherit;False;Property;_SnowSmoothness;Snow Smoothness;11;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;82;-74.87488,428.6329;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-497.1897,314.3979;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;57;409.2614,158.5128;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;-352.7538,152.8149;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;48;44.0008,-318.7675;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;799.6265,-81.26285;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/ClassicRocks;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;83;0;33;0
WireConnection;83;1;84;0
WireConnection;79;0;83;0
WireConnection;65;5;63;0
WireConnection;75;0;79;0
WireConnection;75;1;74;0
WireConnection;78;0;75;0
WireConnection;40;0;65;0
WireConnection;43;0;40;0
WireConnection;43;1;42;0
WireConnection;76;0;78;0
WireConnection;76;1;72;0
WireConnection;44;0;43;0
WireConnection;44;1;45;0
WireConnection;32;0;76;0
WireConnection;32;1;31;1
WireConnection;39;0;44;0
WireConnection;39;1;32;0
WireConnection;47;0;39;0
WireConnection;86;5;87;0
WireConnection;85;0;65;0
WireConnection;85;1;86;0
WireConnection;85;2;47;0
WireConnection;60;0;85;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;18;0;17;0
WireConnection;20;0;60;0
WireConnection;19;0;20;0
WireConnection;19;1;18;0
WireConnection;6;0;7;0
WireConnection;70;0;4;1
WireConnection;5;0;70;0
WireConnection;5;1;6;0
WireConnection;21;0;19;0
WireConnection;22;0;21;0
WireConnection;22;1;23;0
WireConnection;8;0;5;0
WireConnection;66;0;47;0
WireConnection;9;0;8;0
WireConnection;9;1;10;0
WireConnection;24;0;25;0
WireConnection;24;1;22;0
WireConnection;1;0;2;0
WireConnection;1;1;9;0
WireConnection;26;0;24;0
WireConnection;26;1;30;0
WireConnection;82;0;44;0
WireConnection;68;0;66;0
WireConnection;68;1;69;0
WireConnection;57;0;29;0
WireConnection;57;1;58;0
WireConnection;57;2;82;0
WireConnection;67;0;26;0
WireConnection;67;1;68;0
WireConnection;48;0;1;0
WireConnection;48;1;50;0
WireConnection;48;2;47;0
WireConnection;0;0;48;0
WireConnection;0;1;85;0
WireConnection;0;2;67;0
WireConnection;0;4;57;0
ASEEND*/
//CHKSM=427D51355C1164B104A225616A9A4D9C639DD440