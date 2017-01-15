#version 330 core

in vec3 fragmentPosition;
in vec3 fragmentNormal;
in vec2 UV;

// Ouput data
out vec3 color;

uniform vec3 uLight;
uniform vec3 pLight; 
uniform float pLightint;
uniform float dLightint;

uniform sampler2D myTextureSampler;

void main(){

vec3 Kd = vec3(1.0, 1.0, 0.0);
	//directional light
	vec3 tolight = normalize(uLight - fragmentPosition);	
	vec3 toV = -normalize(vec3(fragmentPosition));
	vec3 h = normalize(toV + tolight);
	vec3 normal = normalize(fragmentNormal);

	float specular = pow(max(0.0, dot(h, normal)), 64.0);
	float diffuse = max(0.0, dot(normal, tolight));

	vec3 intensity = vec3(1.0,1.0,1.0) * diffuse + vec3(0.3, 0.3, 0.3)*specular;


	float constantatt = 0.3f;
	float linearatt = 0.6f;
	float expatt = 0.1f; 
	vec3 ptolight = pLight - fragmentPosition;
	float dist = length(ptolight);
	ptolight = normalize(ptolight);
	vec3 pintensity;
	vec3 pnormal = normalize(fragmentNormal);
	vec3 pspec = vec3(0.0, 0.0, 0.0);
	//need to calculate attenuation;
	float attenuation = 1.0 / (constantatt + linearatt * dist + expatt *dist *dist);
	float pdiffuse = max(0.0, dot(pnormal, ptolight));
	//if fragment is illuminated then do specular part
	if(pdiffuse > 0.0) {
		vec3 ptoV = -normalize(fragmentPosition);
		vec3 preflection = -reflect(ptolight , pnormal);
		float pspecular = max(0.0, dot(preflection, pnormal));
		pspec = vec3(0.5, 0.5, 0.5)* pow(pspecular, 64.0) * attenuation;
	}
	pintensity = pdiffuse  * attenuation + pspec;
	
	Kd = texture(myTextureSampler, UV).rgb;
	vec3 finalColor = Kd*( dLightint * intensity + pLightint * pintensity);
	color = pow(finalColor, vec3(1.0 / 2.2));// Apply gamma correction    		
}