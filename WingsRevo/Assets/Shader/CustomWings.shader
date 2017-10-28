Shader "Unlit/CustomWings"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MaskTex("Mask Texture", 2D) = "white" {}
		_Speed ("Speed", Float) = 1.0
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 100
		Blend One One // Additive
		Cull Off
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
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

			sampler2D	_MainTex;
			float4		_MainTex_ST;
			sampler2D	_MaskTex;
			float		_Speed;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float2 mainUV = TRANSFORM_TEX(i.uv, _MainTex);
				// sample the texture
				fixed4 col = tex2D(_MainTex, mainUV - float2(1, 0) * _Speed * _Time.x);
			fixed4 maskCol = tex2D(_MaskTex, i.uv);
				return col * maskCol;
			}
			ENDCG
		}
	}
}
