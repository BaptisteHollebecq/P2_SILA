// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Fire"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_UVNoise("UV Noise", Vector) = (0,0,0,0)
		_FireTexUV("Fire Tex UV", Vector) = (0,0,0,0)
		_Vector0("Vector 0", Vector) = (0,0,0,0)
		_FireTexSpeed("Fire Tex Speed", Vector) = (0,1,0,0)
		_Vector1("Vector 1", Vector) = (0,1,0,0)
		[HDR]_FireColor("Fire Color", Color) = (0,0,0,0)
		_AnimationSpeed("Animation Speed", Vector) = (0,0.2,0,0)
		_ZInt("Z Int", Float) = 0
		_ZCorrection("Z Correction", Float) = 2.5
		_XInt("X Int ", Float) = 0
		_CloudNoise("Cloud Noise", 2D) = "white" {}
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _CloudNoise;
		uniform float2 _AnimationSpeed;
		uniform float4 _UVNoise;
		uniform float _XInt;
		uniform float _ZCorrection;
		uniform float _ZInt;
		uniform float4 _FireColor;
		uniform float2 _FireTexSpeed;
		uniform float4 _FireTexUV;
		uniform float2 _Vector1;
		uniform float4 _Vector0;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float2 appendResult27 = (float2(_UVNoise.x , _UVNoise.y));
			float2 appendResult28 = (float2(_UVNoise.z , _UVNoise.w));
			float2 uv_TexCoord23 = v.texcoord.xy * appendResult27 + appendResult28;
			float2 panner22 = ( _Time.y * _AnimationSpeed + uv_TexCoord23);
			float4 tex2DNode138 = tex2Dlod( _CloudNoise, float4( panner22, 0, 0.0) );
			float smoothstepResult147 = smoothstep( 0.1 , 0.99 , v.texcoord.xy.y);
			float temp_output_190_0 = ( 1.0 - smoothstepResult147 );
			float3 appendResult65 = (float3(( ase_vertex3Pos.x + ( ( ( tex2DNode138.r + -0.5 ) * _XInt ) * temp_output_190_0 ) ) , ase_vertex3Pos.y , ( ase_vertex3Pos.z + ( ( ( tex2DNode138.r * temp_output_190_0 ) + _ZCorrection ) * _ZInt ) )));
			v.vertex.xyz = appendResult65;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult104 = (float2(_FireTexUV.x , _FireTexUV.y));
			float2 appendResult105 = (float2(_FireTexUV.z , _FireTexUV.w));
			float2 uv_TexCoord101 = i.uv_texcoord * appendResult104 + appendResult105;
			float2 panner99 = ( _Time.y * _FireTexSpeed + uv_TexCoord101);
			float2 appendResult175 = (float2(_Vector0.x , _Vector0.y));
			float2 appendResult176 = (float2(_Vector0.z , _Vector0.w));
			float2 uv_TexCoord179 = i.uv_texcoord * appendResult175 + appendResult176;
			float2 panner177 = ( _Time.y * _Vector1 + uv_TexCoord179);
			float smoothstepResult184 = smoothstep( 0.04 , 1.78 , i.uv_texcoord.y);
			float smoothstepResult187 = smoothstep( 0.57 , 0.61 , ( ( tex2D( _CloudNoise, panner99 ).r * tex2D( _CloudNoise, panner177 ).r ) + smoothstepResult184 ));
			o.Emission = ( _FireColor * smoothstepResult187 ).rgb;
			o.Alpha = 1;
			clip( smoothstepResult187 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
287;73;1060;498;2170.604;-82.85085;2.007339;True;False
Node;AmplifyShaderEditor.Vector4Node;26;-2828.477,868.4088;Inherit;False;Property;_UVNoise;UV Noise;1;0;Create;True;0;0;False;0;0,0,0,0;0.05,0.05,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;27;-2598.321,876.4844;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;-2595.629,997.6194;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;103;-3427.36,-699.7126;Inherit;False;Property;_FireTexUV;Fire Tex UV;2;0;Create;True;0;0;False;0;0,0,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;174;-3408.268,-254.9385;Inherit;False;Property;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;0,0,0,0;0.5,0.5,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;35;-2245.725,1222.134;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;176;-3138.064,-123.405;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;175;-3137.88,-226.8734;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;105;-3157.156,-568.179;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;104;-3156.972,-671.6475;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-2365.47,825.3386;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;144;-2220.917,1005.323;Inherit;False;Property;_AnimationSpeed;Animation Speed;7;0;Create;True;0;0;False;0;0,0.2;0,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;148;-1827.993,1577.626;Inherit;False;Constant;_Float2;Float 2;8;0;Create;True;0;0;False;0;0.99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;80;-1924.144,1366.099;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;149;-1827.993,1495.836;Inherit;False;Constant;_Float3;Float 3;8;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;147;-1651.936,1420.977;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;178;-2903.914,56.60619;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;101;-2942.053,-634.4811;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;107;-2887.455,-360.8039;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;180;-2917.391,-81.71111;Inherit;False;Property;_Vector1;Vector 1;5;0;Create;True;0;0;False;0;0,1;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;100;-2900.932,-499.1212;Inherit;False;Property;_FireTexSpeed;Fire Tex Speed;4;0;Create;True;0;0;False;0;0,1;0,1.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;179;-2974.63,-213.3556;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;22;-1967.66,892.6866;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;170;-3272.768,269.4786;Inherit;True;Property;_CloudNoise;Cloud Noise;11;0;Create;True;0;0;False;0;9e8877fb4dbdcaf488014e2235579e1d;9e8877fb4dbdcaf488014e2235579e1d;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;168;-1421.313,924.9287;Inherit;False;Constant;_Float7;Float 7;12;0;Create;True;0;0;False;0;-0.5;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;99;-2651.884,-594.9556;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;177;-2668.343,-177.5455;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;138;-1772.502,851.718;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;False;0;-1;None;9e8877fb4dbdcaf488014e2235579e1d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;190;-1432.397,1426.617;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;167;-1264.53,801.5922;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;185;-2098.004,602.5693;Inherit;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;False;0;0.04;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-1212.703,1379.848;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-776.7316,1308.315;Inherit;False;Property;_ZCorrection;Z Correction;9;0;Create;True;0;0;False;0;2.5;0.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;182;-2232.933,455.7108;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;186;-2092.675,699.194;Inherit;False;Constant;_Float1;Float 1;12;0;Create;True;0;0;False;0;1.78;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;172;-2260.817,-39.76469;Inherit;True;Property;_TextureSample2;Texture Sample 2;12;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;171;-2253.186,-288.2774;Inherit;True;Property;_TextureSample1;Texture Sample 1;12;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;166;-1170.414,923.8596;Inherit;False;Property;_XInt;X Int ;10;0;Create;True;0;0;False;0;0;25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;-1013.676,713.7934;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;164;-814.805,922.5656;Inherit;False;Property;_ZInt;Z Int;8;0;Create;True;0;0;False;0;0;1.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;173;-1872.082,-154.3065;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;157;-564.7114,1130.607;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;184;-1882.605,467.1762;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;-776.145,645.6045;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;183;-1641.393,-143.5302;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;163;-515.9791,874.9651;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;60;-1608.219,462.2115;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;188;-1379.679,-77.96304;Inherit;False;Constant;_Float4;Float 4;12;0;Create;True;0;0;False;0;0.57;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;189;-1387.285,32.32157;Inherit;False;Constant;_Float5;Float 5;12;0;Create;True;0;0;False;0;0.61;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;187;-1169.255,-143.0307;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;116;-1150.758,-347.6584;Inherit;False;Property;_FireColor;Fire Color;6;1;[HDR];Create;True;0;0;False;0;0,0,0,0;768.6772,40.24488,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;64;-446.283,453.8471;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-447.6501,592.6373;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;65;-212.59,503.4306;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-813.4644,-227.1964;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/Fire;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;27;0;26;1
WireConnection;27;1;26;2
WireConnection;28;0;26;3
WireConnection;28;1;26;4
WireConnection;176;0;174;3
WireConnection;176;1;174;4
WireConnection;175;0;174;1
WireConnection;175;1;174;2
WireConnection;105;0;103;3
WireConnection;105;1;103;4
WireConnection;104;0;103;1
WireConnection;104;1;103;2
WireConnection;23;0;27;0
WireConnection;23;1;28;0
WireConnection;147;0;80;2
WireConnection;147;1;149;0
WireConnection;147;2;148;0
WireConnection;101;0;104;0
WireConnection;101;1;105;0
WireConnection;179;0;175;0
WireConnection;179;1;176;0
WireConnection;22;0;23;0
WireConnection;22;2;144;0
WireConnection;22;1;35;0
WireConnection;99;0;101;0
WireConnection;99;2;100;0
WireConnection;99;1;107;0
WireConnection;177;0;179;0
WireConnection;177;2;180;0
WireConnection;177;1;178;0
WireConnection;138;0;170;0
WireConnection;138;1;22;0
WireConnection;190;0;147;0
WireConnection;167;0;138;1
WireConnection;167;1;168;0
WireConnection;81;0;138;1
WireConnection;81;1;190;0
WireConnection;172;0;170;0
WireConnection;172;1;177;0
WireConnection;171;0;170;0
WireConnection;171;1;99;0
WireConnection;165;0;167;0
WireConnection;165;1;166;0
WireConnection;173;0;171;1
WireConnection;173;1;172;1
WireConnection;157;0;81;0
WireConnection;157;1;156;0
WireConnection;184;0;182;2
WireConnection;184;1;185;0
WireConnection;184;2;186;0
WireConnection;169;0;165;0
WireConnection;169;1;190;0
WireConnection;183;0;173;0
WireConnection;183;1;184;0
WireConnection;163;0;157;0
WireConnection;163;1;164;0
WireConnection;187;0;183;0
WireConnection;187;1;188;0
WireConnection;187;2;189;0
WireConnection;64;0;60;1
WireConnection;64;1;169;0
WireConnection;68;0;60;3
WireConnection;68;1;163;0
WireConnection;65;0;64;0
WireConnection;65;1;60;2
WireConnection;65;2;68;0
WireConnection;115;0;116;0
WireConnection;115;1;187;0
WireConnection;0;2;115;0
WireConnection;0;10;187;0
WireConnection;0;11;65;0
ASEEND*/
//CHKSM=03E082A6476240164B23DC6FBD03614A64931006