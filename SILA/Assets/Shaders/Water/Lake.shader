// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Lake"
{
	Properties
	{
		[Header(Translucency)]
		_Translucency("Strength", Range( 0 , 50)) = 1
		_TransNormalDistortion("Normal Distortion", Range( 0 , 1)) = 0.1
		_TransScattering("Scaterring Falloff", Range( 1 , 50)) = 2
		_TransDirect("Direct", Range( 0 , 1)) = 1
		_TransAmbient("Ambient", Range( 0 , 1)) = 0.2
		_TransShadow("Shadow", Range( 0 , 1)) = 0.9
		_Glaciation("Glaciation", Range( 0 , 1)) = -0.001
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		_IceNormal("Ice Normal", 2D) = "bump" {}
		_ParallaxOffset("Parallax Offset", Float) = -1.58
		[HDR]_Color1("Color 1", Color) = (0,2.682353,4,0)
		[NoScaleOffset]_Texture0("Texture 0", 2D) = "white" {}
		[HDR]_Color0("Color 0", Color) = (0,0,0,0)
		[HDR]_Color2("Color 2", Color) = (0,0,0,0)
		_ScaleOffSetIce("Scale OffSet Ice", Vector) = (0,0,0,0)
		_WindDirection("Wind Direction", Vector) = (1,0,0,0)
		_WaveSpeed("Wave Speed", Float) = 1
		_Tesselation("Tesselation", Float) = 8
		_Vector0("Vector 0", Vector) = (1,1,0,0)
		_SmallWaveTile("Small Wave Tile", Float) = 0
		_Float1("Float 1", Range( 0 , 1)) = 0
		_Float0("Float 0", Range( 0 , 1)) = 0
		[HDR]_Color3("Color 3", Color) = (0,0,0,0)
		_Thresholdtemp("Thresholdtemp", Float) = 0
		[HDR]_Water1("Water 1", Color) = (0,0,0,0)
		[HDR]_Water2("Water 2", Color) = (0,0,0,0)
		_WaterNormal("Water Normal", 2D) = "bump" {}
		_yes("yes", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Tessellation.cginc"
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
			float4 screenPos;
			half3 viewDir;
			INTERNAL_DATA
			float3 worldPos;
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
			half3 Transmission;
			half3 Translucency;
		};

		uniform sampler2D _IceNormal;
		uniform half2 _ScaleOffSetIce;
		uniform half _yes;
		uniform sampler2D _WaterNormal;
		uniform float4 _WaterNormal_ST;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Glaciation;
		uniform sampler2D _Texture0;
		uniform half _ParallaxOffset;
		uniform half4 _Color0;
		uniform sampler2D _Albedo;
		uniform half4 _Color1;
		uniform half4 _Color2;
		uniform half4 _Water2;
		uniform half4 _Water1;
		uniform half _WaveSpeed;
		uniform half2 _WindDirection;
		uniform half2 _Vector0;
		uniform half _SmallWaveTile;
		uniform half4 _Color3;
		uniform half _Float1;
		uniform half _Float0;
		uniform half _Thresholdtemp;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;
		uniform half _Tesselation;


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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			half4 temp_cast_0 = (_Tesselation).xxxx;
			return temp_cast_0;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			v.vertex.xyz += ( float3( 0,0,0 ) * half3(0,1,0) );
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

			half3 transmission = max(0 , -dot(s.Normal, gi.light.dir)) * gi.light.color * s.Transmission;
			half4 d = half4(s.Albedo * transmission , 0);

			SurfaceOutputStandard r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Metallic = s.Metallic;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandard (r, viewDir, gi) + c + d;
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
			float2 uv_TexCoord207 = i.uv_texcoord * _ScaleOffSetIce;
			float2 uv0_WaterNormal = i.uv_texcoord * _WaterNormal_ST.xy + _WaterNormal_ST.zw;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			half clampDepth4 = Linear01Depth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPos.xy ));
			half clampResult121 = clamp( ( abs( ( ase_screenPos.y - clampDepth4 ) ) * ( ( _Glaciation * -1.0 ) + 1.0 ) ) , 0.0 , 1.0 );
			half3 lerpResult274 = lerp( UnpackNormal( tex2D( _IceNormal, uv_TexCoord207 ) ) , UnpackScaleNormal( tex2D( _WaterNormal, uv0_WaterNormal ), _yes ) , clampResult121);
			o.Normal = lerpResult274;
			float2 uv_TexCoord9_g36 = i.uv_texcoord * _ScaleOffSetIce;
			half temp_output_181_0 = ( _ParallaxOffset + 0.0 );
			float2 uv_TexCoord9_g33 = i.uv_texcoord * _ScaleOffSetIce;
			half temp_output_182_0 = ( _ParallaxOffset + temp_output_181_0 );
			half lerpResult201 = lerp( tex2D( _Texture0, (uv_TexCoord9_g33*1.0 + ( temp_output_182_0 * i.viewDir ).xy) ).r , 1.0 , 0.9);
			float2 uv_TexCoord9_g34 = i.uv_texcoord * _ScaleOffSetIce;
			half temp_output_183_0 = ( temp_output_182_0 + _ParallaxOffset );
			half lerpResult197 = lerp( tex2D( _Texture0, (uv_TexCoord9_g34*1.0 + ( temp_output_183_0 * i.viewDir ).xy) ).r , 1.0 , 0.95);
			float2 uv_TexCoord9_g29 = i.uv_texcoord * _ScaleOffSetIce;
			half temp_output_184_0 = ( _ParallaxOffset + temp_output_183_0 );
			half lerpResult202 = lerp( tex2D( _Texture0, (uv_TexCoord9_g29*1.0 + ( temp_output_184_0 * i.viewDir ).xy) ).r , 1.0 , 0.97);
			float2 uv_TexCoord9_g35 = i.uv_texcoord * _ScaleOffSetIce;
			half temp_output_185_0 = ( temp_output_184_0 + _ParallaxOffset );
			half lerpResult199 = lerp( tex2D( _Texture0, (uv_TexCoord9_g35*1.0 + ( temp_output_185_0 * i.viewDir ).xy) ).r , 1.0 , 0.98);
			float2 uv_TexCoord9_g32 = i.uv_texcoord * _ScaleOffSetIce;
			half temp_output_186_0 = ( _ParallaxOffset + temp_output_185_0 );
			half lerpResult198 = lerp( tex2D( _Texture0, (uv_TexCoord9_g32*1.0 + ( temp_output_186_0 * i.viewDir ).xy) ).r , 1.0 , 0.99);
			float2 uv_TexCoord9_g30 = i.uv_texcoord * _ScaleOffSetIce;
			half temp_output_187_0 = ( _ParallaxOffset + temp_output_186_0 );
			half lerpResult204 = lerp( tex2D( _Texture0, (uv_TexCoord9_g30*1.0 + ( temp_output_187_0 * i.viewDir ).xy) ).r , 1.0 , 0.995);
			float2 uv_TexCoord9_g31 = i.uv_texcoord * _ScaleOffSetIce;
			half lerpResult200 = lerp( tex2D( _Texture0, (uv_TexCoord9_g31*1.0 + ( ( temp_output_187_0 + _ParallaxOffset ) * i.viewDir ).xy) ).r , 1.0 , 0.9998);
			half temp_output_282_0 = ( _Time.y * _WaveSpeed );
			float3 ase_worldPos = i.worldPos;
			half2 appendResult286 = (half2(ase_worldPos.x , ase_worldPos.z));
			half2 WorldSpaceTile287 = appendResult286;
			half2 WaveTileUV299 = ( ( WorldSpaceTile287 * _Vector0 ) * 1.0 );
			half2 panner278 = ( temp_output_282_0 * _WindDirection + WaveTileUV299);
			half simplePerlin2D277 = snoise( panner278 );
			simplePerlin2D277 = simplePerlin2D277*0.5 + 0.5;
			half2 panner301 = ( temp_output_282_0 * _WindDirection + ( WaveTileUV299 * _SmallWaveTile ));
			half simplePerlin2D302 = snoise( panner301 );
			simplePerlin2D302 = simplePerlin2D302*0.5 + 0.5;
			half4 lerpResult311 = lerp( _Water2 , _Water1 , ( simplePerlin2D277 + simplePerlin2D302 ));
			half4 lerpResult116 = lerp( ( ( ( ( 1.0 - saturate( ( tex2D( _Texture0, (uv_TexCoord9_g36*1.0 + ( temp_output_181_0 * i.viewDir ).xy) ).r * lerpResult201 * lerpResult197 * lerpResult202 * lerpResult199 * lerpResult198 * lerpResult204 * lerpResult200 ) ) ) * _Color0 ) + ( tex2D( _Albedo, uv_TexCoord207 ) * _Color1 ) ) + ( ( 1.0 - tex2D( _Texture0, uv_TexCoord207 ).r ) * _Color2 ) ) , lerpResult311 , clampResult121);
			half smoothstepResult337 = smoothstep( _Float1 , _Float0 , clampResult121);
			half4 lerpResult331 = lerp( lerpResult116 , _Color3 , ( ( smoothstepResult337 + _Thresholdtemp ) - smoothstepResult337 ));
			o.Albedo = lerpResult331.rgb;
			o.Transmission = lerpResult331.rgb;
			o.Translucency = lerpResult331.rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustom alpha:fade keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 

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
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
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
335;73;1037;656;3214.181;-622.8805;1.647876;True;False
Node;AmplifyShaderEditor.RangedFloatNode;180;-6419.246,-488.5752;Inherit;False;Property;_ParallaxOffset;Parallax Offset;10;0;Create;True;0;0;False;0;-1.58;-0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;181;-5921.915,-541.4511;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;182;-5931.406,-312.1987;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;183;-5900.862,9.772708;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;288;-3989.777,-2452.877;Inherit;False;705.2854;229;Comment;3;285;286;287;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;285;-3939.777,-2402.877;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;184;-5951.109,408.2071;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;185;-5920.564,730.178;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;286;-3709.339,-2366.326;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;186;-5878.596,983.1481;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;287;-3538.491,-2369.787;Inherit;False;WorldSpaceTile;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;289;-3127.125,-2325.318;Inherit;True;287;WorldSpaceTile;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;291;-3064.976,-2110.866;Inherit;False;Property;_Vector0;Vector 0;19;0;Create;True;0;0;False;0;1,1;0.1,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;187;-5928.844,1381.581;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;290;-2750.435,-2320.502;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;189;-5898.299,1703.554;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;103;-2785.528,1027.846;Inherit;False;1610.877;451.6538;Depth Comparison;10;121;92;6;167;5;179;4;3;38;2;Depth Comparison;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;188;-6388.986,-791.327;Inherit;True;Property;_Texture0;Texture 0;12;1;[NoScaleOffset];Create;True;0;0;False;0;None;4a6f6e43ff9506a44a2e9e70872ac64b;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.Vector2Node;263;-5960.308,-1758.991;Inherit;False;Property;_ScaleOffSetIce;Scale OffSet Ice;15;0;Create;True;0;0;False;0;0,0;10,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;293;-2482.094,-2209.031;Inherit;False;Constant;_WaveTile;Wave Tile;16;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;348;-5464.551,989.7001;Inherit;False;ParallaxOffset;-1;;32;24c505475a2d60f47a386774fff313d4;0;3;11;FLOAT2;0,0;False;7;SAMPLER2D;;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;350;-5457.315,1384.027;Inherit;False;ParallaxOffset;-1;;30;24c505475a2d60f47a386774fff313d4;0;3;11;FLOAT2;0,0;False;7;SAMPLER2D;;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;351;-5537.064,414.7591;Inherit;False;ParallaxOffset;-1;;29;24c505475a2d60f47a386774fff313d4;0;3;11;FLOAT2;0,0;False;7;SAMPLER2D;;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;349;-5484.254,1710.106;Inherit;False;ParallaxOffset;-1;;31;24c505475a2d60f47a386774fff313d4;0;3;11;FLOAT2;0,0;False;7;SAMPLER2D;;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;352;-5506.521,736.73;Inherit;False;ParallaxOffset;-1;;35;24c505475a2d60f47a386774fff313d4;0;3;11;FLOAT2;0,0;False;7;SAMPLER2D;;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;347;-5517.361,-305.6467;Inherit;False;ParallaxOffset;-1;;33;24c505475a2d60f47a386774fff313d4;0;3;11;FLOAT2;0,0;False;7;SAMPLER2D;;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;292;-2282.546,-2322.185;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;346;-5486.816,16.32471;Inherit;False;ParallaxOffset;-1;;34;24c505475a2d60f47a386774fff313d4;0;3;11;FLOAT2;0,0;False;7;SAMPLER2D;;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;2;-2752.508,1069.71;Float;True;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;197;-5208.069,25.7771;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.95;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;202;-5206.242,410.772;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.97;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;198;-5185.804,999.1522;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.99;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;199;-5175.698,732.7441;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.98;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;201;-5186.539,-309.6333;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;3;-2756.6,1277.382;Float;True;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenDepthNode;4;-2440.044,1069.87;Inherit;False;1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;299;-2067.705,-2309.552;Inherit;False;WaveTileUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;200;-5153.432,1706.119;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.9998;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;204;-5183.976,1384.148;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.995;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;353;-5511.661,-531.6236;Inherit;False;ParallaxOffset;-1;;36;24c505475a2d60f47a386774fff313d4;0;3;11;FLOAT2;0,0;False;7;SAMPLER2D;;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-2258.951,1336.492;Float;False;Property;_Glaciation;Glaciation;7;0;Create;True;0;0;False;0;-0.001;0.904;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;5;-2106.379,1073.572;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;283;-2581.734,-1407.038;Inherit;False;Property;_WaveSpeed;Wave Speed;17;0;Create;True;0;0;False;0;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;300;-2594.668,-2009.549;Inherit;False;299;WaveTileUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;281;-2586.671,-1525.534;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;305;-2585.674,-1845.957;Inherit;False;Property;_SmallWaveTile;Small Wave Tile;20;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;205;-4833.493,-469.7464;Inherit;True;8;8;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-1929.206,1334.986;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;303;-2317.688,-2056.064;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;280;-2566.125,-1691.781;Inherit;False;Property;_WindDirection;Wind Direction;16;0;Create;True;0;0;False;0;1,0;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;207;-5429.897,-1763.119;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;167;-1755.513,1336.006;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;206;-4545.804,-733.3497;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;6;-1753.399,1088.705;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;282;-2354.617,-1535.409;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-1864.646,1158.567;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;208;-4021.799,-513.1348;Inherit;False;Property;_Color0;Color 0;13;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;210;-4203.785,-748.0457;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;212;-4495.364,-1341.847;Inherit;True;Property;_Albedo;Albedo;8;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;209;-3645.878,-1315.882;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;301;-2023.146,-1308.433;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;278;-2076.167,-1896.134;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;211;-4410.455,-1087.511;Inherit;False;Property;_Color1;Color 1;11;1;[HDR];Create;True;0;0;False;0;0,2.682353,4,0;0.7387707,0.8198553,0.8603976,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;339;-741.9896,1104.068;Inherit;False;Property;_Float1;Float 1;22;0;Create;True;0;0;False;0;0;0.658;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;216;-3297.458,-1007.207;Inherit;False;Property;_Color2;Color 2;14;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;121;-1339.929,1093.665;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;215;-3285.055,-1133.356;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;213;-4119.341,-1189.831;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;302;-1716.119,-1306.07;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;338;-701.8137,1205.996;Inherit;False;Property;_Float0;Float 0;23;0;Create;True;0;0;False;0;0;0.848;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;-3770.394,-742.6783;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;277;-1769.14,-1893.771;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;344;-462.3919,900.8623;Inherit;False;Property;_Thresholdtemp;Thresholdtemp;25;0;Create;True;0;0;False;0;0;-0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;313;-145.0258,-910.7662;Inherit;False;Property;_Water1;Water 1;26;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.2713154,0.6248502,0.8584906,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;337;-399.0108,1016.687;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;304;-1360.03,-1490.995;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;312;-29.17546,-1095.002;Inherit;False;Property;_Water2;Water 2;27;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.2862228,0.5854893,0.9056604,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;217;-3029.56,-1092.537;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;218;-3475.715,-778.7484;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;343;-255.8506,842.1211;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;220;-2834.159,-853.4497;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;315;-1887.144,496.6119;Inherit;False;Property;_yes;yes;29;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;319;-2054.083,357.6912;Inherit;False;0;314;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;311;130.1195,-683.5139;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;314;-1708.351,365.5933;Inherit;True;Property;_WaterNormal;Water Normal;28;0;Create;True;0;0;False;0;-1;None;7396d8283d9546a47b19041de42366c3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;116;519.2315,-497.3716;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;295;-269.3568,297.7771;Inherit;False;Constant;_Vector1;Vector 1;18;0;Create;True;0;0;False;0;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;334;471.6513,-176.1061;Inherit;False;Property;_Color3;Color 3;24;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.7490196,0.7490196,0.7490196,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;219;-3112.478,-43.08637;Inherit;True;Property;_IceNormal;Ice Normal;9;0;Create;True;0;0;False;0;-1;None;cd93b77a2b8fe68489720b1c3bb3b3e1;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;340;-78.68164,824.9636;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;310;-1002.365,-42.02669;Inherit;False;Property;_WaveHeight;Wave Height;21;0;Create;True;0;0;False;0;1;0.032;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;330;-999.7869,65.67889;Inherit;False;Property;_IceHeight;Ice Height;30;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;274;-936.9467,270.1786;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;309;-427.6918,-32.43824;Inherit;True;Inverse Lerp;-1;;9;09cbe79402f023141a4dc1fddd4c9511;0;0;0
Node;AmplifyShaderEditor.LerpOp;329;-620.47,13.97178;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;331;889.5014,-167.2888;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;298;106.7419,191.9988;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StepOpNode;345;-1164.006,1001.477;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;294;1042.216,432.8989;Inherit;False;Property;_Tesselation;Tesselation;18;0;Create;True;0;0;False;0;8;23.47;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1284.002,-39.90843;Half;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Custom/Lake;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;0;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;181;0;180;0
WireConnection;182;0;180;0
WireConnection;182;1;181;0
WireConnection;183;0;182;0
WireConnection;183;1;180;0
WireConnection;184;0;180;0
WireConnection;184;1;183;0
WireConnection;185;0;184;0
WireConnection;185;1;180;0
WireConnection;286;0;285;1
WireConnection;286;1;285;3
WireConnection;186;0;180;0
WireConnection;186;1;185;0
WireConnection;287;0;286;0
WireConnection;187;0;180;0
WireConnection;187;1;186;0
WireConnection;290;0;289;0
WireConnection;290;1;291;0
WireConnection;189;0;187;0
WireConnection;189;1;180;0
WireConnection;348;11;263;0
WireConnection;348;7;188;0
WireConnection;348;5;186;0
WireConnection;350;11;263;0
WireConnection;350;7;188;0
WireConnection;350;5;187;0
WireConnection;351;11;263;0
WireConnection;351;7;188;0
WireConnection;351;5;184;0
WireConnection;349;11;263;0
WireConnection;349;7;188;0
WireConnection;349;5;189;0
WireConnection;352;11;263;0
WireConnection;352;7;188;0
WireConnection;352;5;185;0
WireConnection;347;11;263;0
WireConnection;347;7;188;0
WireConnection;347;5;182;0
WireConnection;292;0;290;0
WireConnection;292;1;293;0
WireConnection;346;11;263;0
WireConnection;346;7;188;0
WireConnection;346;5;183;0
WireConnection;197;0;346;0
WireConnection;202;0;351;0
WireConnection;198;0;348;0
WireConnection;199;0;352;0
WireConnection;201;0;347;0
WireConnection;4;0;2;0
WireConnection;299;0;292;0
WireConnection;200;0;349;0
WireConnection;204;0;350;0
WireConnection;353;11;263;0
WireConnection;353;7;188;0
WireConnection;353;5;181;0
WireConnection;5;0;3;2
WireConnection;5;1;4;0
WireConnection;205;0;353;0
WireConnection;205;1;201;0
WireConnection;205;2;197;0
WireConnection;205;3;202;0
WireConnection;205;4;199;0
WireConnection;205;5;198;0
WireConnection;205;6;204;0
WireConnection;205;7;200;0
WireConnection;179;0;38;0
WireConnection;303;0;300;0
WireConnection;303;1;305;0
WireConnection;207;0;263;0
WireConnection;167;0;179;0
WireConnection;206;0;205;0
WireConnection;6;0;5;0
WireConnection;282;0;281;0
WireConnection;282;1;283;0
WireConnection;92;0;6;0
WireConnection;92;1;167;0
WireConnection;210;0;206;0
WireConnection;212;1;207;0
WireConnection;209;0;188;0
WireConnection;209;1;207;0
WireConnection;301;0;303;0
WireConnection;301;2;280;0
WireConnection;301;1;282;0
WireConnection;278;0;300;0
WireConnection;278;2;280;0
WireConnection;278;1;282;0
WireConnection;121;0;92;0
WireConnection;215;0;209;1
WireConnection;213;0;212;0
WireConnection;213;1;211;0
WireConnection;302;0;301;0
WireConnection;214;0;210;0
WireConnection;214;1;208;0
WireConnection;277;0;278;0
WireConnection;337;0;121;0
WireConnection;337;1;339;0
WireConnection;337;2;338;0
WireConnection;304;0;277;0
WireConnection;304;1;302;0
WireConnection;217;0;215;0
WireConnection;217;1;216;0
WireConnection;218;0;214;0
WireConnection;218;1;213;0
WireConnection;343;0;337;0
WireConnection;343;1;344;0
WireConnection;220;0;218;0
WireConnection;220;1;217;0
WireConnection;311;0;312;0
WireConnection;311;1;313;0
WireConnection;311;2;304;0
WireConnection;314;1;319;0
WireConnection;314;5;315;0
WireConnection;116;0;220;0
WireConnection;116;1;311;0
WireConnection;116;2;121;0
WireConnection;219;1;207;0
WireConnection;340;0;343;0
WireConnection;340;1;337;0
WireConnection;274;0;219;0
WireConnection;274;1;314;0
WireConnection;274;2;121;0
WireConnection;329;0;330;0
WireConnection;329;1;310;0
WireConnection;329;2;121;0
WireConnection;331;0;116;0
WireConnection;331;1;334;0
WireConnection;331;2;340;0
WireConnection;298;1;295;0
WireConnection;0;0;331;0
WireConnection;0;1;274;0
WireConnection;0;6;331;0
WireConnection;0;7;331;0
WireConnection;0;11;298;0
WireConnection;0;14;294;0
ASEEND*/
//CHKSM=957C4B4BE84A7D4521C8758ACEE180A3706CD277