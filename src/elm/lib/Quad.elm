module Quad exposing (quad)

import WebGL exposing (..)
import Math.Vector3 exposing (..)
import Math.Matrix4 exposing (..)

mesh size color = 
    let 
        minx = -size
        miny = size
        maxx = size
        maxy = -size
        (r,g,b) = color
    in 
        TriangleStrip 
            [ {position = (vec3 minx miny 0), color = (vec3 r g b)}
            , {position = (vec3 maxx miny 0), color = (vec3 r g b)}
            , {position = (vec3 maxx maxy 0), color = (vec3 r g b)}
            , {position = (vec3 minx miny 0), color = (vec3 r g b)}
            , {position = (vec3 minx maxy 0), color = (vec3 r g b)}
            ]

quad size color = 
    [ render vertexShader fragmentShader (mesh size color) {} ]
    
-- SHADERS
vertexShader : Shader { attr | position:Vec3, color:Vec3 } {} { vcolor:Vec3}
vertexShader = [glsl|
    attribute vec3 position;
    attribute vec3 color;
    
    varying vec3 vcolor;
    
    void main () {
        gl_Position = vec4(position, 1.0);
        vcolor = color;
    }
|]

fragmentShader : Shader {} {} { vcolor:Vec3 }
fragmentShader = [glsl|
    precision mediump float;
    
    varying vec3 vcolor;
    
    void main () {
        gl_FragColor = vec4(vcolor,1);
    }
|]

