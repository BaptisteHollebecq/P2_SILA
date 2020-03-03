// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SnowWorldSpace"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 11.7
		_RenderTextureScale("RenderTextureScale", Float) = 0.1
		_PositionPlayer("Position Player", Vector) = (0,0,0,0)
		_OffSet("OffSet", Float) = 0
		_Color1("Color 1", Color) = (0,0,0,0)
		_SnowHeight("Snow Height", Float) = 0
		_Color0("Color 0", Color) = (0,0,0,0)
		_RenderTexture("RenderTexture", 2D) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
		};

		uniform sampler2D _RenderTexture;
		uniform float _OffSet;
		uniform float2 _PositionPlayer;
		uniform float _RenderTextureScale;
		uniform float _SnowHeight;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _TessValue;

		float4 tessFunction( )
		{
			return _TessValue;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult5 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_30_0 = ( 1.0 - tex2Dlod( _RenderTexture, float4( ( ( ( appendResult5 + _OffSet ) + _PositionPlayer ) * _RenderTextureScale ), 0, 0.0) ).r );
			float3 appendResult24 = (float3(0.0 , ( temp_output_30_0 * _SnowHeight ) , 0.0));
			v.vertex.xyz += appendResult24;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 appendResult5 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_30_0 = ( 1.0 - tex2D( _RenderTexture, ( ( ( appendResult5 + _OffSet ) + _PositionPlayer ) * _RenderTextureScale ) ).r );
			float4 lerpResult52 = lerp( _Color0 , _Color1 , temp_output_30_0);
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
402;73;1219;656;2772.911;106.702;2.08085;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;4;-2146.232,527.3959;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;51;-1928.01,744.8699;Inherit;False;Property;_OffSet;OffSet;7;0;Create;True;0;0;False;0;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;5;-1902.307,563.3453;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;49;-1691.633,764.4675;Inherit;False;Property;_PositionPlayer;Position Player;6;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-1666.924,551.4319;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1381.65,782.2259;Inherit;False;Property;_RenderTextureScale;RenderTextureScale;5;0;Create;True;0;0;False;0;0.1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-1446.04,569.0276;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1126.853,564.6272;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-1117.558,271.6989;Inherit;True;Property;_RenderTexture;RenderTexture;11;0;Create;True;0;0;False;0;282ee41e948e9b24996792605533841c;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;12;-782.3618,275.0148;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;30;-479.5383,303.2745;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-458.4708,644.1849;Inherit;False;Property;_SnowHeight;Snow Height;9;0;Create;True;0;0;False;0;0;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;34;-581.7244,-175.9284;Inherit;False;Property;_Color0;Color 0;10;0;Create;True;0;0;False;0;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;53;-606.9937,40.63476;Inherit;False;Property;_Color1;Color 1;8;0;Create;True;0;0;False;0;0,0,0,0;0.2169811,0.2169811,0.2169811,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-283.8597,531.5855;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;52;-256.465,-18.68551;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-184.4055,278.3359;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-5.261775,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;SnowWorldSpace;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;1;11.7;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;4;1
WireConnection;5;1;4;3
WireConnection;50;0;5;0
WireConnection;50;1;51;0
WireConnection;47;0;50;0
WireConnection;47;1;49;0
WireConnection;41;0;47;0
WireConnection;41;1;43;0
WireConnection;12;0;3;0
WireConnection;12;1;41;0
WireConnection;30;0;12;1
WireConnection;35;0;30;0
WireConnection;35;1;36;0
WireConnection;52;0;34;0
WireConnection;52;1;53;0
WireConnection;52;2;30;0
WireConnection;24;1;35;0
WireConnection;0;0;52;0
WireConnection;0;11;24;0
ASEEND*/
//CHKSM=6B7A11BB6A786DB7067646B50F5B24E69AEFEAB1