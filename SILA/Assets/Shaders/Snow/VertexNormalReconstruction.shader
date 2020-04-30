// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASESampleShaders/VertexNormalReconstruction"
{
	Properties
	{
		_Flagalbedo("Flag albedo", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Off
		ZTest LEqual
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			half ASEVFace : VFACE;
			float2 uv_texcoord;
		};

		uniform sampler2D _Flagalbedo;
		uniform float4 _Flagalbedo_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 newVertexPos56 = float3( 0,0,0 );
			v.vertex.xyz = newVertexPos56;
			float3 yDeviation114 = float3( 0,0,0 );
			float3 xDeviation113 = float3( 0,0,0 );
			float3 normalizeResult97 = normalize( cross( ( yDeviation114 - newVertexPos56 ) , ( xDeviation113 - newVertexPos56 ) ) );
			v.normal = normalizeResult97;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 switchResult315 = (((i.ASEVFace>0)?(float3(0,0,1)):(float3(0,0,-1))));
			o.Normal = switchResult315;
			float2 uv_Flagalbedo = i.uv_texcoord * _Flagalbedo_ST.xy + _Flagalbedo_ST.zw;
			o.Albedo = tex2D( _Flagalbedo, uv_Flagalbedo ).rgb;
			o.Smoothness = 0.5;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
400;73;1239;651;2153.81;742.5792;1.851867;True;False
Node;AmplifyShaderEditor.CommentaryNode;77;-916.26,-1110.325;Inherit;False;959.9028;475.1613;simply apply vertex transformation;7;56;312;15;306;294;290;307;new vertex position;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;202;-900.26,265.6749;Inherit;False;1552.676;586.3004;move the position in tangent Y direction by the deviation amount;14;311;310;114;313;292;210;288;209;208;206;207;205;203;204;delta Y position;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;177;-916.26,-454.3251;Inherit;False;1562.402;582.1888;move the position in tangent X direction by the deviation amount;14;308;289;314;309;113;197;293;196;195;198;194;192;200;201;delta X position;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;297;748.0676,-221.25;Inherit;False;927.4102;507.1851;calculated new normal by derivation;8;223;107;224;108;88;93;96;97;new normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;411.74,441.6749;Float;False;yDeviation;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-180.2601,-1030.325;Float;False;newVertexPos;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;411.74,-294.3251;Float;False;xDeviation;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;223;797.7017,-127.0497;Inherit;False;113;xDeviation;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;798.0676,-54.58329;Inherit;False;56;newVertexPos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;224;797.7017,64.95051;Inherit;False;114;yDeviation;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;797.7017,144.9505;Inherit;False;56;newVertexPos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;88;1069.702,-111.0496;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;93;1069.702,64.95051;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;318;1155.447,-846.9138;Inherit;False;461.3383;368.4299;Fix normals for back side faces;3;315;317;316;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;296;-2103.058,329.825;Inherit;False;1078.618;465.5402;object to tangent matrix without tangent sign;5;116;121;125;118;117;Object to tangent matrix;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;295;-1676.502,-439.8432;Inherit;False;645.3955;379.0187;Comment;6;130;199;127;291;112;287;Inputs;1,1,1,1;0;0
Node;AmplifyShaderEditor.CrossProductOpNode;96;1261.702,-31.04957;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;316;1171.447,-798.9138;Float;False;Constant;_Frontnormalvector;Front normal vector;4;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;317;1171.447,-638.9138;Float;False;Constant;_Backnormalvector;Back normal vector;4;0;Create;True;0;0;False;0;0,0,-1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;205;-820.26,569.6749;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;200;-820.26,-358.3251;Inherit;False;199;deviation;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;192;-859.265,-242.8228;Inherit;False;121;ObjectToTangent;1;0;OBJECT;;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.PosVertexDataNode;201;-820.26,-134.3251;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;-132.2601,441.6749;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3x3;0,0,0,0,1,0,0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;293;-116.2601,-182.3251;Inherit;False;291;frequency;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;292;-148.2601,553.675;Inherit;False;291;frequency;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;15;-868.26,-1030.325;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;197;-84.26009,-294.3251;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3x3;0,0,0,0,1,0,0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;291;-1303.459,-277.3988;Float;False;frequency;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CrossProductOpNode;125;-1704.479,423.4396;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;314;219.7399,-294.3251;Inherit;False;Waving Vertex;-1;;16;872b3757863bb794c96291ceeebfb188;0;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;308;91.73989,-118.325;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;312;-404.26,-1030.325;Inherit;False;Waving Vertex;-1;;17;872b3757863bb794c96291ceeebfb188;0;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;208;-420.26,601.6749;Inherit;False;121;ObjectToTangent;1;0;OBJECT;;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.TangentVertexDataNode;118;-2056.479,487.4396;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;309;-132.2601,-22.32506;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.MatrixFromVectors;116;-1528.479,455.4396;Inherit;False;FLOAT3x3;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;310;59.73989,601.6749;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;294;-680.463,-965.8711;Inherit;False;291;frequency;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;311;-148.2601,713.6749;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;194;-564.26,-214.3251;Inherit;False;2;2;0;FLOAT3x3;0,0,0,0,1,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;288;-148.2601,633.6749;Inherit;False;287;amplitude;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-1511.459,-277.3988;Float;False;Property;_Frequency;Frequency;1;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;306;-580.26,-886.3251;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;315;1459.447,-718.9138;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;1363.447,-366.9138;Inherit;False;56;newVertexPos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;305;1325.821,-1067.025;Inherit;True;Property;_Flagalbedo;Flag albedo;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;1379.447,-462.9138;Float;False;Constant;_Smoothness;Smoothness;0;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;97;1485.702,-31.04957;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;203;-804.26,361.6749;Inherit;False;199;deviation;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;209;-372.2601,441.6749;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;199;-1303.459,-181.3987;Float;False;deviation;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;207;-564.26,521.675;Inherit;False;2;2;0;FLOAT3x3;0,0,0,0,1,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;307;-820.26,-806.3251;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;198;-564.26,-342.3251;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-1623.459,-373.3988;Float;False;Property;_Amplitude;Amplitude;0;0;Create;True;0;0;False;0;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;290;-804.26,-886.3251;Inherit;False;287;amplitude;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-1623.459,-181.3987;Float;False;Property;_Normalpositiondeviation;Normal position deviation;2;0;Create;True;0;0;False;0;0.1;0;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;289;-116.2601,-102.325;Inherit;False;287;amplitude;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;313;171.7399,441.6749;Inherit;False;Waving Vertex;-1;;18;872b3757863bb794c96291ceeebfb188;0;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;204;-852.26,473.6749;Inherit;False;121;ObjectToTangent;1;0;OBJECT;;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;287;-1303.459,-373.3988;Float;False;amplitude;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;195;-372.2601,-294.3251;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;196;-420.26,-150.3251;Inherit;False;121;ObjectToTangent;1;0;OBJECT;;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;121;-1272.479,455.4396;Float;False;ObjectToTangent;-1;True;1;0;FLOAT3x3;0,0,0,0,1,0,0,0,1;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.DynamicAppendNode;206;-564.26,393.6749;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;117;-2047.057,631.0461;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1742.518,-706.5498;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ASESampleShaders/VertexNormalReconstruction;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;88;0;223;0
WireConnection;88;1;107;0
WireConnection;93;0;224;0
WireConnection;93;1;108;0
WireConnection;96;0;93;0
WireConnection;96;1;88;0
WireConnection;210;0;209;0
WireConnection;210;1;208;0
WireConnection;197;0;195;0
WireConnection;197;1;196;0
WireConnection;291;0;127;0
WireConnection;125;0;117;0
WireConnection;125;1;118;0
WireConnection;308;0;289;0
WireConnection;308;1;309;1
WireConnection;116;0;125;0
WireConnection;116;1;118;0
WireConnection;116;2;117;0
WireConnection;310;0;288;0
WireConnection;310;1;311;1
WireConnection;194;0;192;0
WireConnection;194;1;201;0
WireConnection;306;0;290;0
WireConnection;306;1;307;1
WireConnection;315;0;316;0
WireConnection;315;1;317;0
WireConnection;97;0;96;0
WireConnection;209;0;206;0
WireConnection;209;1;207;0
WireConnection;199;0;130;0
WireConnection;207;0;204;0
WireConnection;207;1;205;0
WireConnection;198;0;200;0
WireConnection;287;0;112;0
WireConnection;195;0;198;0
WireConnection;195;1;194;0
WireConnection;121;0;116;0
WireConnection;206;1;203;0
WireConnection;0;0;305;0
WireConnection;0;1;315;0
WireConnection;0;4;19;0
WireConnection;0;11;109;0
WireConnection;0;12;97;0
ASEEND*/
//CHKSM=D9E58C000E2F89D01AE2C6DE9790437687C5BF7A