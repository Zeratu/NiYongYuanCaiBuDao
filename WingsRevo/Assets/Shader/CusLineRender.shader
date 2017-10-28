Shader "Unlit/CusLineRender"
{
	Properties
	{
		_MainCol ("Main Color", Color) = (1, 1, 1, 1)
		_MainTex ("Texture", 2D) = "white" {}
		_MaskTex ("Mask", 2D) = "white" {}
		_Para ("Offset Para", Float) = 1.0
		_ParaScale ("Scale Para", Float) = 1.0
		_MainSpeed ("main speed", Float) = 1.0
	}
	
	SubShader
	{
		Tags { "RenderType" = "Transparent" "Queue"="Transparent"}
		Blend OneMinusDstColor One // Soft Additive
		Cull Off
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			float4x4	_CustomCurrentObject2World;
			float4x4	_CustomLastObject2World;
			float		_NumberOfLines;
			float		_Para;
			float		_ParaScale;
			float		_MainSpeed;
			float4		_MainCol;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float3 localPos : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _MaskTex;

			v2f vert (appdata v)
			{
				v2f o;
				float4 curWorldPos = mul(_CustomCurrentObject2World, v.vertex);
				float4 lastWorldPos = mul(_CustomLastObject2World, v.vertex);

				float percentage = saturate(1.0f / (abs(v.vertex.z + _Para)) * _ParaScale);
				float4 worldPos = lerp(curWorldPos, lastWorldPos, 1.0f - percentage);

				o.vertex = mul(UNITY_MATRIX_VP, worldPos);
				//o.vertex = UnityObjectToClipPos(v.vertex);

				o.uv = v.uv.xy;
				o.localPos = v.vertex;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float2 mainUV = TRANSFORM_TEX(i.uv, _MainTex);
				// sample the texture
				fixed4 col = tex2D(_MainTex, mainUV + _MainSpeed * float2( 1, 0) * _Time.y);
				fixed4 mask = tex2D(_MaskTex, i.uv);

				//col = fixed4(i.localPos.zzz, 1.0);
				return col * mask * _MainCol * 4.0f;
			}
			ENDCG
		}
	}
}
