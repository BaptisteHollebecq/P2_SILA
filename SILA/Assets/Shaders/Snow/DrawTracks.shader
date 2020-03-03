Shader "Unlit/DrawSplat"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Coordinate("Coordinate", vector) = (0,0,0,0)
		_Color("Color", Color) = (1, 0, 0, 0)
		Size("Size", Range(1,500)) = 1
		Strenght("Strenght", Range(0,1)) = 1

		FloatDebug("FloatDebug", vector) = (1,1,0,0)

		_Center("Center", vector) = (0,0,0,0)

		__moveDirection("moveDirection", vector) = (0,0,0,0)

		_VRadius("Vignette Radius", Range(0.0, 1.0)) = 0.7
		_VSoft("Vignette Softness", Range(0.0, 1.0)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;

                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed4 _Coordinate, _Color;
			half Size, Strenght;
			float4 FloatDebug;
			float4 _Center;
			float4 _moveDirection;

			float _VRadius;
			float _VSoft;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				o.uv += _moveDirection;

                return o;
            }

			

            fixed4 frag (v2f i) : SV_Target
            {
				
				//float2 UV;

				
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
				
				//i.uv += _moveDirection;



				float draw = pow(saturate(1 - distance(i.uv, _Center.xy)), 500 / Size);
				
				//float draw = pow(saturate(1 - distance(i.uv, _Coordinate.xy)), 500 / Size);

				

				fixed4 drawcol = _Color * (draw * Strenght * 3500/Size);

				float distFromCenter = distance(i.uv.xy, float2(0.5, 0.5));
				float vignette = smoothstep(_VRadius, _VRadius - _VSoft, distFromCenter);
				
				return saturate(vignette*(col + drawcol));
				

            }
            ENDCG
        }
    }
}
