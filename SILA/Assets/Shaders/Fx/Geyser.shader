// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Geyser"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.69
		_Noise("Noise", 2D) = "white" {}
		_Vector3("Vector 3", Vector) = (0.5,0.5,0,0)
		_Vector4("Vector 4", Vector) = (10,10,0,0)
		_NoiseSpeed("NoiseSpeed", Float) = 0
		_Color("Color", Color) = (0,0,0,0)
		_BottomStrenght("BottomStrenght", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color;
		uniform sampler2D _Noise;
		uniform float2 _Vector3;
		uniform float2 _Vector4;
		uniform float _NoiseSpeed;
		uniform float _BottomStrenght;
		uniform float _Cutoff = 0.69;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_output_1_0_g1 = i.uv_texcoord;
			float2 temp_output_11_0_g1 = ( temp_output_1_0_g1 - _Vector3 );
			float2 break18_g1 = temp_output_11_0_g1;
			float2 appendResult19_g1 = (float2(break18_g1.y , -break18_g1.x));
			float dotResult12_g1 = dot( temp_output_11_0_g1 , temp_output_11_0_g1 );
			float2 temp_cast_0 = (( _Time.y * _NoiseSpeed )).xx;
			float4 tex2DNode8 = tex2D( _Noise, ( temp_output_1_0_g1 + ( appendResult19_g1 * ( dotResult12_g1 * _Vector4 ) ) + temp_cast_0 ) );
			o.Emission = ( _Color * tex2DNode8.r ).rgb;
			o.Alpha = 1;
			clip( ( tex2DNode8.r * pow( ( 1.0 - i.uv_texcoord.y ) , ( _BottomStrenght * 25.0 ) ) ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
514;73;949;656;1389.491;-776.9144;1.501712;True;False
Node;AmplifyShaderEditor.TimeNode;26;-1501.484,506.8352;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;-1372.791,753.4969;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;4;0;Create;True;0;0;False;0;0;-1.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1071.166,610.0575;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-742.771,1387.627;Inherit;False;Property;_BottomStrenght;BottomStrenght;6;0;Create;True;0;0;False;0;0;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-1058.74,1160.34;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;36;-739.2499,1551.798;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;False;0;25;25.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1173.182,8.365363;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;11;-1103.566,415.2302;Inherit;False;Property;_Vector4;Vector 4;3;0;Create;True;0;0;False;0;10,10;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;10;-1166.175,217.6626;Inherit;False;Property;_Vector3;Vector 3;2;0;Create;True;0;0;False;0;0.5,0.5;1.31,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;32;-726.4597,1190.444;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;9;-789.1273,302.533;Inherit;True;Radial Shear;-1;;1;c6dc9fc7fa9b08c4d95138f2ae88b526;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-459.9316,1356.575;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-430.959,225.0161;Inherit;True;Property;_Noise;Noise;1;0;Create;True;0;0;False;0;-1;c19c448a89b46d04eae179c56330ddbd;9e8877fb4dbdcaf488014e2235579e1d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;29;-323.5654,-215.3124;Inherit;False;Property;_Color;Color;5;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;34;-475.2306,1159.649;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;158.1858,132.4078;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-34.00403,934.7237;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;23;485.5734,21.77689;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/Geyser;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.69;True;True;0;True;TransparentCutout;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;26;2
WireConnection;25;1;27;0
WireConnection;32;0;31;2
WireConnection;9;1;2;0
WireConnection;9;2;10;0
WireConnection;9;3;11;0
WireConnection;9;4;25;0
WireConnection;37;0;33;0
WireConnection;37;1;36;0
WireConnection;8;1;9;0
WireConnection;34;0;32;0
WireConnection;34;1;37;0
WireConnection;28;0;29;0
WireConnection;28;1;8;1
WireConnection;30;0;8;1
WireConnection;30;1;34;0
WireConnection;23;2;28;0
WireConnection;23;10;30;0
ASEEND*/
//CHKSM=5E708B3CCA47132B59053B02B144802AF93246D1