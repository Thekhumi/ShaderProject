Shader "Custom/SurfaceShaderPepe"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
		_ScrollXSpeed("X", Range(0,10)) = 2
		_ScrollYSpeed("Y", Range(0,10)) = 3
		_LavaTex("Lava", 2D) = "red"
		_HeightMap("HeightMap", 2D) = "white"

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _LavaTex;
		sampler2D _HeightMap;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_LavaTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

		float _ScrollXSpeed;
		float _ScrollYSpeed;
		fixed2 scrolledUV = 0.0f;


		void scroll() {
			fixed xScrollValue = _ScrollXSpeed * _Time;
			fixed yScrollValue = _ScrollYSpeed * _Time;

			scrolledUV += fixed2(xScrollValue, yScrollValue);
		}

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
			scroll();
			fixed4 map = tex2D(_HeightMap, IN.uv_MainTex);
            fixed4 col = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			col.a = map.a;
			fixed4 lava = map * tex2D(_LavaTex,IN.uv_LavaTex + scrolledUV);
			lava.a = map;


            o.Albedo = col;
			o.Emission = lava;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = col.a;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
