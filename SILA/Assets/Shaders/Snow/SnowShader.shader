// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SnowShader"
{
	Properties
	{
		_RenderTextureScale("RenderTextureScale", Float) = 0.1
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 32
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.37
		_Size("Size", Vector) = (0,0,0,0)
		[HideInInspector]_PositionPlayer("Position Player", Vector) = (0,0,0,0)
		_SnowHeight("Snow Height", Range( 0 , 1)) = 0
		_Noise_Strength("Noise_Strength", Float) = 0
		_RenderTexture("RenderTexture", 2D) = "white" {}
		_Glitter_Threshold("Glitter_Threshold", Float) = 0
		_GlitterIntensity("Glitter Intensity", Float) = 0
		_SpecularStrenght("SpecularStrenght", Float) = 0
		_ToonRamp("ToonRamp", 2D) = "white" {}
		_ToonRampTint("ToonRamp Tint", Color) = (0,0,0,0)
		_SpecularPower("SpecularPower", Float) = 0
		_RimStrenght("RimStrenght", Float) = 0.27
		_RimPower("RimPower", Float) = 13
		_Debug_SnowHeight("Debug_SnowHeight", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
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
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
			float3 viewDir;
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

		uniform float _Debug_SnowHeight;
		uniform sampler2D _RenderTexture;
		uniform float _RenderTextureScale;
		uniform float2 _PositionPlayer;
		uniform float _SnowHeight;
		uniform sampler2D _ToonRamp;
		uniform float4 _ToonRampTint;
		uniform float2 _Size;
		uniform float _Noise_Strength;
		uniform float _Glitter_Threshold;
		uniform float _GlitterIntensity;
		uniform float _RimPower;
		uniform float _RimStrenght;
		uniform float _SpecularPower;
		uniform float _SpecularStrenght;
		uniform float _EdgeLength;
		uniform float _TessPhongStrength;


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
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult5 = (float2(ase_worldPos.x , ase_worldPos.z));
			float OffSetUV59 = ( _RenderTextureScale / 20.0 );
			float temp_output_30_0 = ( 1.0 - tex2Dlod( _RenderTexture, float4( ( ( ( appendResult5 + OffSetUV59 ) + _PositionPlayer ) * ( 10.0 / _RenderTextureScale ) ), 0, 0.0) ).r );
			float3 appendResult24 = (float3(0.0 , 0.0 , ( temp_output_30_0 * ( _SnowHeight + 0.1 ) )));
			v.vertex.xyz += ( _Debug_SnowHeight * appendResult24 );
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
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult135 = dot( ase_worldNormal , ase_worldlightDir );
			float2 temp_cast_0 = (saturate( dotResult135 )).xx;
			float simplePerlin2D232 = snoise( ( _Size * i.uv_texcoord ) );
			float2 normalizeResult315 = normalize( ( i.uv_texcoord + ( simplePerlin2D232 * _Noise_Strength ) ) );
			float3 normalizeResult328 = normalize( i.viewDir );
			float dotResult302 = dot( reflect( ase_worldlightDir , float3( normalizeResult315 ,  0.0 ) ) , normalizeResult328 );
			float ifLocalVar321 = 0;
			if( dotResult302 > _Glitter_Threshold )
				ifLocalVar321 = dotResult302;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			UnityGI gi218 = gi;
			float3 diffNorm218 = ase_worldNormal;
			gi218 = UnityGI_Base( data, 1, diffNorm218 );
			float3 indirectDiffuse218 = gi218.indirect.diffuse + diffNorm218 * 0.0001;
			float4 temp_output_221_0 = ( ase_lightColor * float4( ( indirectDiffuse218 + ase_lightAtten ) , 0.0 ) );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult164 = dot( ase_worldNormal , ase_worldViewDir );
			float3 normalizeResult184 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float dotResult188 = dot( ase_worldNormal , normalizeResult184 );
			c.rgb = ( ( tex2D( _ToonRamp, temp_cast_0 ) * _ToonRampTint ) + ( saturate( ifLocalVar321 ) * _GlitterIntensity ) + saturate( max( ( temp_output_221_0 * max( saturate( ( pow( ( 1.0 - saturate( dotResult164 ) ) , _RimPower ) * _RimStrenght ) ) , 0.0 ) ) , ( temp_output_221_0 * ( pow( max( 0.0 , dotResult188 ) , _SpecularPower ) * _SpecularStrenght ) ) ) ) ).rgb;
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
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
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
866;73;773;651;820.9729;-830.733;3.436788;True;False
Node;AmplifyShaderEditor.CommentaryNode;116;-2189.3,4121.295;Inherit;False;3007;698.6722;Comment;19;4;5;57;50;49;47;41;54;58;43;12;3;30;73;36;35;24;76;59;Vertex OffSet;1,0.6687182,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;241;-3245.611,1355.808;Inherit;False;1062.447;468.6189;Comment;8;226;227;225;228;232;229;230;231;Noise Generator;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;161;-2333.693,2199.12;Inherit;False;507.201;385.7996;Comment;3;163;162;164;N . V;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;230;-3195.612,1607.605;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;163;-2176.475,2428.311;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;162;-2285.693,2247.12;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;231;-3096.409,1436.906;Float;False;Property;_Size;Size;6;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;183;-2438.165,3228.995;Inherit;False;979.6659;587.2239;Comment;7;182;181;180;185;188;186;184;N.H;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1373.301,4617.295;Inherit;False;Property;_RenderTextureScale;RenderTextureScale;0;0;Create;True;0;0;False;0;0.1;3000;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;229;-2892.403,1506.905;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;181;-2324.017,3506.815;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;58;-1117.3,4681.295;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;182;-2370.407,3661.44;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;164;-1983.788,2337.819;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;348;-1654.33,2270.639;Inherit;False;1451.713;313.418;Comment;9;173;171;169;167;170;166;168;258;175;Rim Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;4;-2141.3,4425.294;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-861.2985,4681.295;Inherit;False;OffSetUV;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;185;-2091,3573.628;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;232;-2706.196,1536.571;Inherit;False;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;228;-2714.548,1698.869;Float;False;Property;_Noise_Strength;Noise_Strength;9;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;258;-1604.33,2338.966;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;168;-1311.711,2435.472;Inherit;False;Property;_RimPower;RimPower;18;0;Create;True;0;0;False;0;13;13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;180;-1981.242,3337.127;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;227;-2519.432,1634.106;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;166;-1310.679,2320.639;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;225;-2630.446,1405.807;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;5;-1885.3,4425.294;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;184;-1944.056,3575.243;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-1885.3,4553.294;Inherit;False;59;OffSetUV;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;188;-1714.758,3444.446;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;216;-1805.855,2790.237;Inherit;False;812;304;Comment;5;221;220;219;218;217;Attenuation and Ambient;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;167;-1107.088,2338.54;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-1629.301,4425.294;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;226;-2326.783,1527.607;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;49;-1629.301,4553.294;Inherit;False;Property;_PositionPlayer;Position Player;7;1;[HideInInspector];Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;349;-1262.171,3347.589;Inherit;False;926.609;359.417;Comment;5;194;190;189;192;191;Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;352;-1754.617,1270.857;Inherit;False;2035.682;560.9133;Comment;11;315;297;302;304;328;298;321;322;337;330;329;Glitter;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;170;-1069.524,2472.011;Inherit;False;Property;_RimStrenght;RimStrenght;17;0;Create;True;0;0;False;0;0.27;0.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;54;-1117.3,4553.294;Inherit;False;2;0;FLOAT;10;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;-883.0883,2370.54;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-1373.301,4425.294;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;315;-1704.617,1528.806;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;218;-1540.28,2923.231;Inherit;False;Tangent;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;133;-1562.038,629.64;Inherit;False;953.9445;475.1312;Comment;4;137;135;134;136;N.L;1,1,1,1;0;0
Node;AmplifyShaderEditor.LightAttenuation;217;-1753.538,2975.628;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;186;-1578.685,3418.064;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;304;-1263.58,1647.771;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;191;-1212.171,3579.457;Inherit;False;Property;_SpecularPower;SpecularPower;16;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;298;-1556.64,1320.857;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;219;-1309.854,2950.236;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ReflectOpNode;297;-1252.543,1500.064;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-989.299,4425.294;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;136;-1417.493,931.7491;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;189;-1009.665,3397.589;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;192;-984.4307,3578.332;Inherit;False;Property;_SpecularStrenght;SpecularStrenght;13;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-1085.3,4169.295;Inherit;True;Property;_RenderTexture;RenderTexture;10;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.WorldNormalVector;134;-1410.793,686.8013;Inherit;True;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LightColorNode;220;-1707.455,2838.236;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SaturateNode;171;-732.1641,2368.664;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;328;-1012.605,1651.677;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;12;-733.2985,4169.295;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;173;-557.4971,2369.449;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;221;-1149.854,2838.236;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-605.2983,4425.294;Inherit;False;Property;_SnowHeight;Snow Height;8;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;322;-614.7195,1630.51;Inherit;False;Property;_Glitter_Threshold;Glitter_Threshold;11;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;135;-1020.271,771.416;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;-785.6646,3429.589;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;302;-808.3046,1496.766;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;353;380.4566,693.6326;Inherit;False;567.269;552.9442;Comment;3;345;346;347;ToonRamp;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;194;-550.2437,3419.57;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;137;-792.7621,774.7207;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;30;-349.298,4169.295;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;-389.2899,2367.311;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;321;-314.7681,1483.98;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-221.2982,4425.294;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;337;-108.5068,1483.036;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;347;429.9377,1062.127;Inherit;False;Property;_ToonRampTint;ToonRamp Tint;15;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;178;304.3008,2373.38;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;34.7009,4297.294;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;345;430.4566,743.6326;Inherit;True;Property;_ToonRamp;ToonRamp;14;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;330;-126.3669,1587.281;Inherit;False;Property;_GlitterIntensity;Glitter Intensity;12;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;346;778.7257,978.7869;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;329;112.0655,1497.724;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;912.0389,2641.644;Inherit;False;Property;_Debug_SnowHeight;Debug_SnowHeight;19;0;Create;True;0;0;False;0;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;290.7017,4297.294;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;177;632.557,2126.105;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;1244.119,2666.771;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;176;976.2072,1496.678;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;76;546.7018,4169.295;Inherit;False;Lerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1878.833,1215.502;Float;False;True;-1;6;ASEMaterialInspector;0;0;CustomLighting;SnowShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;32;10;25;True;0.37;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;229;0;231;0
WireConnection;229;1;230;0
WireConnection;58;0;43;0
WireConnection;164;0;162;0
WireConnection;164;1;163;0
WireConnection;59;0;58;0
WireConnection;185;0;181;0
WireConnection;185;1;182;0
WireConnection;232;0;229;0
WireConnection;258;0;164;0
WireConnection;227;0;232;0
WireConnection;227;1;228;0
WireConnection;166;0;258;0
WireConnection;5;0;4;1
WireConnection;5;1;4;3
WireConnection;184;0;185;0
WireConnection;188;0;180;0
WireConnection;188;1;184;0
WireConnection;167;0;166;0
WireConnection;167;1;168;0
WireConnection;50;0;5;0
WireConnection;50;1;57;0
WireConnection;226;0;225;0
WireConnection;226;1;227;0
WireConnection;54;1;43;0
WireConnection;169;0;167;0
WireConnection;169;1;170;0
WireConnection;47;0;50;0
WireConnection;47;1;49;0
WireConnection;315;0;226;0
WireConnection;186;1;188;0
WireConnection;219;0;218;0
WireConnection;219;1;217;0
WireConnection;297;0;298;0
WireConnection;297;1;315;0
WireConnection;41;0;47;0
WireConnection;41;1;54;0
WireConnection;189;0;186;0
WireConnection;189;1;191;0
WireConnection;171;0;169;0
WireConnection;328;0;304;0
WireConnection;12;0;3;0
WireConnection;12;1;41;0
WireConnection;173;0;171;0
WireConnection;221;0;220;0
WireConnection;221;1;219;0
WireConnection;135;0;134;0
WireConnection;135;1;136;0
WireConnection;190;0;189;0
WireConnection;190;1;192;0
WireConnection;302;0;297;0
WireConnection;302;1;328;0
WireConnection;194;0;221;0
WireConnection;194;1;190;0
WireConnection;137;0;135;0
WireConnection;30;0;12;1
WireConnection;175;0;221;0
WireConnection;175;1;173;0
WireConnection;321;0;302;0
WireConnection;321;1;322;0
WireConnection;321;2;302;0
WireConnection;73;0;36;0
WireConnection;337;0;321;0
WireConnection;178;0;175;0
WireConnection;178;1;194;0
WireConnection;35;0;30;0
WireConnection;35;1;73;0
WireConnection;345;1;137;0
WireConnection;346;0;345;0
WireConnection;346;1;347;0
WireConnection;329;0;337;0
WireConnection;329;1;330;0
WireConnection;24;2;35;0
WireConnection;177;0;178;0
WireConnection;130;0;131;0
WireConnection;130;1;24;0
WireConnection;176;0;346;0
WireConnection;176;1;329;0
WireConnection;176;2;177;0
WireConnection;76;0;30;0
WireConnection;0;13;176;0
WireConnection;0;11;130;0
ASEEND*/
//CHKSM=4F13008C309E1FE21815489BCB7B07F0187E7A52