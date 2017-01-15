#version 330 core

// Input vertex data, different for all executions of this shader.
layout(location = 0) in vec3 vertexPosition_modelspace;
layout(location = 1) in vec3 vertexNormal_modelspace;
layout(location = 3) in vec2 vertexUV;

out vec3 fragmentPosition;
out vec3 fragmentNormal;
out vec2 UV;

smooth out vec3 ReflectDir;//Reflection direction for Environmental Map

uniform mat4 ModelTransform;
uniform mat4 Eye;
uniform mat4 Projection;
uniform bool DrawSkyBox;
uniform vec3 WorldCameraPosition;

void main(){
	mat4 MVM = inverse(Eye) * ModelTransform;

	vec4 wPosition = MVM * vec4(vertexPosition_modelspace, 1);
	fragmentPosition = wPosition.xyz;
	
	mat4 invm = inverse(MVM);
	invm[0][3] = 0; invm[1][3] = 0;	invm[2][3] = 0;
	mat4 NVM = transpose(invm);
	vec4 tnormal = vec4(vertexNormal_modelspace, 0.0);
	fragmentNormal = vec3(NVM * tnormal);
	UV = vertexUV;	


	gl_Position = Projection * wPosition;	
	//TODO: Calculate reflection direction
	//for Cube map (environmental map)

	mat4 inverseProjection = inverse(Projection);
	mat3 inverseModelview = mat3(inverse(MVM));
	if (DrawSkyBox){
		ReflectDir = -vertexPosition_modelspace;
	}
	else{
	   vec3 worldPos = vec3(ModelTransform * vec4(vertexPosition_modelspace, 1.0));
	   vec3 worldNorm = vec3(ModelTransform * vec4(vertexNormal_modelspace, 0.0));
	   vec3 campos = (Eye*vec4(WorldCameraPosition, 1.0)).xyz;
	   vec3 worldView = normalize(campos - worldPos);

	   ReflectDir = -reflect(-worldView, worldNorm);
	}


}

