// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SnowShader"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 2
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.37
		_PositionPlayer("Position Player", Vector) = (0,0,0,0)
		_SnowHeight("Snow Height", Range( 0 , 1)) = 0
		_RenderTexture("RenderTexture", 2D) = "white" {}
		_NormalDerivativeOffset("Normal Derivative Offset", Range( 0 , 1)) = 0
		_NormalScale("Normal Scale", Float) = 0
		_Color0("Color 0", Color) = (1,1,1,0)
		_Debug_Height("Debug_Height", Float) = 0
		_Color1("Color 1", Color) = (0,0,0,0)
		_CaptureSize("CaptureSize", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#pragma target 4.6
		#pragma addshadow
		#pragma surface surf StandardCustomLighting keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 
		struct Input
		{
			float3 worldPos;
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
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _TessValue;
		uniform float _TessPhongStrength;

		float4 tessFunction( )
		{
			return _TessValue;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult425 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_429_0 = ( ( ( appendResult425 + _PositionPlayer ) + ( _CaptureSize / 2.0 ) ) / _CaptureSize );
			float4 tex2DNode394 = tex2Dlod( _RenderTexture, float4( temp_output_429_0, 0, 0.0) );
			float temp_output_30_0 = ( 1.0 - tex2DNode394.r );
			float3 appendResult24 = (float3(0.0 , ( temp_output_30_0 * ( _SnowHeight + 0.1 ) ) , 0.0));
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
			float3 ase_worldPos = i.worldPos;
			float2 appendResult425 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_429_0 = ( ( ( appendResult425 + _PositionPlayer ) + ( _CaptureSize / 2.0 ) ) / _CaptureSize );
			float4 tex2DNode394 = tex2D( _RenderTexture, temp_output_429_0 );
			float temp_output_30_0 = ( 1.0 - tex2DNode394.r );
			float4 lerpResult436 = lerp( _Color0 , _Color1 , temp_output_30_0);
			c.rgb = lerpResult436.rgb;
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
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
552;73;927;656;-523.0507;-1468.593;1.078843;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;424;-7048.314,3103.638;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;378;-7052.853,1036.427;Inherit;False;3360.838;632.3541;Comment;20;354;355;356;357;359;358;361;360;363;364;366;365;367;368;369;370;371;372;373;374;Partial Derivative Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;49;-6900.229,3303.901;Inherit;False;Property;_PositionPlayer;Position Player;6;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;428;-6614.352,3348.305;Inherit;False;Property;_CaptureSize;CaptureSize;21;0;Create;True;0;0;False;0;0;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;425;-6801.626,3120.888;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;431;-6526.501,3128.315;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;354;-7002.853,1323.786;Inherit;False;Property;_NormalDerivativeOffset;Normal Derivative Offset;16;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;427;-6401.625,3221.377;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;426;-6255.701,3104.17;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;355;-6665.66,1333.056;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;357;-6367.664,1428.249;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;429;-6052.45,3175.243;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;116;-7228.294,2738.563;Inherit;False;3007;698.6722;Comment;6;3;30;73;36;35;24;Vertex OffSet;1,0.6687182,0,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;356;-6372.246,1261.197;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-7121.387,2859.726;Inherit;True;Property;_RenderTexture;RenderTexture;9;0;Create;True;0;0;False;0;None;9b8ae007f3a4a3e40b310c38adf70137;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;359;-6178.335,1430.819;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;358;-6177.848,1260.736;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;361;-5959.687,1438.781;Inherit;True;Property;_TextureSample2;Texture Sample 2;18;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;360;-5953.114,1228.642;Inherit;True;Property;_TextureSample1;Texture Sample 1;17;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;394;-5830.67,2811.191;Inherit;True;Property;_TextureSample4;Texture Sample 4;19;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;363;-5607.435,1371.777;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;364;-5417.687,1368.48;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;366;-5453.072,1086.427;Inherit;False;Property;_NormalScale;Normal Scale;17;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;365;-5241.172,1130.625;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;367;-5095.572,1225.527;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;368;-4805.572,1308.726;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;369;-4867.472,1498.622;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;370;-4688.658,1422.549;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-5644.293,3042.562;Inherit;False;Property;_SnowHeight;Snow Height;7;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-5260.293,3042.562;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;30;-5388.292,2786.563;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;371;-4557.581,1501.609;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;372;-4407.832,1401.318;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-5004.294,2914.562;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;183;-2438.165,3228.995;Inherit;False;979.6659;587.2239;Comment;8;182;181;180;185;188;186;184;377;N.H;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;348;-1654.33,2270.639;Inherit;False;1451.713;313.418;Comment;9;173;171;169;167;170;166;168;258;175;Rim Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;349;-1262.171,3347.589;Inherit;False;926.609;359.417;Comment;5;194;190;189;192;191;Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;216;-1805.855,2790.237;Inherit;False;812;304;Comment;5;221;220;219;218;217;Attenuation and Ambient;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;133;-1562.038,629.64;Inherit;False;953.9445;475.1312;Comment;5;137;135;134;136;376;N.L;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;352;-1754.617,1270.857;Inherit;False;2035.682;560.9133;Comment;12;315;297;302;304;328;298;321;322;337;330;329;379;Glitter;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;353;380.4566,693.6326;Inherit;False;567.269;552.9442;Comment;3;345;346;347;ToonRamp;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;241;-3245.611,1355.808;Inherit;False;1062.447;468.6189;Comment;8;226;227;225;228;232;229;230;231;Noise Generator;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;161;-2333.693,2199.12;Inherit;False;507.201;385.7996;Comment;3;163;162;164;N . V;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;434;735.5355,1275.056;Inherit;False;Property;_Color0;Color 0;18;0;Create;True;0;0;False;0;1,1,1,0;0.245283,0.09425285,0.05669278,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SqrtOpNode;373;-4230.605,1380.708;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;435;696.6747,1453.976;Inherit;False;Property;_Color1;Color 1;20;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;433;-4213.644,2951.104;Inherit;False;Property;_Debug_Height;Debug_Height;19;0;Create;True;0;0;False;0;0;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-4748.294,2914.562;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;330;-126.3669,1587.281;Inherit;False;Property;_GlitterIntensity;Glitter Intensity;11;0;Create;True;0;0;False;0;0;2.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;189;-1009.665,3397.589;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;376;-1119.958,639.2715;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;328;-1012.605,1651.677;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;220;-1707.455,2838.236;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;226;-2326.783,1527.607;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LightAttenuation;217;-1753.538,2975.628;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;-883.0883,2370.54;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;171;-732.1641,2368.664;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;302;-808.3046,1496.766;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;221;-1149.854,2838.236;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;337;-108.5068,1483.036;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;347;429.9377,1062.127;Inherit;False;Property;_ToonRampTint;ToonRamp Tint;14;0;Create;True;0;0;False;0;0,0,0,0;0.5990566,0.8474843,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;135;-1020.271,771.416;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;304;-1263.58,1647.771;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;432;-4003.681,2806.634;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;258;-1604.33,2338.966;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;329;112.0655,1497.724;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;346;778.7257,978.7869;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;321;-314.7681,1483.98;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;136;-1417.493,931.7491;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;177;492.6093,2194.452;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;137;-792.7621,774.7207;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;345;430.4566,743.6326;Inherit;True;Property;_ToonRamp;ToonRamp;13;0;Create;True;0;0;False;0;-1;None;cadf74cfecacb6f48b4b21ae23815668;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;176;354.5793,1623.607;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;194;-550.2437,3419.57;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;-389.2899,2367.311;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;173;-557.4971,2369.449;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;163;-2176.475,2428.311;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;298;-1556.64,1320.857;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;185;-2091,3573.628;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;229;-2892.403,1506.905;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;232;-2706.196,1536.571;Inherit;False;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;377;-1889.193,3336.682;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;231;-3096.409,1436.906;Float;False;Property;_Size;Size;0;0;Create;True;0;0;False;0;0,0;10000,10000;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WorldNormalVector;180;-2125.1,3313.924;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;182;-2370.407,3661.44;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;228;-2714.548,1698.869;Float;False;Property;_Noise_Strength;Noise_Strength;8;0;Create;True;0;0;False;0;0;0.91;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;166;-1310.679,2320.639;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ReflectOpNode;297;-1252.543,1500.064;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;178;304.3008,2373.38;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;192;-984.4307,3578.332;Inherit;False;Property;_SpecularStrenght;SpecularStrenght;12;0;Create;True;0;0;False;0;0;0.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;230;-3195.612,1607.605;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;181;-2324.017,3506.815;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;219;-1309.854,2950.236;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;227;-2519.432,1634.106;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;162;-2285.693,2247.12;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;322;-614.7195,1630.51;Inherit;False;Property;_Glitter_Threshold;Glitter_Threshold;10;0;Create;True;0;0;False;0;0;0.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;-785.6646,3429.589;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;164;-1983.788,2337.819;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;186;-1578.685,3418.064;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;167;-1107.088,2338.54;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;315;-1774.882,1530.873;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;188;-1714.758,3444.446;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;170;-1069.524,2472.011;Inherit;False;Property;_RimStrenght;RimStrenght;22;0;Create;True;0;0;False;0;0.27;0.48;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;184;-1944.056,3575.243;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;168;-1311.711,2435.472;Inherit;False;Property;_RimPower;RimPower;23;0;Create;True;0;0;False;0;13;8.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;134;-1410.793,686.8013;Inherit;True;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;436;1039.494,1487.235;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;379;-1568.748,1502.449;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;218;-1540.28,2923.231;Inherit;False;Tangent;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;225;-2630.446,1405.807;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;374;-3927.014,1237.106;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;191;-1212.171,3579.457;Inherit;False;Property;_SpecularPower;SpecularPower;15;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1249.168,1459.856;Float;False;True;-1;6;ASEMaterialInspector;0;0;CustomLighting;SnowShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;1;2;10;64;True;0.37;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;1;0;False;0;0;False;-1;-1;0;False;-1;1;Pragma;addshadow;False;;Custom;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;425;0;424;1
WireConnection;425;1;424;3
WireConnection;431;0;425;0
WireConnection;431;1;49;0
WireConnection;427;0;428;0
WireConnection;426;0;431;0
WireConnection;426;1;427;0
WireConnection;355;0;354;0
WireConnection;357;1;355;0
WireConnection;429;0;426;0
WireConnection;429;1;428;0
WireConnection;356;0;355;0
WireConnection;359;0;429;0
WireConnection;359;1;357;0
WireConnection;358;0;429;0
WireConnection;358;1;356;0
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
WireConnection;73;0;36;0
WireConnection;30;0;394;1
WireConnection;371;0;370;0
WireConnection;372;0;371;0
WireConnection;35;0;30;0
WireConnection;35;1;73;0
WireConnection;373;0;372;0
WireConnection;24;1;35;0
WireConnection;189;0;186;0
WireConnection;189;1;191;0
WireConnection;376;0;134;0
WireConnection;376;1;374;0
WireConnection;328;0;304;0
WireConnection;226;0;225;0
WireConnection;226;1;227;0
WireConnection;169;0;167;0
WireConnection;169;1;170;0
WireConnection;171;0;169;0
WireConnection;302;0;297;0
WireConnection;302;1;328;0
WireConnection;221;0;220;0
WireConnection;221;1;219;0
WireConnection;337;0;321;0
WireConnection;135;0;376;0
WireConnection;135;1;136;0
WireConnection;432;0;24;0
WireConnection;432;1;433;0
WireConnection;258;0;164;0
WireConnection;329;0;337;0
WireConnection;329;1;330;0
WireConnection;346;0;345;0
WireConnection;346;1;347;0
WireConnection;321;0;302;0
WireConnection;321;1;322;0
WireConnection;321;2;302;0
WireConnection;177;0;178;0
WireConnection;137;0;135;0
WireConnection;345;1;137;0
WireConnection;176;0;346;0
WireConnection;176;1;329;0
WireConnection;176;2;177;0
WireConnection;194;0;221;0
WireConnection;194;1;190;0
WireConnection;175;0;221;0
WireConnection;175;1;173;0
WireConnection;173;0;171;0
WireConnection;185;0;181;0
WireConnection;185;1;182;0
WireConnection;229;0;231;0
WireConnection;229;1;230;0
WireConnection;232;0;229;0
WireConnection;377;0;180;0
WireConnection;377;1;374;0
WireConnection;166;0;258;0
WireConnection;297;0;298;0
WireConnection;297;1;379;0
WireConnection;178;0;175;0
WireConnection;178;1;194;0
WireConnection;219;0;218;0
WireConnection;219;1;217;0
WireConnection;227;0;232;0
WireConnection;227;1;228;0
WireConnection;190;0;189;0
WireConnection;190;1;192;0
WireConnection;164;0;162;0
WireConnection;164;1;163;0
WireConnection;186;1;188;0
WireConnection;167;0;166;0
WireConnection;167;1;168;0
WireConnection;315;0;226;0
WireConnection;188;0;377;0
WireConnection;188;1;184;0
WireConnection;184;0;185;0
WireConnection;436;0;434;0
WireConnection;436;1;435;0
WireConnection;436;2;30;0
WireConnection;379;0;374;0
WireConnection;379;1;315;0
WireConnection;218;0;374;0
WireConnection;374;0;367;0
WireConnection;374;1;367;1
WireConnection;374;2;373;0
WireConnection;0;13;436;0
WireConnection;0;11;432;0
WireConnection;0;12;374;0
ASEEND*/
//CHKSM=1EA5B29D9BB19F65A8B9DCDB6271ADE0A19EF24F