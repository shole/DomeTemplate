
Shader "Custom/distortion_16bit_mask" {
    Properties {
        _Rendertexture ("Rendertexture", 2D) = "white" {}
        _MaskTexture ("MaskTexture", 2D) = "white" {}
        _UVmap ("UVmap", 2D) = "black" {}
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        LOD 200
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            Fog {Mode Off}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma exclude_renderers xbox360 ps3 flash 
            #pragma target 3.0
            uniform sampler2D _MaskTexture;
			uniform float4 _MaskTexture_ST;
            uniform sampler2D _Rendertexture;
			uniform float4 _Rendertexture_ST;
            uniform sampler2D _UVmap;
			uniform float4 _UVmap_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float4 uv0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.uv0;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
				fixed mask = tex2D(_MaskTexture,TRANSFORM_TEX(i.uv0, _MaskTexture)); // shadow mask texture
                fixed4 distortionmap = tex2D(_UVmap,TRANSFORM_TEX(i.uv0, _UVmap)); // full UVmap texture
                
				fixed2 roughUV=distortionmap.rg; // separate 8bit rough ...
				fixed2 detailUV=distortionmap.ba; // ... and detail from combined map
				
                uint2 roughUVsteps = roughUV*256; // low detail steps
				//fixed2 detailUVramps=abs( detailUV - fmod(roughUVsteps,2) ); // high detail ramps
				float2 detailUVramps=abs( detailUV - (floor(roughUVsteps)%2) ); // high detail ramps
                float2 combinedUV = ( (roughUVsteps + detailUVramps)/256 ).rg; // combined 16bit UV
                fixed3 finalColor = tex2D(_Rendertexture,TRANSFORM_TEX(combinedUV, _Rendertexture)).rgb*mask;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
