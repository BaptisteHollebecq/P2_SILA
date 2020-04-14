// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water"
{
	Properties
	{
		_Glaciation("Glaciation", Range( 0 , 1)) = -0.001
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
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma target 3.5
		#pragma surface surf Standard alpha:fade keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform sampler2D _IceTexture;
		uniform half4 _IceTexture_ST;
		uniform half4 _IceColor;
		uniform sampler2D _HeightMap;
		uniform half4 _HeightMap_ST;
		uniform sampler2D _WaterTexture;
		uniform half4 _WaterTexture_ST;
		uniform half4 _WaterColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Glaciation;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_IceTexture = i.uv_texcoord * _IceTexture_ST.xy + _IceTexture_ST.zw;
			float2 uv_HeightMap = i.uv_texcoord * _HeightMap_ST.xy + _HeightMap_ST.zw;
			half4 temp_cast_0 = (-0.4477656).xxxx;
			half4 IceMaterial125 = ( ( tex2D( _IceTexture, uv_IceTexture ) * _IceColor ) * pow( tex2D( _HeightMap, uv_HeightMap ) , temp_cast_0 ) );
			float2 uv_WaterTexture = i.uv_texcoord * _WaterTexture_ST.xy + _WaterTexture_ST.zw;
			half4 WaterMaterial123 = ( tex2D( _WaterTexture, uv_WaterTexture ) * _WaterColor );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			half eyeDepth4 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half clampResult121 = clamp( ( abs( ( eyeDepth4 - ase_screenPos.w ) ) * ( ( _Glaciation * -1.0 ) + 1.0 ) ) , 0.0 , 1.0 );
			half DepthComparison129 = clampResult121;
			half4 lerpResult116 = lerp( IceMaterial125 , WaterMaterial123 , DepthComparison129);
			o.Albedo = lerpResult116.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
534;52;1255;874;2249.611;999.5987;2.592246;True;False
Node;AmplifyShaderEditor.CommentaryNode;103;-1839.314,560.2231;Inherit;False;1914.458;431.415;Depth Comparison;11;129;121;92;167;6;5;4;3;2;38;179;Depth Comparison;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;2;-1806.295,602.0863;Float;True;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenDepthNode;4;-1493.831,602.2469;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1312.738,868.8684;Float;False;Property;_Glaciation;Glaciation;0;0;Create;True;0;0;False;0;-0.001;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;3;-1811.576,809.759;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;104;-1537.484,-653.8917;Inherit;False;1131.873;915.6697;Material Ice;8;125;133;134;82;110;109;67;81;Material Ice;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-982.992,867.3624;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;5;-1160.165,605.9489;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-1434.803,152.6345;Float;False;Constant;_IceMapPower;Ice Map Power;1;0;Create;True;0;0;False;0;-0.4477656;-1;-1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;67;-1426.128,-356.6315;Inherit;False;Property;_IceColor;IceColor;3;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;105;-1533.422,-1386.916;Inherit;False;861.7604;494.379;Material Water;4;123;83;68;80;Material Water;1,1,1,1;0;0
Node;AmplifyShaderEditor.AbsOpNode;6;-807.1849,621.0822;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;110;-1471.832,-93.51141;Inherit;True;Property;_HeightMap;Height Map;5;0;Create;True;0;0;False;0;-1;None;00423043146f0f14ea218603008fa147;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;81;-1507.661,-618.279;Inherit;True;Property;_IceTexture;Ice Texture;4;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;167;-809.2987,868.382;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;134;-982.611,-40.61314;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-589.675,615.9638;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;80;-1468.513,-1325.794;Inherit;True;Property;_WaterTexture;WaterTexture;2;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;68;-1396.851,-1089.917;Inherit;False;Property;_WaterColor;WaterColor;1;0;Create;True;0;0;False;0;1,1,1,0;0,0.9625001,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-1134.282,-462.0636;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-862.3871,-358.4781;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-1109.978,-1189.997;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;121;-404.7088,615.0492;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;125;-641.7077,-365.6181;Inherit;False;IceMaterial;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-905.0609,-1216.905;Inherit;False;WaterMaterial;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;-182.4552,582.6917;Inherit;False;DepthComparison;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;-165.0789,-249.6435;Inherit;False;129;DepthComparison;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-162.8977,-366.5778;Inherit;False;123;WaterMaterial;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;127;-158.0591,-491.2556;Inherit;False;125;IceMaterial;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;116;151.3885,-414.9324;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;483.2111,-417.4637;Half;False;True;-1;3;ASEMaterialInspector;0;0;Standard;Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;2;0
WireConnection;179;0;38;0
WireConnection;5;0;4;0
WireConnection;5;1;3;4
WireConnection;6;0;5;0
WireConnection;167;0;179;0
WireConnection;134;0;110;0
WireConnection;134;1;109;0
WireConnection;92;0;6;0
WireConnection;92;1;167;0
WireConnection;82;0;81;0
WireConnection;82;1;67;0
WireConnection;133;0;82;0
WireConnection;133;1;134;0
WireConnection;83;0;80;0
WireConnection;83;1;68;0
WireConnection;121;0;92;0
WireConnection;125;0;133;0
WireConnection;123;0;83;0
WireConnection;129;0;121;0
WireConnection;116;0;127;0
WireConnection;116;1;126;0
WireConnection;116;2;130;0
WireConnection;0;0;116;0
ASEEND*/
//CHKSM=95FB41672297959C1823680233A9AB88DC2993FF