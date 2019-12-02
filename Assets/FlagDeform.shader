Shader "Gaspar/FlagDeform"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Frequency("Frequency", Float) = 1.0
		_WindStrenght("Wind Strenght (0.1 - 1)", Float) = 0.5
		_Loop("Loop Multiplier", Float) = 1.0
		_Threshold("X Threshold (0 - 1)", Float) = 0.2
		_Xwind("X Wind Influence", Float) = 1.0
		_Ywind("Y Wind Influence", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
			Cull off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
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
			float _Frequency;
			float _WindStrenght;
			float _Loop;
			float _Threshold;
			float _Xwind;
			float _Ywind;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

				float posLock = step(_Threshold, v.uv.x);
				float pos = _Xwind * worldPos.x + _Ywind * worldPos.y;
				o.vertex.x += sin(pos * _Loop + _Time.w * _Frequency) * _WindStrenght * posLock;

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
