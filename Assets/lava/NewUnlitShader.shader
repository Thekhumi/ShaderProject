Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_ScrollXSpeed("X", Range(0,10)) = 2
		_ScrollYSpeed("Y", Range(0,10)) = 3
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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			float _ScrollXSpeed;
			float _ScrollYSpeed;
			v2f vert (appdata v)
            {
				v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed2 scrolledUV = 0.0f;
				fixed xScrollValue = 8.68f * _Time;
				fixed yScrollValue = _ScrollYSpeed * _Time;

				scrolledUV += fixed2(xScrollValue, yScrollValue);

                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv + scrolledUV);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
