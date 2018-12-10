using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class FractalPostProcess : MonoBehaviour {

    public Shader shader = null;
    private Material _material = null;
    public Material _Material
    {
        get
        {
            if (_material == null)
                _material = GenerateMaterial(shader);
            return _material;
        }
    }

    protected Material GenerateMaterial(Shader shader)
    {
        if (shader == null)
            return null;
        if (shader.isSupported == false)
            return null;
        Material material = new Material(shader);
        material.hideFlags = HideFlags.DontSave;
        if (material)
            return material;
        return null;
    }

    public float c_x, c_y, boundary, scale;
    public int maxCount;

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (_Material)
        {
            CSet(src);
            _Material.SetFloat("_Cx", c_x);
            _Material.SetFloat("_Cy", c_y);
            _Material.SetInt("_MaxCount", maxCount);
            _Material.SetInt("_Boundary", Screen.width);
            _Material.SetFloat("_Scale", scale);
            Graphics.Blit(src, dest, _Material);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }

    void CSet(RenderTexture src)
    {
        int rtw = src.width;
        int rth = src.height;
        float tx = Input.mousePosition.x;
        if (tx >= 0)
        {
            c_x = -Input.mousePosition.x / rtw * 0.85f;
        }
        else
        {
            c_x = -Input.mousePosition.x / rtw * 0.45f;
        }
        c_y = Input.mousePosition.y / rth / 10 * 8;
    }
}
