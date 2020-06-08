// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/WaterSample"
{
	Properties
	{
		_WaterNormal("Water Normal", 2D) = "bump" {}
		_NormalScale("Normal Scale", Float) = 0
		_WaveSpeed("Wave Speed", Float) = 0
		_WaterSpecular("Water Specular", Range( 0 , 1)) = 0
		_WaterSmoothness("Water Smoothness", Range( 0 , 1)) = 0
		_Distortion("Distortion", Float) = 0.5
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		_Dist("Dist", Float) = 1500
		_IceNormal("Ice Normal", 2D) = "bump" {}
		[HDR]_IceColor("Ice Color", Color) = (0,2.682353,4,0)
		[NoScaleOffset]_IceParallax("Ice Parallax", 2D) = "white" {}
		[HDR]_Color1("Color 1", Color) = (0,0,0,0)
		_IceSpecular("Ice Specular", Range( 0 , 1)) = 0
		_IceSmoothness("Ice Smoothness", Range( 0 , 1)) = 0
		_Glaciation("Glaciation", Range( 0 , 1)) = 0
		_DepthTransparency("Depth Transparency", Float) = 0
		_Float0("Float 0", Range( 0 , 1)) = 0
		_Float1("Float 1", Range( 0 , 1)) = 0
		_HeightParallax("Height Parallax", Float) = 0
		_HeightParallax2("Height Parallax 2", Float) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf StandardSpecular keepalpha 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			half3 viewDir;
			INTERNAL_DATA
		};

		uniform sampler2D _IceNormal;
		uniform half4 _IceNormal_ST;
		uniform sampler2D _WaterNormal;
		uniform float _NormalScale;
		uniform half _WaveSpeed;
		uniform float4 _WaterNormal_ST;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform half _Dist;
		uniform half _Glaciation;
		uniform sampler2D _IceParallax;
		uniform float4 _IceNormal_ST;
		uniform half _HeightParallax;
		uniform half _HeightParallax2;
		uniform half4 _Color1;
		uniform sampler2D _Albedo;
		uniform half4 _IceColor;
		uniform half _DepthTransparency;
		uniform half _Float0;
		uniform half _Float1;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _Distortion;
		uniform float _IceSpecular;
		uniform float _WaterSpecular;
		uniform float _IceSmoothness;
		uniform float _WaterSmoothness;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_IceNormal = i.uv_texcoord * _IceNormal_ST.xy + _IceNormal_ST.zw;
			half2 temp_cast_0 = (_WaveSpeed).xx;
			float2 uv0_WaterNormal = i.uv_texcoord * _WaterNormal_ST.xy + _WaterNormal_ST.zw;
			half2 panner22 = ( 1.0 * _Time.y * temp_cast_0 + uv0_WaterNormal);
			half2 temp_cast_1 = (_WaveSpeed).xx;
			half2 panner19 = ( 1.0 * _Time.y * temp_cast_1 + uv0_WaterNormal);
			half3 temp_output_24_0 = BlendNormals( UnpackScaleNormal( tex2D( _WaterNormal, panner22 ), _NormalScale ) , UnpackScaleNormal( tex2D( _WaterNormal, panner19 ), _NormalScale ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			half4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth168 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half distanceDepth168 = abs( ( screenDepth168 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( pow( _Dist , _Glaciation ) ) );
			half clampResult171 = clamp( distanceDepth168 , 0.0 , 1.0 );
			half3 lerpResult181 = lerp( UnpackNormal( tex2D( _IceNormal, uv_IceNormal ) ) , temp_output_24_0 , clampResult171);
			o.Normal = lerpResult181;
			float2 uv0_IceNormal = i.uv_texcoord * _IceNormal_ST.xy + _IceNormal_ST.zw;
			half2 Offset263 = ( ( _HeightParallax - 1 ) * ( i.viewDir.xy / i.viewDir.z ) * 1.0 ) + uv0_IceNormal;
			half2 Offset264 = ( ( _HeightParallax2 - 1 ) * ( i.viewDir.xy / i.viewDir.z ) * 1.0 ) + uv0_IceNormal;
			half4 temp_output_222_0 = ( ( ( saturate( ( tex2D( _IceParallax, uv0_IceNormal ).r + tex2D( _IceParallax, Offset263 ).r + tex2D( _IceParallax, Offset264 ).r ) ) * _Color1 ) + ( tex2D( _Albedo, uv0_IceNormal ) * _IceColor ) ) + float4( 0,0,0,0 ) );
			float screenDepth244 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half distanceDepth244 = abs( ( screenDepth244 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthTransparency ) );
			half clampResult246 = clamp( distanceDepth244 , _Float0 , _Float1 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			half4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor65 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( half3( (ase_grabScreenPosNorm).xy ,  0.0 ) + ( temp_output_24_0 * _Distortion ) ).xy);
			half4 lerpResult93 = lerp( ( temp_output_222_0 + clampResult246 ) , screenColor65 , clampResult171);
			o.Albedo = lerpResult93.rgb;
			half lerpResult130 = lerp( _IceSpecular , _WaterSpecular , clampResult171);
			half3 temp_cast_5 = (lerpResult130).xxx;
			o.Specular = temp_cast_5;
			half lerpResult133 = lerp( _IceSmoothness , _WaterSmoothness , clampResult171);
			o.Smoothness = lerpResult133;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
202;73;1261;656;-37.46179;1522.443;2.630603;True;False
Node;AmplifyShaderEditor.RangedFloatNode;268;-4835.054,-4041.481;Inherit;False;Property;_HeightParallax;Height Parallax;20;0;Create;True;0;0;False;0;0;0.95;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;265;-4846.307,-3815.882;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;267;-4834.775,-3909.194;Inherit;False;Constant;_Float2;Float 2;22;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;272;-4921.53,-4350.472;Inherit;False;0;183;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;151;-2399.59,-1029.511;Inherit;False;1281.603;457.1994;Blend panning normals to fake noving ripples;8;19;23;24;21;22;17;48;167;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;270;-4828.725,-3539.056;Inherit;False;Property;_HeightParallax2;Height Parallax 2;21;0;Create;True;0;0;False;0;0.5;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;263;-4315.044,-4002.499;Inherit;False;Planar;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-2349.59,-952.212;Inherit;False;0;17;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;193;-4330.819,-4507.118;Inherit;True;Property;_IceParallax;Ice Parallax;10;1;[NoScaleOffset];Create;True;0;0;False;0;None;77b5ab2a32417dd4a88fd15902b3a59d;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;167;-2340.698,-750.8057;Inherit;False;Property;_WaveSpeed;Wave Speed;2;0;Create;True;0;0;False;0;0;0.007;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;264;-4294.629,-3649.281;Inherit;False;Planar;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;22;-2076.891,-979.5109;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.03,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;19;-2074.59,-867.0118;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.04,0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-2020.991,-742.4124;Float;False;Property;_NormalScale;Normal Scale;1;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;261;-3788.286,-3996.372;Inherit;True;Property;_TextureSample3;Texture Sample 3;23;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;260;-3788.285,-4318.963;Inherit;True;Property;_TextureSample2;Texture Sample 2;22;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;262;-3806.661,-3659.49;Inherit;True;Property;_TextureSample4;Texture Sample 4;24;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;271;-3168.805,-4305.427;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;-1732.891,-971.212;Inherit;True;Property;_Normal2;Normal2;0;0;Create;True;0;0;False;0;-1;None;None;True;0;True;bump;Auto;True;Instance;17;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;17;-1719.99,-761.3113;Inherit;True;Property;_WaterNormal;Water Normal;0;0;Create;True;0;0;False;0;-1;None;7396d8283d9546a47b19041de42366c3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;211;-2547.775,-4027.896;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;150;-982.9236,-1041.847;Inherit;False;985.6011;418.6005;Get screen color for refraction and disturbe it with normals;7;96;97;98;65;149;164;165;;1,1,1,1;0;0
Node;AmplifyShaderEditor.BlendNormalsNode;24;-1344.988,-822.7117;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;214;-1557.152,-3959.16;Inherit;False;Property;_Color1;Color 1;11;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.3434941,0.6557599,0.7830189,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;212;-2499.775,-4635.896;Inherit;True;Property;_Albedo;Albedo;6;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;732858e138af22f4b8954569440f82b9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;213;-2403.775,-4379.896;Inherit;False;Property;_IceColor;Ice Color;9;1;[HDR];Create;True;0;0;False;0;0,2.682353,4,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;245;-1007.962,-3555.68;Inherit;False;Property;_DepthTransparency;Depth Transparency;16;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;164;-938.8168,-982.4891;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;218;-1654.694,-4635.856;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;219;-1305.747,-4188.704;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;169;-1180.207,-182.6573;Inherit;False;Property;_Dist;Dist;7;0;Create;True;0;0;False;0;1500;650;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-740.0237,-743.2466;Float;False;Property;_Distortion;Distortion;5;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;149;-962.6251,-728.9456;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;226;-1242.246,49.60068;Inherit;False;Property;_Glaciation;Glaciation;15;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;244;-703.5444,-3580.508;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;221;-774.2805,-4218.703;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;253;-443.1987,-3307.251;Inherit;False;Property;_Float1;Float 1;18;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;165;-635.4694,-925.3549;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;229;-962.8495,-206.2957;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;251;-427.0464,-3432.063;Inherit;False;Property;_Float0;Float 0;17;0;Create;True;0;0;False;0;0;0.788;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-561.9224,-819.8467;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;246;-85.19934,-3581.367;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;168;-746.6857,-222.9147;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;-408.8237,-886.7469;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;222;-369.5121,-4299.476;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;132;914.3978,-199.48;Float;False;Property;_IceSmoothness;Ice Smoothness;13;0;Create;True;0;0;False;0;0;0.654;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;257;317.3427,-3530.927;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;26;920.1959,-279.1855;Float;False;Property;_WaterSmoothness;Water Smoothness;4;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;65;-217.3225,-890.547;Float;False;Global;_WaterGrab;WaterGrab;-1;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;171;-463.4015,-208.3623;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;183;1003.588,-943.3737;Inherit;True;Property;_IceNormal;Ice Normal;8;0;Create;True;0;0;False;0;-1;None;cd93b77a2b8fe68489720b1c3bb3b3e1;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;104;753.9969,-565.4819;Float;False;Property;_WaterSpecular;Water Specular;3;0;Create;True;0;0;False;0;0;0.35;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;756.1969,-467.1806;Float;False;Property;_IceSpecular;Ice Specular;12;0;Create;True;0;0;False;0;0;0.641;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;133;1313.185,-175.8279;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;231;-1977.974,-3177.75;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;108;-371.551,-2737.206;Float;False;Constant;_Color0;Color 0;-1;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;236;-1038,-3426.146;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;233;-1675.472,-3158.405;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenColorNode;232;-1410.358,-3155.617;Inherit;False;Global;_GrabScreen0;Grab Screen 0;18;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;130;1095.124,-475.0168;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;181;1554.643,-780.2902;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;93;1556.517,-1043.786;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;237;-1482.745,-3359.205;Inherit;False;Property;_IceTransparency;Ice Transparency;14;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;258;-268.6682,-492.9564;Inherit;True;Property;_TextureSample1;Texture Sample 1;19;0;Create;True;0;0;False;0;-1;None;d4ef717bdd61a1b4bb34a8626107aefe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;259;368.9596,-434.5088;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;243;276.6246,-3824.867;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2341.527,-760.2894;Half;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Custom/WaterSample;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Translucent;0.5;True;False;0;False;Opaque;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;174;-2406.737,-1235.138;Inherit;False;100;100;Comment;0;Water Material;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;175;-2313.285,-3301.952;Inherit;False;100;100;Comment;0;Ice Material;1,1,1,1;0;0
WireConnection;263;0;272;0
WireConnection;263;1;268;0
WireConnection;263;2;267;0
WireConnection;263;3;265;0
WireConnection;264;0;272;0
WireConnection;264;1;270;0
WireConnection;264;2;267;0
WireConnection;264;3;265;0
WireConnection;22;0;21;0
WireConnection;22;2;167;0
WireConnection;19;0;21;0
WireConnection;19;2;167;0
WireConnection;261;0;193;0
WireConnection;261;1;263;0
WireConnection;260;0;193;0
WireConnection;260;1;272;0
WireConnection;262;0;193;0
WireConnection;262;1;264;0
WireConnection;271;0;260;1
WireConnection;271;1;261;1
WireConnection;271;2;262;1
WireConnection;23;1;22;0
WireConnection;23;5;48;0
WireConnection;17;1;19;0
WireConnection;17;5;48;0
WireConnection;211;0;271;0
WireConnection;24;0;23;0
WireConnection;24;1;17;0
WireConnection;212;1;272;0
WireConnection;218;0;212;0
WireConnection;218;1;213;0
WireConnection;219;0;211;0
WireConnection;219;1;214;0
WireConnection;149;0;24;0
WireConnection;244;0;245;0
WireConnection;221;0;219;0
WireConnection;221;1;218;0
WireConnection;165;0;164;0
WireConnection;229;0;169;0
WireConnection;229;1;226;0
WireConnection;98;0;149;0
WireConnection;98;1;97;0
WireConnection;246;0;244;0
WireConnection;246;1;251;0
WireConnection;246;2;253;0
WireConnection;168;0;229;0
WireConnection;96;0;165;0
WireConnection;96;1;98;0
WireConnection;222;0;221;0
WireConnection;257;0;222;0
WireConnection;257;1;246;0
WireConnection;65;0;96;0
WireConnection;171;0;168;0
WireConnection;133;0;132;0
WireConnection;133;1;26;0
WireConnection;133;2;171;0
WireConnection;236;0;232;0
WireConnection;236;1;237;0
WireConnection;233;0;231;0
WireConnection;232;0;233;0
WireConnection;130;0;131;0
WireConnection;130;1;104;0
WireConnection;130;2;171;0
WireConnection;181;0;183;0
WireConnection;181;1;24;0
WireConnection;181;2;171;0
WireConnection;93;0;257;0
WireConnection;93;1;65;0
WireConnection;93;2;171;0
WireConnection;259;0;258;1
WireConnection;259;2;226;0
WireConnection;243;0;222;0
WireConnection;243;1;246;0
WireConnection;0;0;93;0
WireConnection;0;1;181;0
WireConnection;0;3;130;0
WireConnection;0;4;133;0
ASEEND*/
//CHKSM=1BA4A36FC42B0D8BE6B70028E9E5C6D8EA019231