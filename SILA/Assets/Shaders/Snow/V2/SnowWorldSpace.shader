// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SnowWorldSpace"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 32
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.5
		_RenderTextureScale("RenderTextureScale", Float) = 0.1
		[HideInInspector]_PositionPlayer("Position Player", Vector) = (0,0,0,0)
		_CouleurNeige("Couleur Neige", Color) = (0,0,0,0)
		_SnowHeight("Snow Height", Range( 0 , 1)) = 0
		_CouleurSol("Couleur Sol", Color) = (0,0,0,0)
		_TextureSol("Texture Sol", 2D) = "white" {}
		_RenderTexture("RenderTexture", 2D) = "white" {}
		_TextureNeige("Texture Neige", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform sampler2D _RenderTexture;
		uniform float _RenderTextureScale;
		uniform float2 _PositionPlayer;
		uniform float _SnowHeight;
		uniform float4 _CouleurSol;
		uniform sampler2D _TextureSol;
		uniform float4 _TextureSol_ST;
		uniform sampler2D _TextureNeige;
		uniform float4 _TextureNeige_ST;
		uniform float4 _CouleurNeige;
		uniform float _TessValue;
		uniform float _TessPhongStrength;

		float4 tessFunction( )
		{
			return _TessValue;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult5 = (float2(ase_worldPos.x , ase_worldPos.z));
			float OffSetUV59 = ( _RenderTextureScale / 20.0 );
			float temp_output_30_0 = ( 1.0 - tex2Dlod( _RenderTexture, float4( ( ( ( appendResult5 + OffSetUV59 ) + _PositionPlayer ) * ( 10.0 / _RenderTextureScale ) ), 0, 0.0) ).r );
			float3 appendResult24 = (float3(0.0 , ( temp_output_30_0 * _SnowHeight ) , 0.0));
			v.vertex.xyz += appendResult24;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSol = i.uv_texcoord * _TextureSol_ST.xy + _TextureSol_ST.zw;
			float2 uv_TextureNeige = i.uv_texcoord * _TextureNeige_ST.xy + _TextureNeige_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult5 = (float2(ase_worldPos.x , ase_worldPos.z));
			float OffSetUV59 = ( _RenderTextureScale / 20.0 );
			float temp_output_30_0 = ( 1.0 - tex2D( _RenderTexture, ( ( ( appendResult5 + OffSetUV59 ) + _PositionPlayer ) * ( 10.0 / _RenderTextureScale ) ) ).r );
			float4 lerpResult52 = lerp( ( _CouleurSol * tex2D( _TextureSol, uv_TextureSol ) ) , ( tex2D( _TextureNeige, uv_TextureNeige ) * _CouleurNeige ) , temp_output_30_0);
			o.Albedo = lerpResult52.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
432;73;1189;656;2005.779;545.5788;2.251337;True;False
Node;AmplifyShaderEditor.RangedFloatNode;43;-1500.078,776.6018;Inherit;False;Property;_RenderTextureScale;RenderTextureScale;5;0;Create;True;0;0;False;0;0.1;3000;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;58;-1246.262,882.8358;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;4;-2146.232,527.3959;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-1074.055,867.9121;Inherit;False;OffSetUV;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;5;-1902.307,563.3453;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-1940.73,688.2903;Inherit;False;59;OffSetUV;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-1666.924,563.9495;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;49;-1713.987,713.8911;Inherit;False;Property;_PositionPlayer;Position Player;6;1;[HideInInspector];Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-1446.04,569.0276;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;54;-1255.487,690.502;Inherit;False;2;0;FLOAT;10;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-1156.807,280.1094;Inherit;True;Property;_RenderTexture;RenderTexture;11;0;Create;True;0;0;False;0;282ee41e948e9b24996792605533841c;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1126.853,564.6272;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;65;-1373.241,-673.7151;Inherit;True;Property;_TextureSol;Texture Sol;10;0;Create;True;0;0;False;0;None;9abc037d54c975c48be4e905e9a0b928;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;12;-814.3293,281.8651;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;66;-1184.532,-211.6602;Inherit;True;Property;_TextureNeige;Texture Neige;12;0;Create;True;0;0;False;0;None;24aa62fb12845cc4d9884c1b7a0044df;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-571.744,658.4592;Inherit;False;Property;_SnowHeight;Snow Height;8;0;Create;True;0;0;False;0;0;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;30;-479.5383,303.2745;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;63;-1014.506,-664.4597;Inherit;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;34;-929.4601,-875.0977;Inherit;False;Property;_CouleurSol;Couleur Sol;9;0;Create;True;0;0;False;0;0,0,0,0;0.5660378,0.5660378,0.5660378,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;53;-853.069,81.80106;Inherit;False;Property;_CouleurNeige;Couleur Neige;7;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;64;-885.126,-206.1652;Inherit;True;Property;_TextureSample2;Texture Sample 2;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-276.3492,526.5786;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-440.9941,-710.9042;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-571.5624,-12.43447;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;52;-256.465,-18.68551;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-184.4055,278.3359;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-5.261775,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;SnowWorldSpace;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;1;32;10;25;True;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
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
WireConnection;63;0;65;0
WireConnection;64;0;66;0
WireConnection;35;0;30;0
WireConnection;35;1;36;0
WireConnection;67;0;34;0
WireConnection;67;1;63;0
WireConnection;68;0;64;0
WireConnection;68;1;53;0
WireConnection;52;0;67;0
WireConnection;52;1;68;0
WireConnection;52;2;30;0
WireConnection;24;1;35;0
WireConnection;0;0;52;0
WireConnection;0;11;24;0
ASEEND*/
//CHKSM=49B5B7962570841682F83037271F7FAA38168190