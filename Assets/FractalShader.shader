// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/FractalShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Cx("CX", Float) = 0.0
		_Cy("CY", Float) = 0.0
		_Boundary("Boundary", Float) = 10
		_MaxCount("MaxCount", Int) = 1
		_Scale("Scale", Float) = 100
		_Distance("Distance", Float) = 1
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#define PI = 3.1415962;
			float _Cx;
			float _Cy;
			float _Boundary;
			int _MaxCount;
			float _Distance;
			float _Scale;

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

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			//zn+1 = zn^2 + c
			half2 iteration(fixed2 pos)
			{
				half powx = pos[0] * pos[0];
				half powy = pos[1] * pos[1];
				half xmy = pos[0] * pos[1];
				half rx = (powx - powy) + _Cx;
				half ry = (2 * xmy) + _Cy;
				half2 result = half2(rx, ry);
				return result;
			}

			//根据发散值产生图形
			bool fractal(fixed2 pos)
			{
				half2 pos1 = pos;
				half2 posF = iteration(pos1);
				for (int i = 0; i < _MaxCount; i++) {
					posF = iteration(posF);
				}
				half powF = (posF.x * posF.x + posF.y * posF.y);
				half pow1 = (pos1.x * pos1.x + pos1.y * pos1.y);
				if((powF - pow1) < _Boundary)
					return true;
				return false;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = fixed4(0,0,0,0);
				half2 f = half2(i.uv.x - 0.5, i.uv.y - 0.5);
				f /= _Scale;
				if(fractal(f))
					col = fixed4(1,1,1,1);

				//fixed4 col = tex2D(_MainTex, i.uv);
				
				col.rgb = col.rgb;
				return col;
			}

			ENDCG
		}
	}
}
