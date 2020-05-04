// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SnowShader"
{
	Properties
	{
		_RenderTextureScale("RenderTextureScale", Float) = 0.1
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 2
		[HideInInspector]_PositionPlayer("Position Player", Vector) = (0,0,0,0)
		_SnowHeight("Snow Height", Range( 0 , 1)) = 0
		_RenderTexture("RenderTexture", 2D) = "white" {}
		_Debug_SnowHeight("Debug_SnowHeight", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma addshadow
		#pragma surface surf StandardCustomLighting keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
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
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult5 = (float2(ase_worldPos.x , ase_worldPos.z));
			float OffSetUV59 = ( _RenderTextureScale / 20.0 );
			float2 temp_output_41_0 = ( ( ( appendResult5 + OffSetUV59 ) + _PositionPlayer ) * ( 10.0 / _RenderTextureScale ) );
			float4 tex2DNode12 = tex2Dlod( _RenderTexture, float4( temp_output_41_0, 0, 0.0) );
			float temp_output_30_0 = ( 1.0 - tex2DNode12.r );
			float3 appendResult24 = (float3(0.0 , ( temp_output_30_0 * ( _SnowHeight + 0.1 ) ) , 0.0));
			v.vertex.xyz += ( _Debug_SnowHeight * appendResult24 );
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			c.rgb = 0;
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
			float2 appendResult393 = (float2(_RenderTextureScale , _RenderTextureScale));
			float2 uv_TexCoord392 = i.uv_texcoord * appendResult393 + _PositionPlayer;
			o.Emission = tex2D( _RenderTexture, uv_TexCoord392 ).rgb;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
1920;0;1280;659;7425.382;-1629.545;1.439023;True;False
Node;AmplifyShaderEditor.CommentaryNode;116;-7051.463,1803.879;Inherit;False;3007;698.6722;Comment;22;4;5;57;50;49;47;41;54;58;43;12;3;30;73;36;35;24;76;59;390;392;393;Vertex OffSet;1,0.6687182,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-6484.66,2328.407;Inherit;False;Property;_RenderTextureScale;RenderTextureScale;0;0;Create;True;0;0;False;0;0.1;42.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;58;-5979.464,2363.879;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-5723.462,2363.879;Inherit;False;OffSetUV;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;4;-7003.463,2107.878;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;57;-6747.464,2235.878;Inherit;False;59;OffSetUV;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;5;-6747.464,2107.878;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;49;-6763.709,2316.017;Inherit;False;Property;_PositionPlayer;Position Player;7;1;[HideInInspector];Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-6491.465,2107.878;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-6235.465,2107.878;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;54;-5979.464,2235.878;Inherit;False;2;0;FLOAT;10;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-5851.463,2107.878;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-6980.238,1862.577;Inherit;True;Property;_RenderTexture;RenderTexture;10;0;Create;True;0;0;False;0;None;9b8ae007f3a4a3e40b310c38adf70137;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-5467.462,2107.878;Inherit;False;Property;_SnowHeight;Snow Height;8;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-5595.462,1851.879;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;30;-5211.461,1851.879;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-5083.462,2107.878;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;393;-6233.971,2290.359;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-4827.463,1979.878;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;241;-3245.611,1355.808;Inherit;False;1062.447;468.6189;Comment;8;226;227;225;228;232;229;230;231;Noise Generator;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;216;-1805.855,2790.237;Inherit;False;812;304;Comment;5;221;220;219;218;217;Attenuation and Ambient;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;349;-1262.171,3347.589;Inherit;False;926.609;359.417;Comment;5;194;190;189;192;191;Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;133;-1562.038,629.64;Inherit;False;953.9445;475.1312;Comment;5;137;135;134;136;376;N.L;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;353;380.4566,693.6326;Inherit;False;567.269;552.9442;Comment;3;345;346;347;ToonRamp;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;352;-1754.617,1270.857;Inherit;False;2035.682;560.9133;Comment;12;315;297;302;304;328;298;321;322;337;330;329;379;Glitter;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;392;-6575.444,1954.181;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;378;-7052.853,1036.427;Inherit;False;3360.838;632.3541;Comment;20;354;355;356;357;359;358;361;360;363;364;366;365;367;368;369;370;371;372;373;374;Partial Derivative Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;348;-1654.33,2270.639;Inherit;False;1451.713;313.418;Comment;9;173;171;169;167;170;166;168;258;175;Rim Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;183;-2438.165,3228.995;Inherit;False;979.6659;587.2239;Comment;8;182;181;180;185;188;186;184;377;N.H;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;161;-2333.693,2199.12;Inherit;False;507.201;385.7996;Comment;3;163;162;164;N . V;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;131;1167.597,1865.507;Inherit;False;Property;_Debug_SnowHeight;Debug_SnowHeight;21;0;Create;True;0;0;False;0;5;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-4571.463,1979.878;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;357;-6367.664,1428.249;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;185;-2091,3573.628;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;371;-4557.581,1501.609;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;345;430.4566,743.6326;Inherit;True;Property;_ToonRamp;ToonRamp;14;0;Create;True;0;0;False;0;-1;None;cadf74cfecacb6f48b4b21ae23815668;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;-883.0883,2370.54;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;167;-1107.088,2338.54;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;170;-1069.524,2472.011;Inherit;False;Property;_RimStrenght;RimStrenght;19;0;Create;True;0;0;False;0;0.27;0.48;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;166;-1310.679,2320.639;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;370;-4688.658,1422.549;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;230;-3195.612,1607.605;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;346;778.7257,978.7869;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;136;-1417.493,931.7491;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;330;-126.3669,1587.281;Inherit;False;Property;_GlitterIntensity;Glitter Intensity;12;0;Create;True;0;0;False;0;0;2.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;364;-5417.687,1368.48;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;180;-2125.1,3313.924;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;258;-1604.33,2338.966;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;219;-1309.854,2950.236;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;376;-1119.958,639.2715;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;171;-732.1641,2368.664;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;226;-2326.783,1527.607;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;328;-1012.605,1651.677;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;220;-1707.455,2838.236;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;163;-2176.475,2428.311;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;229;-2892.403,1506.905;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;231;-3096.409,1436.906;Float;False;Property;_Size;Size;1;0;Create;True;0;0;False;0;0,0;10000,10000;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TFHCRemapNode;355;-6665.66,1333.056;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;186;-1578.685,3418.064;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;366;-5453.072,1086.427;Inherit;False;Property;_NormalScale;Normal Scale;18;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;359;-6178.335,1430.819;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;390;-6319.722,1877.62;Inherit;True;Property;_TextureSample3;Texture Sample 3;18;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;354;-7002.853,1323.786;Inherit;False;Property;_NormalDerivativeOffset;Normal Derivative Offset;17;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;367;-5095.572,1225.527;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;76;-4315.463,1851.879;Inherit;False;Lerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;304;-1263.58,1647.771;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;337;-108.5068,1483.036;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;369;-4867.472,1498.622;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;329;112.0655,1497.724;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;176;976.2072,1496.678;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;377;-1889.193,3336.682;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;164;-1983.788,2337.819;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;302;-808.3046,1496.766;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;361;-5959.687,1438.781;Inherit;True;Property;_TextureSample2;Texture Sample 2;18;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;135;-1020.271,771.416;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;365;-5241.172,1130.625;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;221;-1149.854,2838.236;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;192;-984.4307,3578.332;Inherit;False;Property;_SpecularStrenght;SpecularStrenght;13;0;Create;True;0;0;False;0;0;0.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;137;-792.7621,774.7207;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;194;-550.2437,3419.57;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ReflectOpNode;297;-1252.543,1500.064;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightAttenuation;217;-1753.538,2975.628;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;225;-2630.446,1405.807;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;162;-2285.693,2247.12;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;191;-1212.171,3579.457;Inherit;False;Property;_SpecularPower;SpecularPower;16;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;232;-2706.196,1536.571;Inherit;False;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;379;-1568.748,1502.449;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;182;-2370.407,3661.44;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;189;-1009.665,3397.589;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;360;-5953.114,1228.642;Inherit;True;Property;_TextureSample1;Texture Sample 1;17;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;315;-1774.882,1530.873;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ConditionalIfNode;321;-314.7681,1483.98;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;-389.2899,2367.311;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;298;-1556.64,1320.857;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;322;-614.7195,1630.51;Inherit;False;Property;_Glitter_Threshold;Glitter_Threshold;11;0;Create;True;0;0;False;0;0;0.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;1499.677,1890.634;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;347;429.9377,1062.127;Inherit;False;Property;_ToonRampTint;ToonRamp Tint;15;0;Create;True;0;0;False;0;0,0,0,0;0.5990566,0.8474843,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;173;-557.4971,2369.449;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;368;-4805.572,1308.726;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;228;-2714.548,1698.869;Float;False;Property;_Noise_Strength;Noise_Strength;9;0;Create;True;0;0;False;0;0;0.91;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;181;-2324.017,3506.815;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.IndirectDiffuseLighting;218;-1540.28,2923.231;Inherit;False;Tangent;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;168;-1311.711,2435.472;Inherit;False;Property;_RimPower;RimPower;20;0;Create;True;0;0;False;0;13;8.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;134;-1410.793,686.8013;Inherit;True;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;358;-6177.848,1260.736;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;363;-5607.435,1371.777;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;-785.6646,3429.589;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;372;-4407.832,1401.318;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;356;-6372.246,1261.197;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;177;632.557,2126.105;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;227;-2519.432,1634.106;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;188;-1714.758,3444.446;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;184;-1944.056,3575.243;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;178;304.3008,2373.38;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SqrtOpNode;373;-4230.605,1380.708;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;374;-3927.014,1237.106;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1878.833,1215.502;Float;False;True;-1;6;ASEMaterialInspector;0;0;CustomLighting;SnowShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;2;10;64;False;0.37;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;2;0;False;0;0;False;-1;-1;0;False;-1;1;Pragma;addshadow;False;;Custom;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;58;0;43;0
WireConnection;59;0;58;0
WireConnection;5;0;4;1
WireConnection;5;1;4;3
WireConnection;50;0;5;0
WireConnection;50;1;57;0
WireConnection;47;0;50;0
WireConnection;47;1;49;0
WireConnection;54;1;43;0
WireConnection;41;0;47;0
WireConnection;41;1;54;0
WireConnection;12;0;3;0
WireConnection;12;1;41;0
WireConnection;30;0;12;1
WireConnection;73;0;36;0
WireConnection;393;0;43;0
WireConnection;393;1;43;0
WireConnection;35;0;30;0
WireConnection;35;1;73;0
WireConnection;392;0;393;0
WireConnection;392;1;49;0
WireConnection;24;1;35;0
WireConnection;357;1;355;0
WireConnection;185;0;181;0
WireConnection;185;1;182;0
WireConnection;371;0;370;0
WireConnection;345;1;137;0
WireConnection;169;0;167;0
WireConnection;169;1;170;0
WireConnection;167;0;166;0
WireConnection;167;1;168;0
WireConnection;166;0;258;0
WireConnection;370;0;368;0
WireConnection;370;1;369;0
WireConnection;346;0;345;0
WireConnection;346;1;347;0
WireConnection;364;0;363;0
WireConnection;364;1;12;1
WireConnection;258;0;164;0
WireConnection;219;0;218;0
WireConnection;219;1;217;0
WireConnection;376;0;134;0
WireConnection;376;1;374;0
WireConnection;171;0;169;0
WireConnection;226;0;225;0
WireConnection;226;1;227;0
WireConnection;328;0;304;0
WireConnection;229;0;231;0
WireConnection;229;1;230;0
WireConnection;355;0;354;0
WireConnection;186;1;188;0
WireConnection;359;0;41;0
WireConnection;359;1;357;0
WireConnection;390;0;3;0
WireConnection;390;1;392;0
WireConnection;367;0;365;0
WireConnection;76;0;30;0
WireConnection;337;0;321;0
WireConnection;369;0;367;1
WireConnection;369;1;367;1
WireConnection;329;0;337;0
WireConnection;329;1;330;0
WireConnection;176;0;346;0
WireConnection;176;1;329;0
WireConnection;176;2;177;0
WireConnection;377;0;180;0
WireConnection;377;1;374;0
WireConnection;164;0;162;0
WireConnection;164;1;163;0
WireConnection;302;0;297;0
WireConnection;302;1;328;0
WireConnection;361;0;3;0
WireConnection;361;1;359;0
WireConnection;135;0;376;0
WireConnection;135;1;136;0
WireConnection;365;0;364;0
WireConnection;365;1;366;0
WireConnection;221;0;220;0
WireConnection;221;1;219;0
WireConnection;137;0;135;0
WireConnection;194;0;221;0
WireConnection;194;1;190;0
WireConnection;297;0;298;0
WireConnection;297;1;379;0
WireConnection;232;0;229;0
WireConnection;379;0;374;0
WireConnection;379;1;315;0
WireConnection;189;0;186;0
WireConnection;189;1;191;0
WireConnection;360;0;3;0
WireConnection;360;1;358;0
WireConnection;315;0;226;0
WireConnection;321;0;302;0
WireConnection;321;1;322;0
WireConnection;321;2;302;0
WireConnection;175;0;221;0
WireConnection;175;1;173;0
WireConnection;130;0;131;0
WireConnection;130;1;24;0
WireConnection;173;0;171;0
WireConnection;368;0;367;0
WireConnection;368;1;367;0
WireConnection;218;0;374;0
WireConnection;358;0;41;0
WireConnection;358;1;356;0
WireConnection;363;0;360;1
WireConnection;363;1;361;1
WireConnection;190;0;189;0
WireConnection;190;1;192;0
WireConnection;372;0;371;0
WireConnection;356;0;355;0
WireConnection;177;0;178;0
WireConnection;227;0;232;0
WireConnection;227;1;228;0
WireConnection;188;0;377;0
WireConnection;188;1;184;0
WireConnection;184;0;185;0
WireConnection;178;0;175;0
WireConnection;178;1;194;0
WireConnection;373;0;372;0
WireConnection;374;0;367;0
WireConnection;374;1;367;1
WireConnection;374;2;373;0
WireConnection;0;2;390;0
WireConnection;0;11;130;0
ASEEND*/
//CHKSM=FC4A5286176D6F0EE4EBDC079F2AC6DA91478914