varying vec2 vUv;
uniform float time;
varying vec3 vPosition;

// NOISE
float mod289(float x){return x-floor(x*(1./289.))*289.;}
vec4 mod289(vec4 x){return x-floor(x*(1./289.))*289.;}
vec4 perm(vec4 x){return mod289(((x*34.)+1.)*x);}

float noise(vec3 p){
    vec3 a=floor(p);
    vec3 d=p-a;
    d=d*d*(3.-2.*d);
    
    vec4 b=a.xxyy+vec4(0.,1.,0.,1.);
    vec4 k1=perm(b.xyxy);
    vec4 k2=perm(k1.xyxy+b.zzww);
    
    vec4 c=k2+a.zzzz;
    vec4 k3=perm(c);
    vec4 k4=perm(c+1.);
    
    vec4 o1=fract(k3*(1./41.));
    vec4 o2=fract(k4*(1./41.));
    
    vec4 o3=o2*d.z+o1*(1.-d.z);
    vec2 o4=o3.yw*d.x+o3.xz*(1.-d.x);
    
    return o4.y*d.y+o4.x*(1.-d.y);
}

float lines(vec2 uv,float offset){
    return smoothstep(.0,.5+offset*.5,abs(.5*(sin(uv.x*30.)+offset*2.)));
}

mat2 rotate2D(float angle){
    return mat2(cos(angle),-sin(angle),sin(angle),cos(angle));
}

// просто серый
// void main(){
    //     float n=noise(vPosition+time);
    
    //     // green
    //     vec3 baseFirst=vec3(120./255.,158./255.,113./255.);
    //     // black
    //     vec3 accent=vec3(0.,0.,0.);
    //     // orange
    //     vec3 baseSecond=vec3(224./255.,148./255.,66./255.);
    
    //     vec3 white=vec3(255./255.,255./255.,255./255.);
    
    //     vec3 grey=vec3(200./255.,200./255.,200./255.);
    //     vec3 greyLight=vec3(210./255.,210./255.,210./255.);
    
    //     vec2 baseUV=rotate2D(n)*vPosition.xy*.1;
    
    //     float basePattern=lines(baseUV,.5);
    //     float secondPattern=lines(baseUV,.1);
    
    //     vec3 baseColor=mix(white,grey,basePattern);
    //     vec3 secondBaseColor=mix(baseColor,greyLight,secondPattern);
    
    //     gl_FragColor=vec4(vec3(secondBaseColor),1.);
    
// }

// смешивание цветов
void main(){
    float n=noise(vPosition+time);
    
    // Определение цветовых схем
    vec3 baseFirst=vec3(120./255.,158./255.,113./255.);// зеленый
    vec3 accent=vec3(0.,0.,0.);// черный
    vec3 baseSecond=vec3(224./255.,148./255.,66./255.);// оранжевый
    vec3 white=vec3(255./255.,255./255.,255./255.);
    vec3 grey=vec3(200./255.,200./255.,200./255.);
    vec3 greyLight=vec3(210./255.,210./255.,210./255.);
    
    // Плавный фактор смешивания на основе времени
    float mixFactor=.5+.5*sin(time*.5);// Значение плавно меняется от 0 до 1
    
    // Смешиваем цветовые схемы на основе mixFactor
    vec3 dynamicBaseColor=mix(white,grey,lines(rotate2D(n)*vPosition.xy*.1,.5));
    vec3 firstColorScheme=mix(baseSecond,baseFirst,dynamicBaseColor);
    vec3 secondColorScheme=mix(firstColorScheme,accent,lines(rotate2D(n)*vPosition.xy*.1,.1));
    vec3 finalColor=mix(secondColorScheme,dynamicBaseColor,mixFactor);
    
    gl_FragColor=vec4(finalColor,1.);
}

// референс
// void main(){
    //     float n=noise(vPosition+time);
    
    //     vec3 baseFirst=vec3(120./255.,158./255.,113./255.);
    //     vec3 accent=vec3(0.,0.,0.);
    //     vec3 baseSecond=vec3(224./255.,148./255.,66./255.);
    
    //     vec2 baseUV=rotate2D(n)*vPosition.xy*.1;
    
    //     float basePattern=lines(baseUV,.5);
    //     float secondPattern=lines(baseUV,.1);
    
    //     vec3 baseColor=mix(baseSecond,baseFirst,basePattern);
    //     vec3 secondBaseColor=mix(baseColor,accent,secondPattern);
    
    //     gl_FragColor=vec4(vec3(secondBaseColor),1.);
    
// }

// float n=noise(vPosition+time);

// gl_FragColor=vec4(n,0.,0.,1.);