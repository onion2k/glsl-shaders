// floor color algorithm from https://www.shadertoy.com/view/4dt3RX
    {
        vec2 uv = abs(mod(hit.position.xy + GRID_SIZE/2.0, GRID_SIZE) - GRID_SIZE/2.0); 
        
        uv /= fwidth(hit.position.xy);
        
        float riverEdge = dfRiver(hit.position, 0.0).x / fwidth(hit.position.xy).x;
                                                       
        float gln = min(min(uv.x, uv.y), riverEdge) / GRID_SIZE;
        
    	color = mix(GRID_COLOR_1, GRID_COLOR_2, 1.0 - smoothstep(0.0, GRID_LINE_SIZE / GRID_SIZE, gln));
    } 