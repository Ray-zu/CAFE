#version 330
attribute vec3 position;
attribute vec2 uv;
varying   vec2 uvpos;
uniform   mat4 MVP;
void main(void){
    gl_Position = MVP * vec4(position, 1.0);
    uvpos = uv;
}