// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WaterV2"
{
	Properties
	{
		_DistortionSpeed("Distortion Speed", Float) = 0
		_DistorsionAmount("Distorsion Amount", Float) = 0
		_DistortionNormal("Distortion Normal", 2D) = "white" {}
		_WaterColor("Water Color", Color) = (0,0,0,0)
		_DepthColor("Depth Color", Color) = (0,0,0,0)
		_DepthInt("Depth Int", Float) = 7
		_FoamColor("Foam Color", Color) = (0,0,0,0)
		_FoamIntensity("Foam Intensity", Float) = 0
		_WaveSpeed("Wave Speed", Float) = 0
		_WaveIntensity("Wave Intensity", Float) = 0
		_WaterHeightdebug("Water Height (debug)", Float) = 0
		_FoamTexture("Foam Texture", 2D) = "white" {}
		_FoamInt("Foam Int", Float) = 0
		_FoamSpeed("Foam Speed", Float) = 0
		_SpecularInt("Specular Int", Float) = 0
		_SpecularThreshold("Specular Threshold", Float) = 0
		_NormalWaveSpeed("Normal Wave Speed", Float) = 0
		_DistortionInt("Distortion Int", Float) = 0
		_Vignette("Vignette", 2D) = "white" {}
		_Glaciation("Glaciation", Range( 0 , 1)) = 0
		_IceAlbedo("Ice Albedo", 2D) = "white" {}
		[HDR]_IceColor("Ice Color", Color) = (0,0,0,0)
		_IceNormal("Ice Normal", 2D) = "bump" {}
		_IceNormalScale("Ice Normal Scale", Float) = 0
		_IceParallax("Ice Parallax", 2D) = "white" {}
		_ParallaxColor("Parallax Color", Color) = (0,0,0,0)
		_HeightParallax("Height Parallax", Float) = 0
		_Metalness("Metalness", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
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
			float3 worldPos;
			float2 uv_texcoord;
			float4 screenPos;
			float3 viewDir;
			INTERNAL_DATA
			float3 worldNormal;
		};

		uniform float _WaterHeightdebug;
		uniform float _WaveIntensity;
		uniform float _WaveSpeed;
		uniform float _Glaciation;
		uniform sampler2D _Vignette;
		uniform sampler2D _DistortionNormal;
		uniform float _DistorsionAmount;
		uniform float _DistortionSpeed;
		uniform float _IceNormalScale;
		uniform sampler2D _IceNormal;
		uniform sampler2D _IceAlbedo;
		uniform float4 _IceAlbedo_ST;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _DistortionInt;
		uniform float4 _WaterColor;
		uniform float4 _DepthColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthInt;
		uniform float4 _FoamColor;
		uniform sampler2D _FoamTexture;
		uniform float _FoamSpeed;
		uniform float4 _FoamTexture_ST;
		uniform float _FoamInt;
		uniform float _FoamIntensity;
		uniform sampler2D _IceParallax;
		uniform float4 _IceParallax_ST;
		uniform float _HeightParallax;
		uniform float4 _ParallaxColor;
		uniform float4 _IceColor;
		uniform float _SpecularThreshold;
		uniform float _NormalWaveSpeed;
		uniform float _SpecularInt;
		uniform float _Metalness;
		uniform float _Smoothness;


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float mulTime102 = _Time.y * _WaveSpeed;
			float3 appendResult90 = (float3(ase_worldPos.x , ( _WaterHeightdebug + ( _WaveIntensity * sin( ( mulTime102 + ( ase_worldPos.x * ase_worldPos.z ) ) ) ) ) , ase_worldPos.z));
			float3 worldToObj94 = mul( unity_WorldToObject, float4( appendResult90, 1 ) ).xyz;
			float3 worldToObj217 = mul( unity_WorldToObject, float4( ase_worldPos, 1 ) ).xyz;
			float2 uv_TexCoord210 = v.texcoord.xy * float2( 0.5,0.5 ) + float2( 0.25,0.25 );
			float smoothstepResult208 = smoothstep( _Glaciation , 1.0 , tex2Dlod( _Vignette, float4( uv_TexCoord210, 0, 0.0) ).r);
			float temp_output_212_0 = ( 1.0 - smoothstepResult208 );
			float3 lerpResult213 = lerp( worldToObj94 , worldToObj217 , temp_output_212_0);
			v.vertex.xyz += lerpResult213;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime16 = _Time.y * _DistortionSpeed;
			float2 panner13 = ( mulTime16 * float2( 0.5,0.5 ) + i.uv_texcoord);
			float3 tex2DNode18 = UnpackScaleNormal( tex2D( _DistortionNormal, panner13 ), _DistorsionAmount );
			float2 uv0_IceAlbedo = i.uv_texcoord * _IceAlbedo_ST.xy + _IceAlbedo_ST.zw;
			float2 uv_TexCoord210 = i.uv_texcoord * float2( 0.5,0.5 ) + float2( 0.25,0.25 );
			float smoothstepResult208 = smoothstep( _Glaciation , 1.0 , tex2D( _Vignette, uv_TexCoord210 ).r);
			float temp_output_212_0 = ( 1.0 - smoothstepResult208 );
			float3 lerpResult219 = lerp( tex2DNode18 , UnpackScaleNormal( tex2D( _IceNormal, uv0_IceAlbedo ), _IceNormalScale ) , temp_output_212_0);
			o.Normal = lerpResult219;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor22 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( float4( tex2DNode18 , 0.0 ) + ase_grabScreenPosNorm ).xy);
			float4 temp_output_196_0 = ( screenColor22 * _DistortionInt );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float clampDepth60 = Linear01Depth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float4 lerpResult64 = lerp( _WaterColor , _DepthColor , ( clampDepth60 * _DepthInt ));
			float2 temp_cast_2 = (_FoamSpeed).xx;
			float2 uv0_FoamTexture = i.uv_texcoord * _FoamTexture_ST.xy + _FoamTexture_ST.zw;
			float2 panner149 = ( 1.0 * _Time.y * temp_cast_2 + uv0_FoamTexture);
			float2 temp_cast_3 = (( _FoamSpeed * -0.5 )).xx;
			float2 panner153 = ( 1.0 * _Time.y * temp_cast_3 + uv0_FoamTexture);
			float screenDepth81 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth81 = abs( ( screenDepth81 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( ( 1.0 - _FoamIntensity ) ) );
			float temp_output_128_0 = saturate( ( ( 1.0 - pow( ( tex2D( _FoamTexture, panner149 ).r * tex2D( _FoamTexture, panner153 ).b ) , _FoamInt ) ) * ( 1.0 - saturate( distanceDepth81 ) ) ) );
			float4 lerpResult118 = lerp( ( temp_output_196_0 + lerpResult64 ) , _FoamColor , temp_output_128_0);
			float2 uv0_IceParallax = i.uv_texcoord * _IceParallax_ST.xy + _IceParallax_ST.zw;
			float2 Offset230 = ( ( _HeightParallax - 1 ) * i.viewDir.xy * 1.0 ) + uv0_IceParallax;
			float2 Offset235 = ( ( ( _HeightParallax / 1.15 ) - 1 ) * i.viewDir.xy * 1.0 ) + ( uv0_IceParallax + float2( 0.25,0.25 ) );
			float2 Offset237 = ( ( ( _HeightParallax / 1.5 ) - 1 ) * i.viewDir.xy * 1.0 ) + ( uv0_IceParallax + float2( 0.75,0.75 ) );
			float4 temp_output_227_0 = ( ( ( ( ( 1.0 - tex2D( _IceParallax, Offset230 ).r ) + ( 1.0 - tex2D( _IceParallax, Offset235 ).r ) + ( 1.0 - tex2D( _IceParallax, Offset237 ).r ) ) * _ParallaxColor ) + ( tex2D( _IceAlbedo, uv0_IceAlbedo ) * _IceColor ) ) * temp_output_196_0 );
			float4 lerpResult215 = lerp( lerpResult118 , temp_output_227_0 , temp_output_212_0);
			o.Albedo = lerpResult215.rgb;
			float2 temp_cast_5 = (_NormalWaveSpeed).xx;
			float2 panner184 = ( _Time.y * temp_cast_5 + i.uv_texcoord);
			float2 temp_cast_6 = (( _NormalWaveSpeed * -0.5 )).xx;
			float2 panner185 = ( _Time.y * temp_cast_6 + i.uv_texcoord);
			float3 normalizeResult167 = normalize( (WorldNormalVector( i , ( UnpackScaleNormal( tex2D( _DistortionNormal, panner184 ), _SpecularThreshold ) * UnpackScaleNormal( tex2D( _DistortionNormal, panner185 ), _SpecularThreshold ) ) )) );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 normalizeResult166 = normalize( ( ase_worldlightDir + ase_worldViewDir ) );
			float dotResult165 = dot( normalizeResult167 , normalizeResult166 );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 lerpResult214 = lerp( ( ( _FoamColor * temp_output_128_0 ) + float4( ( pow( saturate( dotResult165 ) , _SpecularInt ) * ase_lightColor.rgb ) , 0.0 ) ) , temp_output_227_0 , temp_output_212_0);
			o.Emission = lerpResult214.rgb;
			o.Metallic = _Metalness;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				vertexDataFunc( v, customInputData );
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
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
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
481;73;1045;655;2648.127;2103.47;2.138457;True;False
Node;AmplifyShaderEditor.CommentaryNode;205;-5324.93,421.6248;Inherit;False;2682.808;811.4583;;23;160;162;159;164;166;167;165;170;174;177;169;175;187;189;188;190;186;180;185;184;181;178;182;Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;187;-5240.217,684.1152;Inherit;False;Property;_NormalWaveSpeed;Normal Wave Speed;16;0;Create;True;0;0;False;0;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;189;-5146.394,825.8195;Inherit;False;Constant;_Float3;Float 3;17;0;Create;True;0;0;False;0;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;203;-3845.106,1368.422;Inherit;False;2159.045;725.944;;20;150;155;154;148;153;149;134;82;132;131;151;152;145;81;84;144;156;115;147;128;Foam;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;-4970.393,762.8195;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;190;-5020.434,925.556;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;186;-5274.93,506.0278;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;150;-3758.015,1815.819;Inherit;False;Property;_FoamSpeed;Foam Speed;13;0;Create;True;0;0;False;0;0;0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-3753.64,1968.996;Inherit;False;Constant;_Float2;Float 2;15;0;Create;True;0;0;False;0;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;180;-4769.715,652.8414;Inherit;False;Property;_SpecularThreshold;Specular Threshold;15;0;Create;True;0;0;False;0;0;1.93;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;184;-4746.269,502.5385;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;-3570.526,1959.365;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;86;-4967.939,-938.2924;Inherit;False;1476.167;704.0154;;10;22;20;18;21;13;19;15;16;12;17;Distortion;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;148;-3795.106,1655.379;Inherit;False;0;134;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;185;-4741.618,772.3622;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;28;-5020.83,-81.60679;Inherit;True;Property;_DistortionNormal;Distortion Normal;2;0;Create;True;0;0;False;0;None;9c9923e81cf2ef349915824e0a1b12b2;True;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;234;-2047.985,-1868.263;Inherit;False;0;231;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;82;-3084.488,1971.901;Inherit;False;Property;_FoamIntensity;Foam Intensity;7;0;Create;True;0;0;False;0;0;2.89;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;134;-3579.771,1418.422;Inherit;True;Property;_FoamTexture;Foam Texture;11;0;Create;True;0;0;False;0;None;bd5ef806a7fff5648a61fddab704ff77;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.Vector2Node;242;-2014.772,-1279.026;Inherit;False;Constant;_Vector2;Vector 2;29;0;Create;True;0;0;False;0;0.75,0.75;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;246;-2122.343,-1449.787;Inherit;False;Constant;_Float4;Float 4;29;0;Create;True;0;0;False;0;1.15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;202;-3682.871,2351.209;Inherit;False;1984.632;574.2949;;12;113;95;114;102;103;124;100;123;112;111;90;94;Vertex Displacement;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;153;-3432.267,1920.96;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-4917.94,-491.1072;Inherit;False;Property;_DistortionSpeed;Distortion Speed;0;0;Create;True;0;0;False;0;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;241;-2046.881,-1697.902;Inherit;False;Constant;_Vector1;Vector 1;29;0;Create;True;0;0;False;0;0.25,0.25;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;181;-4505.467,743.8763;Inherit;True;Property;_TextureSample3;Texture Sample 3;16;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;178;-4515.21,471.6248;Inherit;True;Property;_TextureSample2;Texture Sample 2;15;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;248;-2122.343,-1362.217;Inherit;False;Constant;_Float5;Float 5;29;0;Create;True;0;0;False;0;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;244;-2226.885,-1532.979;Inherit;False;Property;_HeightParallax;Height Parallax;26;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;149;-3483.064,1679.684;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;239;-1615.551,-1706.67;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;162;-3980.806,893.6879;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;247;-1931.148,-1403.083;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-4739.625,-769.6223;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;113;-3577.188,2541.916;Inherit;False;Property;_WaveSpeed;Wave Speed;8;0;Create;True;0;0;False;0;0;1.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;240;-1632.217,-1525.43;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;131;-2867.549,1977.887;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;245;-1936.445,-1527.141;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;249;-1992.306,-1135.758;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;95;-3632.871,2720.157;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;182;-4068.751,645.5912;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;132;-3175.776,1421.819;Inherit;True;Property;_TextureSample0;Texture Sample 0;12;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;15;-4723.173,-632.6505;Inherit;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;False;0;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;160;-3927.829,1045.083;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;16;-4693.273,-486.5839;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;151;-3163.652,1708.619;Inherit;True;Property;_TextureSample1;Texture Sample 1;15;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;102;-3376.172,2545.716;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;235;-1402.054,-1584.903;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxMappingNode;237;-1377.35,-1299.426;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;159;-3812.232,643.8282;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DepthFade;81;-2659.765,1942.759;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;230;-1397.059,-1869.831;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;-2764.004,1519.896;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-4477.655,-512.2164;Inherit;False;Property;_DistorsionAmount;Distorsion Amount;1;0;Create;True;0;0;False;0;0;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-3313.558,2639.703;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;231;-1762.886,-2122.306;Inherit;True;Property;_IceParallax;Ice Parallax;24;0;Create;True;0;0;False;0;None;4a6f6e43ff9506a44a2e9e70872ac64b;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;13;-4463.205,-659.5233;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;164;-3692.806,998.688;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;145;-2637.484,1719.656;Inherit;False;Property;_FoamInt;Foam Int;12;0;Create;True;0;0;False;0;0;0.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;238;-1065.129,-1346.461;Inherit;True;Property;_TextureSample6;Texture Sample 6;27;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;236;-1089.833,-1631.938;Inherit;True;Property;_TextureSample5;Texture Sample 5;27;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;84;-2386.549,1942.502;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;144;-2477.319,1483.941;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-4236.404,-676.5692;Inherit;True;Property;_Normal;Normal;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;204;-3416.61,-314.3023;Inherit;False;841.9902;706.1475;;6;63;60;65;66;62;64;Depth;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalizeNode;167;-3563.155,801.4766;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;166;-3526.574,993.5211;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;232;-1084.837,-1916.865;Inherit;True;Property;_TextureSample4;Texture Sample 4;27;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GrabScreenPosition;21;-4155.32,-426.0075;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;103;-3108.539,2530.173;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-3861.76,-493.6152;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SinOpNode;100;-2859.143,2519.108;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;165;-3360.673,926.2604;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-3299.696,275.8453;Inherit;False;Property;_DepthInt;Depth Int;5;0;Create;True;0;0;False;0;7;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;60;-3366.61,186.9035;Inherit;False;1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;256;-735.7594,-1693.071;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;124;-2752.617,2401.209;Inherit;False;Property;_WaveIntensity;Wave Intensity;9;0;Create;True;0;0;False;0;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;156;-2192.25,1510.251;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;255;-694.829,-1866.538;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;257;-700.6762,-1517.654;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;221;-899.2511,-931.7294;Inherit;False;0;218;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;115;-2171.487,1944.278;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;197;-3296.022,-581.8334;Inherit;False;Property;_DistortionInt;Distortion Int;17;0;Create;True;0;0;False;0;0;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;218;-351.7364,-947.1259;Inherit;True;Property;_IceAlbedo;Ice Albedo;20;0;Create;True;0;0;False;0;-1;None;732858e138af22f4b8954569440f82b9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;112;-2479.893,2461.296;Inherit;False;Property;_WaterHeightdebug;Water Height (debug);10;0;Create;True;0;0;False;0;0;-62;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-2575.643,2568.839;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;252;-422.2966,-1700.927;Inherit;False;Property;_ParallaxColor;Parallax Color;25;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;170;-3327.344,1048.747;Inherit;False;Property;_SpecularInt;Specular Int;14;0;Create;True;0;0;False;0;0;109.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;210;-1396.793,765.1845;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0.25,0.25;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;66;-3132.719,-38.28994;Inherit;False;Property;_DepthColor;Depth Color;4;0;Create;True;0;0;False;0;0,0,0,0;0,0.1611173,0.6132076,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;22;-3680.287,-675.0886;Inherit;False;Global;_GrabScreen0;Grab Screen 0;3;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-3139.696,195.8461;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;250;-479.515,-1868.187;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;229;-302.8987,-569.661;Inherit;False;Property;_IceColor;Ice Color;21;1;[HDR];Create;True;0;0;False;0;0,0,0,0;8,8,8,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;-2017.59,1475.005;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;174;-3236.437,916.1066;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;65;-3133.07,-264.3022;Inherit;False;Property;_WaterColor;Water Color;3;0;Create;True;0;0;False;0;0,0,0,0;0,0.5975609,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;169;-3100.051,916.3542;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;119;-1762.093,84.15025;Inherit;False;Property;_FoamColor;Foam Color;6;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;128;-1851.06,1476.8;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;206;-1152.052,688.534;Inherit;True;Property;_Vignette;Vignette;18;0;Create;True;0;0;False;0;-1;None;dd05d57765dcb144496c7b0952492eef;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;228;10.68407,-868.1231;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;-2257.484,2636.291;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;64;-2756.619,70.85504;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;211;-1148.204,926.4164;Inherit;False;Property;_Glaciation;Glaciation;19;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;177;-3104.843,1036.232;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;251;-117.0456,-1862.566;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;196;-3076.338,-674.0222;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;208;-805.0433,701.3627;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;-2804.123,897.9149;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;-1381.61,296.0679;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;253;218.1461,-884.296;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;90;-2065.621,2744.047;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;198;-2312.416,-680.9063;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;216;-88.65326,2883.933;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;224;-608.7112,-166.5982;Inherit;False;Property;_IceNormalScale;Ice Normal Scale;23;0;Create;True;0;0;False;0;0;1.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;94;-1929.238,2737.504;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;220;-389.1934,-307.7664;Inherit;True;Property;_IceNormal;Ice Normal;22;0;Create;True;0;0;False;0;-1;None;cd93b77a2b8fe68489720b1c3bb3b3e1;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TransformPositionNode;217;263.0765,2867;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;171;-1161.416,289.6537;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;212;-533.4323,695.8986;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;227;333.7855,-726.9934;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;118;-1432.951,62.41295;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;215;873.6746,-13.05331;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;213;483.6735,2682.826;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;225;978.3466,275.3528;Inherit;False;Property;_Metalness;Metalness;27;0;Create;True;0;0;False;0;0;0.08;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;226;1073.226,344.5706;Inherit;False;Property;_Smoothness;Smoothness;28;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;214;669.8387,305.1711;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;219;691.8509,164.7126;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1320.156,-3.157014;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;WaterV2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;188;0;187;0
WireConnection;188;1;189;0
WireConnection;184;0;186;0
WireConnection;184;2;187;0
WireConnection;184;1;190;0
WireConnection;154;0;150;0
WireConnection;154;1;155;0
WireConnection;185;0;186;0
WireConnection;185;2;188;0
WireConnection;185;1;190;0
WireConnection;153;0;148;0
WireConnection;153;2;154;0
WireConnection;181;0;28;0
WireConnection;181;1;185;0
WireConnection;181;5;180;0
WireConnection;178;0;28;0
WireConnection;178;1;184;0
WireConnection;178;5;180;0
WireConnection;149;0;148;0
WireConnection;149;2;150;0
WireConnection;239;0;234;0
WireConnection;239;1;241;0
WireConnection;247;0;244;0
WireConnection;247;1;248;0
WireConnection;240;0;234;0
WireConnection;240;1;242;0
WireConnection;131;0;82;0
WireConnection;245;0;244;0
WireConnection;245;1;246;0
WireConnection;182;0;178;0
WireConnection;182;1;181;0
WireConnection;132;0;134;0
WireConnection;132;1;149;0
WireConnection;16;0;17;0
WireConnection;151;0;134;0
WireConnection;151;1;153;0
WireConnection;102;0;113;0
WireConnection;235;0;239;0
WireConnection;235;1;245;0
WireConnection;235;3;249;0
WireConnection;237;0;240;0
WireConnection;237;1;247;0
WireConnection;237;3;249;0
WireConnection;159;0;182;0
WireConnection;81;0;131;0
WireConnection;230;0;234;0
WireConnection;230;1;244;0
WireConnection;230;3;249;0
WireConnection;152;0;132;1
WireConnection;152;1;151;3
WireConnection;114;0;95;1
WireConnection;114;1;95;3
WireConnection;13;0;12;0
WireConnection;13;2;15;0
WireConnection;13;1;16;0
WireConnection;164;0;162;0
WireConnection;164;1;160;0
WireConnection;238;0;231;0
WireConnection;238;1;237;0
WireConnection;236;0;231;0
WireConnection;236;1;235;0
WireConnection;84;0;81;0
WireConnection;144;0;152;0
WireConnection;144;1;145;0
WireConnection;18;0;28;0
WireConnection;18;1;13;0
WireConnection;18;5;19;0
WireConnection;167;0;159;0
WireConnection;166;0;164;0
WireConnection;232;0;231;0
WireConnection;232;1;230;0
WireConnection;103;0;102;0
WireConnection;103;1;114;0
WireConnection;20;0;18;0
WireConnection;20;1;21;0
WireConnection;100;0;103;0
WireConnection;165;0;167;0
WireConnection;165;1;166;0
WireConnection;256;0;236;1
WireConnection;156;0;144;0
WireConnection;255;0;232;1
WireConnection;257;0;238;1
WireConnection;115;0;84;0
WireConnection;218;1;221;0
WireConnection;123;0;124;0
WireConnection;123;1;100;0
WireConnection;22;0;20;0
WireConnection;62;0;60;0
WireConnection;62;1;63;0
WireConnection;250;0;255;0
WireConnection;250;1;256;0
WireConnection;250;2;257;0
WireConnection;147;0;156;0
WireConnection;147;1;115;0
WireConnection;174;0;165;0
WireConnection;169;0;174;0
WireConnection;169;1;170;0
WireConnection;128;0;147;0
WireConnection;206;1;210;0
WireConnection;228;0;218;0
WireConnection;228;1;229;0
WireConnection;111;0;112;0
WireConnection;111;1;123;0
WireConnection;64;0;65;0
WireConnection;64;1;66;0
WireConnection;64;2;62;0
WireConnection;251;0;250;0
WireConnection;251;1;252;0
WireConnection;196;0;22;0
WireConnection;196;1;197;0
WireConnection;208;0;206;1
WireConnection;208;1;211;0
WireConnection;175;0;169;0
WireConnection;175;1;177;1
WireConnection;158;0;119;0
WireConnection;158;1;128;0
WireConnection;253;0;251;0
WireConnection;253;1;228;0
WireConnection;90;0;95;1
WireConnection;90;1;111;0
WireConnection;90;2;95;3
WireConnection;198;0;196;0
WireConnection;198;1;64;0
WireConnection;94;0;90;0
WireConnection;220;1;221;0
WireConnection;220;5;224;0
WireConnection;217;0;216;0
WireConnection;171;0;158;0
WireConnection;171;1;175;0
WireConnection;212;0;208;0
WireConnection;227;0;253;0
WireConnection;227;1;196;0
WireConnection;118;0;198;0
WireConnection;118;1;119;0
WireConnection;118;2;128;0
WireConnection;215;0;118;0
WireConnection;215;1;227;0
WireConnection;215;2;212;0
WireConnection;213;0;94;0
WireConnection;213;1;217;0
WireConnection;213;2;212;0
WireConnection;214;0;171;0
WireConnection;214;1;227;0
WireConnection;214;2;212;0
WireConnection;219;0;18;0
WireConnection;219;1;220;0
WireConnection;219;2;212;0
WireConnection;0;0;215;0
WireConnection;0;1;219;0
WireConnection;0;2;214;0
WireConnection;0;3;225;0
WireConnection;0;4;226;0
WireConnection;0;11;213;0
ASEEND*/
//CHKSM=8CA720CCE9839C92026621740D0A24219EE9933F