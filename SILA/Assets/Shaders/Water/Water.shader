// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water"
{
	Properties
	{
		_Glaciation("Glaciation", Float) = -0.001
		_Float0("Float 0", Float) = -0.001
		_WaterColor("WaterColor", Color) = (1,1,1,0)
		_WaterTexture("WaterTexture", 2D) = "white" {}
		_IceColor("IceColor", Color) = (1,1,1,0)
		_IceTexture("Ice Texture", 2D) = "white" {}
		_HeightMap("Height Map", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" }
		Cull Back
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform sampler2D _WaterTexture;
		uniform half4 _WaterTexture_ST;
		uniform half4 _WaterColor;
		uniform sampler2D _IceTexture;
		uniform half4 _IceTexture_ST;
		uniform half4 _IceColor;
		uniform sampler2D _HeightMap;
		uniform half4 _HeightMap_ST;
		uniform float _Float0;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Glaciation;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_WaterTexture = i.uv_texcoord * _WaterTexture_ST.xy + _WaterTexture_ST.zw;
			half4 temp_output_83_0 = ( tex2D( _WaterTexture, uv_WaterTexture ) * _WaterColor );
			float2 uv_IceTexture = i.uv_texcoord * _IceTexture_ST.xy + _IceTexture_ST.zw;
			half4 temp_output_82_0 = ( tex2D( _IceTexture, uv_IceTexture ) * _IceColor );
			float2 uv_HeightMap = i.uv_texcoord * _HeightMap_ST.xy + _HeightMap_ST.zw;
			half4 lerpResult66 = lerp( temp_output_83_0 , temp_output_82_0 , max( ( tex2D( _HeightMap, uv_HeightMap ) * -_Float0 ) , float4( 0,0,0,0 ) ));
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			half eyeDepth4 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half4 lerpResult116 = lerp( temp_output_83_0 , temp_output_82_0 , max( ( abs( ( eyeDepth4 - ase_screenPos.w ) ) * -_Glaciation ) , 0.0 ));
			o.Albedo = ( lerpResult66 + lerpResult116 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17600
271;73;1370;656;-573.1265;205.3777;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;103;-2309.227,619.5706;Inherit;False;1249.992;434.7501;Depth Comparison;9;90;92;62;6;38;5;3;4;2;Depth Comparison;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;2;-2279.068,667.9942;Float;True;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;3;-2245.397,865.8264;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenDepthNode;4;-2028.928,668.1548;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-2076.051,333.804;Float;False;Property;_Float0;Float 0;1;0;Create;True;0;0;False;0;-0.001;0.83;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;5;-1809.505,704.6588;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1771.884,901.7125;Float;False;Property;_Glaciation;Glaciation;0;0;Create;True;0;0;False;0;-0.001;0.83;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;62;-1546.832,906.6765;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;104;-2198.147,-578.3618;Inherit;False;550.8879;482.5717;Material Ice;3;82;81;67;Material Ice;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;105;-2201.818,-1192.257;Inherit;False;594.1552;480.2945;Material Water;3;83;80;68;Material Water;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;110;-2317.992,55.09962;Inherit;True;Property;_HeightMap;Height Map;6;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;6;-1585.016,700.111;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;108;-1850.999,338.768;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;67;-2086.79,-281.1016;Inherit;False;Property;_IceColor;IceColor;4;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;81;-2168.324,-542.749;Inherit;True;Property;_IceTexture;Ice Texture;5;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;80;-2136.909,-1131.135;Inherit;True;Property;_WaterTexture;WaterTexture;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-1410.551,698.2727;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;68;-2065.246,-895.2578;Inherit;False;Property;_WaterColor;WaterColor;2;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-1714.718,130.3637;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-1794.944,-386.5337;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;90;-1215.901,696.5267;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-1778.373,-995.3379;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;106;-1520.068,128.6179;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;66;-974.6801,-511.9334;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;116;-728.7588,276.9751;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;118;-425.3882,-65.54852;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;119;856.5491,77.16675;Inherit;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Translucent;0.5;True;True;0;False;Opaque;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;2;0
WireConnection;5;0;4;0
WireConnection;5;1;3;4
WireConnection;62;0;38;0
WireConnection;6;0;5;0
WireConnection;108;0;109;0
WireConnection;92;0;6;0
WireConnection;92;1;62;0
WireConnection;107;0;110;0
WireConnection;107;1;108;0
WireConnection;82;0;81;0
WireConnection;82;1;67;0
WireConnection;90;0;92;0
WireConnection;83;0;80;0
WireConnection;83;1;68;0
WireConnection;106;0;107;0
WireConnection;66;0;83;0
WireConnection;66;1;82;0
WireConnection;66;2;106;0
WireConnection;116;0;83;0
WireConnection;116;1;82;0
WireConnection;116;2;90;0
WireConnection;118;0;66;0
WireConnection;118;1;116;0
WireConnection;0;0;118;0
ASEEND*/
//CHKSM=2A8D721B4FE1536DE087194CCC3B769E3F818F65