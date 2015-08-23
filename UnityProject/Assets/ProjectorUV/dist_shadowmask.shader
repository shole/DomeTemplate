// Shader created with Shader Forge Beta 0.23 
// Shader Forge (c) Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:0.23;sub:START;pass:START;ps:lgpr:1,nrmq:0,limd:0,blpr:0,bsrc:0,bdst:0,culm:0,dpts:2,wrdp:True,uamb:True,mssp:True,ufog:False,aust:False,igpj:False,qofs:0,lico:1,qpre:1,flbk:,rntp:1,lmpd:False,lprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,hqsc:True,hqlp:False,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,ofsf:0,ofsu:0;n:type:ShaderForge.SFN_Final,id:1,x:32526,y:32658|emission-119-OUT;n:type:ShaderForge.SFN_Tex2d,id:3,x:33042,y:32756,ptlb:Rendertexture,tex:3d403fe3184a448fa8bc190c7f07f28c,ntxv:0,isnm:False|UVIN-21-OUT;n:type:ShaderForge.SFN_Append,id:21,x:33297,y:32775|A-43-R,B-43-G;n:type:ShaderForge.SFN_Tex2dAsset,id:42,x:33804,y:32786,ptlb:distortion UV,tex:6bd3fbab0f7e4f84f8ca56484b2810b7;n:type:ShaderForge.SFN_Tex2d,id:43,x:33579,y:32748,tex:6bd3fbab0f7e4f84f8ca56484b2810b7,ntxv:0,isnm:False|MIP-129-OUT,TEX-42-TEX;n:type:ShaderForge.SFN_Multiply,id:119,x:32838,y:32917|A-3-RGB,B-122-RGB;n:type:ShaderForge.SFN_Tex2d,id:122,x:33031,y:33016,ptlb:Shadowmask,ntxv:0,isnm:False;n:type:ShaderForge.SFN_ValueProperty,id:129,x:33803,y:32682,ptlb:downscaleFactor,v1:0;proporder:3-42-122-129;pass:END;sub:END;*/

Shader "Custom/dist_shadowmask" {
    Properties {
        _Rendertexture ("Rendertexture", 2D) = "white" {}
        _distortionUV ("distortion UV", 2D) = "white" {}
        _Shadowmask ("Shadowmask", 2D) = "white" {}
        _downscaleFactor ("downscaleFactor", Float ) = 0
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
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash 
            #pragma target 3.0
            #pragma glsl
            uniform sampler2D _Rendertexture; uniform float4 _Rendertexture_ST;
            uniform sampler2D _distortionUV; uniform float4 _distortionUV_ST;
            uniform sampler2D _Shadowmask; uniform float4 _Shadowmask_ST;
            uniform float _downscaleFactor;
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
////// Lighting:
////// Emissive:
                float2 node_134 = i.uv0;
                float4 node_43 = tex2Dlod(_distortionUV,float4(TRANSFORM_TEX(node_134.rg, _distortionUV),0.0,_downscaleFactor));
                float2 node_21 = float2(node_43.r,node_43.g);
                float3 emissive = (tex2D(_Rendertexture,TRANSFORM_TEX(node_21, _Rendertexture)).rgb*tex2D(_Shadowmask,TRANSFORM_TEX(node_134.rg, _Shadowmask)).rgb);
                float3 finalColor = emissive;
/// Final Color:
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
