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
		_SnowHeight("Snow Height", Range( 0 , 1)) = 0
		_TextureNeige("Texture Neige", 2D) = "white" {}
		_CouleurNeige("Couleur Neige", Color) = (0,0,0,0)
		_Snow_Metalness("Snow_Metalness", Range( 0 , 1)) = 0
		_Snow_Smoothness("Snow_Smoothness", Range( 0 , 1)) = 0
		_Snow_Emissive("Snow_Emissive", Range( 0 , 1)) = 0
		_TextureSol("Texture Sol", 2D) = "white" {}
		_CouleurSol("Couleur Sol", Color) = (0,0,0,0)
		_GroundMetalness("Ground Metalness", Range( 0 , 1)) = 0
		_GroundSmoothness("Ground Smoothness", Range( 0 , 1)) = 0
		_Ground_Emissive("Ground_Emissive", Range( 0 , 1)) = 0
		_RenderTexture("RenderTexture", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
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
		uniform sampler2D _TextureSol;
		uniform float4 _TextureSol_ST;
		uniform float4 _CouleurSol;
		uniform sampler2D _TextureNeige;
		uniform float4 _TextureNeige_ST;
		uniform float4 _CouleurNeige;
		uniform float _Ground_Emissive;
		uniform float _Snow_Emissive;
		uniform float _GroundMetalness;
		uniform float _Snow_Metalness;
		uniform float _GroundSmoothness;
		uniform float _Snow_Smoothness;
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
			float3 appendResult24 = (float3(0.0 , ( temp_output_30_0 * ( _SnowHeight + 0.1 ) ) , 0.0));
			float3 LocalVertexOffSet82 = appendResult24;
			v.vertex.xyz += LocalVertexOffSet82;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSol = i.uv_texcoord * _TextureSol_ST.xy + _TextureSol_ST.zw;
			float4 Albedo_Ground84 = ( tex2D( _TextureSol, uv_TextureSol ) * _CouleurSol );
			float2 uv_TextureNeige = i.uv_texcoord * _TextureNeige_ST.xy + _TextureNeige_ST.zw;
			float4 Albedo_Snow86 = ( tex2D( _TextureNeige, uv_TextureNeige ) * _CouleurNeige );
			float3 ase_worldPos = i.worldPos;
			float2 appendResult5 = (float2(ase_worldPos.x , ase_worldPos.z));
			float OffSetUV59 = ( _RenderTextureScale / 20.0 );
			float temp_output_30_0 = ( 1.0 - tex2D( _RenderTexture, ( ( ( appendResult5 + OffSetUV59 ) + _PositionPlayer ) * ( 10.0 / _RenderTextureScale ) ) ).r );
			float Lerp76 = temp_output_30_0;
			float4 lerpResult52 = lerp( Albedo_Ground84 , Albedo_Snow86 , Lerp76);
			float4 AlbedoLerp88 = lerpResult52;
			o.Albedo = AlbedoLerp88.rgb;
			float Emissive_Ground107 = _Ground_Emissive;
			float Emissive_Snow109 = _Snow_Emissive;
			float lerpResult112 = lerp( Emissive_Ground107 , Emissive_Snow109 , Lerp76);
			float Emissive_Lerp113 = lerpResult112;
			float3 temp_cast_1 = (Emissive_Lerp113).xxx;
			o.Emission = temp_cast_1;
			float Metalness_Ground90 = _GroundMetalness;
			float Metalness_Snow91 = _Snow_Metalness;
			float lerpResult77 = lerp( Metalness_Ground90 , Metalness_Snow91 , Lerp76);
			float Metalness_Lerp94 = lerpResult77;
			o.Metallic = Metalness_Lerp94;
			float Smoothness_Ground101 = _GroundSmoothness;
			float Smoothness_Snow103 = _Snow_Smoothness;
			float lerpResult96 = lerp( Smoothness_Ground101 , Smoothness_Snow103 , Lerp76);
			float Smoothness_Lerp100 = lerpResult96;
			o.Smoothness = Smoothness_Lerp100;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
610;73;1031;656;6814.606;2044.406;6.314225;True;False
Node;AmplifyShaderEditor.CommentaryNode;116;-6144,-672;Inherit;False;3007;698.6722;Comment;20;4;5;57;50;49;47;41;54;58;43;12;3;30;73;36;35;24;76;82;59;Vertex OffSet;1,0.6687182,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-5328,-176;Inherit;False;Property;_RenderTextureScale;RenderTextureScale;5;0;Create;True;0;0;False;0;0.1;3000;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;58;-5072,-112;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-4816,-112;Inherit;False;OffSetUV;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;4;-6096,-368;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;5;-5840,-368;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-5840,-240;Inherit;False;59;OffSetUV;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-5584,-368;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;49;-5584,-240;Inherit;False;Property;_PositionPlayer;Position Player;6;1;[HideInInspector];Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;54;-5072,-240;Inherit;False;2;0;FLOAT;10;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;117;-2896,-688;Inherit;False;1330;837;Comment;11;63;65;67;84;34;79;102;106;90;107;101;Ground Material;1,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-5328,-368;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;118;-2896,304;Inherit;False;1301;805;Comment;11;108;74;104;103;91;109;66;64;53;68;86;Snow Material;0.2877358,1,0.9294855,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;66;-2848,352;Inherit;True;Property;_TextureNeige;Texture Neige;8;0;Create;True;0;0;False;0;None;24aa62fb12845cc4d9884c1b7a0044df;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-5040,-624;Inherit;True;Property;_RenderTexture;RenderTexture;18;0;Create;True;0;0;False;0;282ee41e948e9b24996792605533841c;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;65;-2848,-624;Inherit;True;Property;_TextureSol;Texture Sol;13;0;Create;True;0;0;False;0;None;9abc037d54c975c48be4e905e9a0b928;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-4944,-368;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;12;-4688,-624;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;53;-2464,608;Inherit;False;Property;_CouleurNeige;Couleur Neige;9;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;34;-2464,-368;Inherit;False;Property;_CouleurSol;Couleur Sol;14;0;Create;True;0;0;False;0;0,0,0,0;0.5660378,0.5660378,0.5660378,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;64;-2464,352;Inherit;True;Property;_TextureSample2;Texture Sample 2;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;63;-2464,-624;Inherit;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;74;-2464,896;Inherit;False;Property;_Snow_Metalness;Snow_Metalness;10;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-2464,-144;Inherit;False;Property;_GroundMetalness;Ground Metalness;15;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-2464,800;Inherit;False;Property;_Snow_Smoothness;Snow_Smoothness;11;0;Create;True;0;0;False;0;0;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;30;-4304,-624;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-2464,48;Inherit;False;Property;_Ground_Emissive;Ground_Emissive;17;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-2464,992;Inherit;False;Property;_Snow_Emissive;Snow_Emissive;12;0;Create;True;0;0;False;0;0;0.4;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-2080,-496;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2080,560;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-4560,-368;Inherit;False;Property;_SnowHeight;Snow Height;7;0;Create;True;0;0;False;0;0;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-2464,-48;Inherit;False;Property;_GroundSmoothness;Ground Smoothness;16;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;76;-3408,-624;Inherit;False;Lerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;90;-1856,-144;Inherit;False;Metalness_Ground;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;101;-1856,-48;Inherit;False;Smoothness_Ground;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-1840,992;Inherit;False;Emissive_Snow;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;-1856,-496;Inherit;False;Albedo_Ground;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-1856,48;Inherit;False;Emissive_Ground;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;-1840,896;Inherit;False;Metalness_Snow;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;86;-1840,560;Inherit;False;Albedo_Snow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;119;-1330,-706;Inherit;False;799;1429;Comment;20;110;87;78;114;111;75;97;98;99;85;93;92;52;77;96;112;88;113;100;94;Lerp;1,0,0.7673602,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;-1840,800;Inherit;False;Smoothness_Snow;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-4176,-368;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-3920,-496;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-1279.569,256;Inherit;False;76;Lerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;87;-1280,480;Inherit;False;86;Albedo_Snow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-1280,-109.7759;Inherit;False;76;Lerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;-1280,-464;Inherit;False;76;Lerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;-1280,608;Inherit;False;76;Lerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-1280,-560;Inherit;False;109;Emissive_Snow;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-1280,-237.7759;Inherit;False;103;Smoothness_Snow;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-1280,352;Inherit;False;84;Albedo_Ground;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-1280,0;Inherit;False;90;Metalness_Ground;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-1280,128;Inherit;False;91;Metalness_Snow;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-1280,-365.7759;Inherit;False;101;Smoothness_Ground;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-1280,-656;Inherit;False;107;Emissive_Ground;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;77;-1008,96;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-3664,-496;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;96;-1008,-256;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;112;-1008,-576;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;52;-1008,464;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-3408,-496;Inherit;False;LocalVertexOffSet;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;88;-800,464;Inherit;False;AlbedoLerp;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;-800,-576;Inherit;False;Emissive_Lerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;100;-800,-256;Inherit;False;Smoothness_Lerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-800,96;Inherit;False;Metalness_Lerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;95;-384,-496;Inherit;False;94;Metalness_Lerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;-384,-400;Inherit;False;100;Smoothness_Lerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-384,-592;Inherit;False;113;Emissive_Lerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-384,-304;Inherit;False;82;LocalVertexOffSet;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;89;-384,-688;Inherit;False;88;AlbedoLerp;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,-688;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;SnowWorldSpace;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;1;32;10;25;True;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;58;0;43;0
WireConnection;59;0;58;0
WireConnection;5;0;4;1
WireConnection;5;1;4;3
WireConnection;50;0;5;0
WireConnection;50;1;57;0
WireConnection;54;1;43;0
WireConnection;47;0;50;0
WireConnection;47;1;49;0
WireConnection;41;0;47;0
WireConnection;41;1;54;0
WireConnection;12;0;3;0
WireConnection;12;1;41;0
WireConnection;64;0;66;0
WireConnection;63;0;65;0
WireConnection;30;0;12;1
WireConnection;67;0;63;0
WireConnection;67;1;34;0
WireConnection;68;0;64;0
WireConnection;68;1;53;0
WireConnection;76;0;30;0
WireConnection;90;0;79;0
WireConnection;101;0;102;0
WireConnection;109;0;108;0
WireConnection;84;0;67;0
WireConnection;107;0;106;0
WireConnection;91;0;74;0
WireConnection;86;0;68;0
WireConnection;103;0;104;0
WireConnection;73;0;36;0
WireConnection;35;0;30;0
WireConnection;35;1;73;0
WireConnection;77;0;93;0
WireConnection;77;1;92;0
WireConnection;77;2;78;0
WireConnection;24;1;35;0
WireConnection;96;0;97;0
WireConnection;96;1;98;0
WireConnection;96;2;99;0
WireConnection;112;0;110;0
WireConnection;112;1;111;0
WireConnection;112;2;114;0
WireConnection;52;0;85;0
WireConnection;52;1;87;0
WireConnection;52;2;75;0
WireConnection;82;0;24;0
WireConnection;88;0;52;0
WireConnection;113;0;112;0
WireConnection;100;0;96;0
WireConnection;94;0;77;0
WireConnection;0;0;89;0
WireConnection;0;2;115;0
WireConnection;0;3;95;0
WireConnection;0;4;105;0
WireConnection;0;11;83;0
ASEEND*/
//CHKSM=9085668A5C1BE701CF5EA2B370A546E0536DC76D