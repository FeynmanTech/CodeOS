
--# Main
-- CodeOS

-- Use this function to perform your initial setup
function setup()
    displayMode(FULLSCREEN_NO_BUTTONS)
    keyPressed = ""
    backingMode(RETAINED)
    background(255, 255, 255, 255)
    moved = 1
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    --background(255, 255, 255, 255)
    
    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    drawWindows()
    if keyPressed ~= "NP" then keyPressed = "NP" end
    
    if msg then msg() end -- Debugging, doesn't do anything unless you have my print library
end

function keyboard(k)
    keyPressed = k
end

--# Taskbar
local tapped = false

local s = 50

local home = readImage("Cargo Bot:Codea Icon")
    
function taskbar()
    fill(255)
    noStroke()
    rect(0, HEIGHT - 45, WIDTH, 45)
    fill(214, 214, 214, 255)
    noStroke()
    
    rrect(s, HEIGHT - 43, WIDTH - 3 - s, 40, 10, vec3(40,40,40))
    fill(226, 114, 114, 255)
    rrect(WIDTH - 39, HEIGHT - 37, 30, 28.5, 5, vec3(40,100,100))
    ---[[
    if 
        bounds(CurrentTouch.x, WIDTH - 39, WIDTH - 9 ) and
        bounds(CurrentTouch.y, HEIGHT - 37, HEIGHT - 8.5) and 
        CurrentTouch.state == ENDED
    then
        close()
    end
    --]]
    smooth()
    spriteMode(CORNER)
    ---[[
    if CurrentTouch.state == ENDED and not(tapped) and bounds(CurrentTouch.y, HEIGHT-43, HEIGHT-3) and bounds(CurrentTouch.x, s + 6, s + 6+(#winsOrig) * 35) then 
        local toRun = math.ceil((CurrentTouch.x - s - 6) / 35)
        --wins[winIndexes[toRun]].active = true
        ---[[
        for n = 1, #wins do
            if wins[n].index == winsOrig[toRun].index then
                wins[n].active = true
                wins[n]:show()
                moved = 2
            end
        end
        --]]
        tapped = true
    elseif CurrentTouch.state == BEGAN then
        tapped = false
    end
    --]]
    for n = 1, #winsOrig do
        if winsOrig[n].active then
            fill(113, 113, 113, 255)
            rrect(s + 3 + (n - 1) * 35, HEIGHT - 39.5, 33, 33, 8, vec3(30,30,30))
            fill(210)
            rrect(s + 5 + (n - 1) * 35, HEIGHT - 37.5, 29, 29, 6, vec3(30,30,30))
        end
        rsprite(winsOrig[n].i, s + 6 + (n - 1) * 35, HEIGHT - 36.5, 27, 27, 5, vec3(70,70,70))
    end
    rsprite(home, s - 42, HEIGHT - 45, 40, 40, 5, vec3(70,70,70))
    noSmooth()
end

--# Win
wins = {}

context = setContext

function adjustcindex()
    for i, v in ipairs(wins) do
        wins[i].cindex = i
        --winIndexes[wins[i].index] = wins[i].cindex
    end
end

local function runAll()
    for n = #wins, 1, -1 do
        if wins[n].active then
            wins[n]:run()
        end
    end
end

local function drawAndRunAll()
    for n = #wins, 1, -1 do
        if wins[n].active then
            wins[n]:run()
            wins[n]:draw()
        end
    end
end

function drawWindows()
    if moved then
        moved = moved - 1
    end 
    if moved and moved < 1 then
        moved = nil
        background(255)
    end
    runAll()
    taskbar()
end
    
function bounds(n, l, u)
    if n >= l and n <= u then return true end
end

function range(a, l, h)
    if a < l then
        return l
    elseif a > h then
        return h
    else
        return a
    end
end

local cwinindex = 1

window = class()

function window:init(x, y, w, h, t, i)
    for i, v in pairs(ui) do self[i] = ui[i] end
    -- you can accept and set parameters here
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.t = t
    self.i = i
    self.touches = {}
    table.insert(wins, self)
    self.index = cwinindex
    self.cindex = self.index
    cwinindex = cwinindex + 1
    self.__CONTENTS = image(self.w, self.h)
    self.clip = function() clip(self.x + 1, HEIGHT - self.y - self.h + 2, self.w - 2, self.h - 2) end
    self.translate = function() translate(self.x + 1, HEIGHT - self.y - self.h + 1) end
    self.mousex, self.mousey, self.pmousex, self.pmousey = nil
end

function window:optimize()
    self.main = self.main or function() end
    self.background = self.background or function() end
    self.onclose = self.onclose or function() end
    if not self.i then
        self.i = image(27, 27)
        setContext(self.i)
        font("HelveticaNeue-Light")
        fontSize(28)
        textMode(CENTER)
        fill(0)
        background(255)
        text(self.t, 10, 13)
        setContext()
    end
end

function window:draw()
    --Draw window
    noStroke()
    noSmooth()
    rectMode(CORNER)
    textMode(CORNER)
    spriteMode(CORNER)
    font("SourceSansPro-Regular")
    fontSize(13.5)
    if moved ~= false then
        if self.cindex == 1 then
            fill(202, 202, 202, 255)
            rrect(self.x, HEIGHT - self.y, self.w, 20, 5, vec3(50,50,50))
            fill(202 - 40)
            noStroke()
            rrect(self.x, HEIGHT - self.y, self.w, 4, 0, vec3(10,10,10))
            fill(150)
            rrect(self.x + self.w - 50, HEIGHT - self.y + 3, 17, 14, 4, vec3(50,50,50))
            rrect(self.x + self.w - 70, HEIGHT - self.y + 3, 17, 14, 4, vec3(50,50,50))
            fill(230)
            text(self.t, self.x + 19.5, HEIGHT - self.y + 0.5)
            fill(0)
            text(self.t, self.x + 20, HEIGHT - self.y + 1)
        else
            fill(150)
            rrect(self.x, HEIGHT - self.y, self.w, 20, 5, vec3(50,50,50))
            fill(150 - 40)
            noStroke()
            rrect(self.x, HEIGHT - self.y, self.w, 4, 0, vec3(10,10,10))
            fill(175)
            rrect(self.x + self.w - 50, HEIGHT - self.y + 3, 17, 14, 4, vec3(50,50,50))
            rrect(self.x + self.w - 70, HEIGHT - self.y + 3, 17, 14, 4, vec3(50,50,50))
            fill(30)
            text(self.t, self.x + 19.5, HEIGHT - self.y + 0.5)
            fill(230)
            text(self.t, self.x + 20, HEIGHT - self.y + 1)
        end
        fill(self.closehover and color(175,50,50) or color(230, 30, 30))
        rrect(self.x + self.w - 30, HEIGHT - self.y + 3, 27, 14, 4, vec3(50,70,70))
        local r, g, b = fill()
        fill(r-40,g-60,b-60)
        rrect(self.x + self.w - 7, HEIGHT - self.y + 3, 4, 4, 0, vec3(5,10,10))
        smooth()
        sprite(self.i, self.x + 4, HEIGHT - self.y + 4, 12, 12)
        noSmooth()
    end
end

function window:run()
    
    local x, y = CurrentTouch.x, CurrentTouch.y
    local onTop = true
    --if self.cindex > 1 then
        for n = 1, self.cindex - 1 do
            if
                bounds(x, wins[n].x, wins[n].x + wins[n].w) and
                bounds(y, HEIGHT - wins[n].y - wins[n].h, HEIGHT - wins[n].y + 20) and
                wins[n].active
            then
                onTop = false
                break
            end
        end
    --end
    if bounds(x, self.x, self.x + self.w) and bounds(y, HEIGHT - self.y - self.h, HEIGHT - self.y) and onTop then
        self:show()
        adjustcindex()
    end
    if 
        bounds(x, self.x + self.w - 30, self.x + self.w - 3) and 
        bounds(y, HEIGHT - self.y + 3, HEIGHT - self.y + 17) and onTop
    then
        if CurrentTouch.state == ENDED then
            self:hide()
            moved = 1
            return
        else
            self.closehover = true
        end
    else
        self.closehover = false
        if bounds(x, self.x, self.x + self.w) and bounds(y, HEIGHT - self.y, HEIGHT - self.y + 20) and
            not(self.dragx and self.dragy) and CurrentTouch.state == BEGAN and onTop
        then
            moved = 1
            self.dragx = x
            self.dragy = y
            self.sdx = self.x
            self.sdy = self.y
            table.remove(wins, self.cindex)
            table.insert(wins, 1, self)
            adjustcindex()
            --[[
            for i, v in ipairs(wins) do
                winIndexes[wins[i].index] = wins[i].cindex
            end
            --]]
            if self.onFocus then
                self.onFocus()
            end
        elseif self.dragx and self.dragy then
            moved = 1
            if CurrentTouch.state == ENDED then
                self.dragx, self.dragy = nil
                self.clip = function() clip(self.x + 1, HEIGHT - self.y - self.h + 2, self.w - 2, self.h - 2) end
                self.translate = function() translate(self.x + 1, HEIGHT - self.y - self.h + 1) end
            else
                self.x = math.floor(self.sdx + (x - self.dragx))
                self.y = math.floor(self.sdy - (y - self.dragy))
                self.clip = function() clip(self.x + 1, HEIGHT - self.y - self.h + 2, self.w - 2, self.h - 2) end
                self.translate = function() translate(self.x + 1, HEIGHT - self.y - self.h + 1) end
            end
        end
    end
    fill(237, 237, 237, 255)
    stroke(127)
    strokeWidth(1/ContentScaleFactor)
    rect(self.x, HEIGHT - self.y - self.h + 1, self.w, self.h)
    stroke(150)
    rect(self.x + 1/ContentScaleFactor, HEIGHT - self.y - self.h + 1 + 1/ContentScaleFactor, self.w-1, self.h-1)
    
    --Run window
    --if self.main then
        --clip()
    self.pmousex, self.pmousey = self.mousex and self.mousex or CurrentTouch.x - self.x - 1, self.mousey and self.mousey or CurrentTouch.y - (HEIGHT - self.y - self.h + 1)
    self.mousex, self.mousey = CurrentTouch.x - self.x - 1, CurrentTouch.y - (HEIGHT - self.y - self.h + 1)
    --pmousex, pmousey = CurrentTouch.prevX - self.x - 1, CurrentTouch.prevY - (HEIGHT - self.y - self.h + 1)
    if onTop then
        mousex, mousey, pmousex, pmousey = self.mousex, self.mousey, self.pmousex, self.pmousey
    else
        mousex, mousey, pmousex, pmousey = 0,0,0,0
    end
    clip(self.x + 1, HEIGHT - self.y - self.h + 2, self.w - 2, self.h - 2)
    translate(self.x + 1, HEIGHT - self.y - self.h + 1)
    self.main()
    clip()
    resetMatrix()
--end
--if self.background then
    self.background()
    --end
    self:draw()
end

function window:show()
    table.remove(wins, self.cindex)
    table.insert(wins, 1, self)
    adjustcindex()
    self.active = true
end

function window:hide()
    self.active = false
    self.onclose()
end

--# Rounded
local vertex = [[
//
// A basic vertex shader
//

//ThiCurs ntTouch.state is the current model * view * projection matrix
// Codea sets it automatically
uniform mat4 modelViewProjection;

//ThiCurs ntTouch.state is the current meshertex position, color and tex coord
// Set automatically
attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;

//ThiCurs ntTouch.state is an output variable that will be passed to the fragment shader
varying lowp vec4 vColor;
varying highp vec2 TexV;

uniform vec4 fill;
uniform vec4 stroke;

varying lowp vec4 Fill;
varying lowp vec4 Stroke;

uniform vec3 gradient;
varying lowp vec3 Gradient;

void main()
{
    //Pass the mesh color to the fragment shader
    vColor = color;
    TexV = texCoord;
    
    // Passes Normalized Stroke and Fill to Fragment
    Fill = vec4(fill.r/255.,fill.g/255.,fill.b/255.,fill.a/255.);
    //Fill = texture2D( texture, TexV );
    Stroke = vec4(stroke.r/255.,stroke.g/255.,stroke.b/255.,stroke.a/255.);

    // Gradient
    Gradient = vec3(gradient.x / 255., gradient.y / 255., gradient.z / 255.);

    //Multiply the vertex position by our combined transform
    gl_Position = modelViewProjection * position;
}
]]

local fragment = [[
//
// A basic fragment shader
//

//Default precision qualifier
precision highp float;

//uniform lowp sampler2D texture;

uniform vec2 position;
uniform float Smooth;
uniform float StrokeWidth;
uniform float radius;

//The interpolated vertex color for this fragment
varying lowp vec4 vColor;
varying lowp vec4 Stroke;
varying lowp vec4 Fill;
varying lowp vec3 Gradient;

//The interpolated texture coordinate for this fragment
varying highp vec2 TexV;

void main()

{
    //lowp vec4 tcol = texture2D( texture, TexV );
    //Fill = vColor;
    float SM = Smooth * 0.5; 
    vec4 Color = vec4(0,0,0,0);

    //Fill = texture2D(texture,TexV);

    vec4 Dims = vec4(0.5 - position.x * 0.5, 0.5 + position.x * 0.5, 
    0.5 + position.y * 0.5, 0.5 - position.y * 0.5);

    //Dims = vec4(0., position.x, position.y, 0.);
    
    float L = Dims.x; float R = Dims.y; float U = Dims.z; float D = Dims.w;
    float Radius = abs(radius); float dist = min(position.x * 0.5,position.y * 0.5);
    if (Radius > dist) Radius = dist;
        float Max = max(StrokeWidth,Radius);

    float DimHeight = 1. / abs(U - D);
    
    // Sets Bounds for Drawing
    if (TexV.x >= L - SM && TexV.x <= R + SM && TexV.y <= U + SM && TexV.y >= D - SM) {
    
       // Rounds Rectangle Corners
       if ((TexV.x < L + Radius || TexV.x > R - Radius) && 
        (TexV.y < D + Radius || TexV.y > U - Radius)){ 
    
        float Dist = min(min(distance(vec2(L + Radius,D + Radius),TexV),
         distance(vec2(R - Radius,D + Radius),TexV)),
         min(distance(vec2(L + Radius,U - Radius),TexV),
         distance(vec2(R - Radius,U - Radius),TexV))); 
        
        if (Dist <= Radius - StrokeWidth + SM && Dist >= Radius - StrokeWidth - SM)
         {if (StrokeWidth > 0.) // Fill Smoothing
         Color = mix(Fill,Stroke,(abs(Radius - StrokeWidth - SM - Dist))/Smooth);
         else Color = mix(Fill,vec4(0,0,0,0),((abs(Radius - StrokeWidth - SM - Dist))/Smooth));}
        
        else if (Dist <= Radius + SM && Dist >= Radius - StrokeWidth + SM) 
         if (Dist < Radius - SM) Color = Stroke; //Stroke Smiothing
         else Color = mix(vec4(Stroke.x,Stroke.y,Stroke.z,0),Stroke,(Radius + SM - Dist)/Smooth); 
        
        else if (Dist < Radius + SM) Color = Fill;
        else if (Dist > Radius + SM) Color = vec4(0,0,0,0); }
        
       else { // Draws Rectangle Sides/Interior
    
        float Dist = min( // Distance From Pixel to Closest Side
         min(distance(vec2(TexV.x, U + SM),TexV),distance(vec2(TexV.x,D - SM),TexV)), 
         min(distance(vec2(L - SM,TexV.y),TexV),distance(vec2(R + SM,TexV.y),TexV))); 
        
        if (Dist <= Smooth + StrokeWidth && Dist >= StrokeWidth && StrokeWidth > 0.) 
         Color = mix(Fill,Stroke,(Smooth - Dist + StrokeWidth)/Smooth); 
        else if (Dist + StrokeWidth <= Smooth) 
         Color = mix(Fill,vec4(0,0,0,0),(Smooth - Dist + StrokeWidth)/Smooth);
        else if (Dist <= Smooth && StrokeWidth > 0.) 
         Color = mix(Stroke,vec4(0,0,0,0),(Smooth - Dist)/Smooth);
        else if ((TexV.y <= D + StrokeWidth || TexV.y >= U - StrokeWidth) ||
         (TexV.x <= L + StrokeWidth || TexV.x >= R - StrokeWidth)) Color = Stroke;   
        else Color = Fill; }} 

    else discard;
    
    //Set the output color to the texture color
    gl_FragColor = vec4(mix(vec3(Color.x,Color.y,Color.z),vec3(Color.x-Gradient.x,Color.y-Gradient.y,Color.z-Gradient.z),((1.-TexV.y)-D)*DimHeight),Color.w);
}
]]

local s = shader(vertex, fragment)
local m = mesh()
m.shader = s
local re = m:addRect(0,0,0,0)
    
function rrect(x, y, w, h, d, gradient)
    
    local n = math.max(w, h)--w + h
    
    m:setRect(re, x + n / 2, y + h / 2, n, n)
    
    --m.shader.texture = readImage("Documents:BOXOFFICON")
    
    m.shader.radius = d / math.max(w, h)
    m.shader.Smooth = 0.5 / math.max(w, h)
    m.shader.position = vec2(w, h) / math.max(w, h)
    --m.shader.position = vec2(1, 1)
    
    --local p = vec2(w / h, h / w)-- * math.min(w / h, h / w) --:normalize()
    --m.shader.position = p-- / math.max(p.x, p.y)
    --m.shader.position = vec2(x / WIDTH, y / HEIGHT)
    m.shader.StrokeWidth = 1
    
    local r, g, b, a = stroke()
    m.shader.fill = vec4(r,g,b,a)
    m.shader.gradient = gradient or vec3(0,0,0)
    
    local r, g, b, a = fill()
    m.shader.stroke = vec4(r,g,b,a)
    stroke(0)
    strokeWidth(1.5)
    --rect(x, y, n / 2, n / 2)
    
    m:draw()
end

--# RoundedSprite
local vertex = [[
//
// A basic vertex shader
//

//ThiCurs ntTouch.state is the current model * view * projection matrix
// Codea sets it automatically
uniform mat4 modelViewProjection;

//ThiCurs ntTouch.state is the current meshertex position, color and tex coord
// Set automatically
attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;

//ThiCurs ntTouch.state is an output variable that will be passed to the fragment shader
varying lowp vec4 vColor;
varying highp vec2 TexV;

uniform vec4 fill;
uniform vec4 stroke;

varying lowp vec4 Fill;
varying lowp vec4 Stroke;

uniform vec3 gradient;
varying lowp vec3 Gradient;

void main()
{
    //Pass the mesh color to the fragment shader
    vColor = color;
    TexV = texCoord;
    
    // Passes Normalized Stroke and Fill to Fragment
    Fill = vec4(fill.r/255.,fill.g/255.,fill.b/255.,fill.a/255.);
    //Fill = texture2D( texture, TexV );
    Stroke = vec4(stroke.r/255.,stroke.g/255.,stroke.b/255.,stroke.a/255.);

    // Gradient
    Gradient = vec3(gradient.x / 255., gradient.y / 255., gradient.z / 255.);

    //Multiply the vertex position by our combined transform
    gl_Position = modelViewProjection * position;
}
]]

local fragment = [[
//
// A basic fragment shader
//

//Default precision qualifier
precision highp float;

uniform lowp sampler2D texture;

uniform vec2 position;
uniform float Smooth;
uniform float StrokeWidth;
uniform float radius;

//The interpolated vertex color for this fragment
varying lowp vec4 vColor;
varying lowp vec4 Stroke;
varying lowp vec4 Fill;
varying lowp vec3 Gradient;

//The interpolated texture coordinate for this fragment
varying highp vec2 TexV;

void main()

{
    lowp vec4 tcol = texture2D( texture, TexV );
    //Fill = vColor;
    float SM = Smooth * 0.5; 
    vec4 Color = vec4(0,0,0,0);

    //Fill = texture2D(texture,TexV);

    vec4 Dims = vec4(0.5 - position.x * 0.5, 0.5 + position.x * 0.5, 
    0.5 + position.y * 0.5, 0.5 - position.y * 0.5);

    //Dims = vec4(0., position.x, position.y, 0.);
    
    float L = Dims.x; float R = Dims.y; float U = Dims.z; float D = Dims.w;
    float Radius = abs(radius); float dist = min(position.x * 0.5,position.y * 0.5);
    if (Radius > dist) Radius = dist;
        float Max = max(StrokeWidth,Radius);

    float DimHeight = 1. / abs(U - D);
    
    // Sets Bounds for Drawing
    if (TexV.x >= L - SM && TexV.x <= R + SM && TexV.y <= U + SM && TexV.y >= D - SM) {
    
       // Rounds Rectangle Corners
       if ((TexV.x < L + Radius || TexV.x > R - Radius) && 
        (TexV.y < D + Radius || TexV.y > U - Radius)){ 
    
        float Dist = min(min(distance(vec2(L + Radius,D + Radius),TexV),
         distance(vec2(R - Radius,D + Radius),TexV)),
         min(distance(vec2(L + Radius,U - Radius),TexV),
         distance(vec2(R - Radius,U - Radius),TexV))); 
        
        if (Dist <= Radius - StrokeWidth + SM && Dist >= Radius - StrokeWidth - SM)
         {if (StrokeWidth > 0.) // Fill Smoothing
         Color = mix(tcol,tcol,(abs(Radius - StrokeWidth - SM - Dist))/Smooth);
         else Color = mix(tcol,vec4(0,0,0,0),((abs(Radius - StrokeWidth - SM - Dist))/Smooth));}
        
        else if (Dist <= Radius + SM && Dist >= Radius - StrokeWidth + SM) 
         if (Dist < Radius - SM) Color = tcol; //Stroke Smiothing
         else Color = mix(vec4(tcol.x,tcol.y,tcol.z,0.),tcol,(Radius + SM - Dist)/Smooth); 
        
        else if (Dist < Radius + SM) Color = tcol;
        else if (Dist > Radius + SM) Color = vec4(0,0,0,0); }
        
       else { // Draws Rectangle Sides/Interior
    
        float Dist = min( // Distance From Pixel to Closest Side
         min(distance(vec2(TexV.x, U + SM),TexV),distance(vec2(TexV.x,D - SM),TexV)), 
         min(distance(vec2(L - SM,TexV.y),TexV),distance(vec2(R + SM,TexV.y),TexV))); 
        
        if (Dist <= Smooth + StrokeWidth && Dist >= StrokeWidth && StrokeWidth > 0.) 
         Color = mix(tcol,tcol,(Smooth - Dist + StrokeWidth)/Smooth); 
        else if (Dist + StrokeWidth <= Smooth) 
         Color = mix(Fill,vec4(0,0,0,0),(Smooth - Dist + StrokeWidth)/Smooth);
        else if (Dist <= Smooth && StrokeWidth > 0.) 
         Color = mix(tcol,vec4(0,0,0,0),(Smooth - Dist)/Smooth);
        else if ((TexV.y <= D + StrokeWidth || TexV.y >= U - StrokeWidth) ||
         (TexV.x <= L + StrokeWidth || TexV.x >= R - StrokeWidth)) Color = tcol;   
        else Color = tcol; }} 

    else discard;
    
    //Set the output color to the texture color
    gl_FragColor = vec4(mix(vec3(Color.x,Color.y,Color.z),vec3(Color.x-Gradient.x,Color.y-Gradient.y,Color.z-Gradient.z),((1.-TexV.y)-D)*DimHeight),Color.w);
}
]]

local s = shader(vertex, fragment)
local m = mesh()
m.shader = s
local re = m:addRect(0,0,0,0)
    
function rsprite(i, x, y, w, h, d, gradient)
    
    local n = math.max(w, h)--w + h
    
    m:setRect(re, x + n / 2, y + h / 2, n, n)
    
    m.shader.texture = i
    
    m.shader.radius = d / math.max(w, h)
    m.shader.Smooth = 0.5 / math.max(w, h)
    m.shader.position = vec2(w, h) / math.max(w, h)
    --m.shader.position = vec2(1, 1)
    
    --local p = vec2(w / h, h / w)-- * math.min(w / h, h / w) --:normalize()
    --m.shader.position = p-- / math.max(p.x, p.y)
    --m.shader.position = vec2(x / WIDTH, y / HEIGHT)
    m.shader.StrokeWidth = 1
    
    local r, g, b, a = stroke()
    --m.shader.fill = vec4(r,g,b,a)
    m.shader.gradient = gradient or vec3(0,0,0)
    
    local r, g, b, a = fill()
    m.shader.stroke = vec4(r,g,b,a)
    stroke(0)
    strokeWidth(1.5)
    --rect(x, y, n / 2, n / 2)
    
    m:draw()
end

--# UI
ui = {}

--Button
ui.button = class()

function ui.button:init(win, x, y, w, h, t, c)
    self.win = win
    self.x, self.y, self.w, self.h, self.t, self.c = x, y, w, h, t, c or function() end
end

function ui.button:draw()
    fill(100)
    rrect(self.x, self.y, self.w, self.h, 6, vec3(50,50,50))
    if 
        (mousex and mousey) and 
        bounds(mousex, self.x, self.x + self.w) and bounds(mousey, self.y, self.y + self.h)
    then
        if CurrentTouch.state < ENDED then
            fill(200)
        else
            self.c()
            fill(240)
        end
    else
        fill(240)
    end
    rrect(self.x + 1, self.y + 1, self.w - 2, self.h - 2, 5, vec3(50,50,50))
    textMode(CENTER)
    fill(50)
    text(self.t, self.x + self.w / 2, self.y + self.h / 2)
end

--Text Edit
ui.textedit = class()

function ui.textedit:init(win, x, y, w, h, t, d)
    self.win = win
    self.x, self.y = x, y
    self.w, self.h = w, h
    self.t = t and {t} or {""}
    self.d = d and d or "Enter text..."
    --self.c = self.t.len()
    self.f = false
    self.e = 0
    self.th = 13
    
    self.c = {0, 0}
    font("Inconsolata")
    fontSize(12)
    self.fm = fontMetrics()
    
    function self:text()
        return table.concat(self.t, "\n")
    end
end

function ui.textedit:draw()
    clip(self.win.x + self.x, (HEIGHT - self.win.y - self.win.h) + self.y, self.w + 2, self.h + 2)
    fill(100)
    rrect(self.x, self.y, self.w, self.h, 6, vec3(30,30,30))
    if self.f then
        fill(240)
    else
        fill(220)
    end
    rrect(self.x + 1, self.y + 1, self.w - 2, self.h - 2, 5, vec3(10,10,10))
    
    textMode(CORNER)
    textWrapWidth(self.w - 12)
    font("Inconsolata")
    fontSize(12)
    if #self.t == 1 and self.t[1] == "" then
        fill(127)
        text(self.d, self.x + 6, self.y + self.h - 6 - 12 * #self.t)
    else
        fill(0)
        text(table.concat(self.t, "\n"), self.x + 6, self.y + self.h - 6 - 12 * #self.t)
    end
    
    if 
        bounds(mousex, self.x, self.x + self.w) and
        bounds(mousey, self.y, self.y + self.h)
    then 
        if CurrentTouch.state < ENDED then 
            showKeyboard()
            self.f = ElapsedTime 
            self.c[1] = math.floor((mousex - self.x) / 6) - 1
            self.c[1] = self.c[1] >= 0 and self.c[1] or 0
            self.c[2] = math.floor((self.y + self.h - (mousey) + 6) * (self.h - 6) / (12 + self.fm.leading) / (self.h - 6))
            self.c[2] = self.c[2] <= #self.t and self.c[2] or #self.t
            self.c[2] = self.c[2] > 0 and self.c[2] or 1
            self.c[1] = self.c[1] < #self.t[self.c[2]] and self.c[1] or #self.t[self.c[2]]
        end
    else
        self.f = false
    end
    
    if self.f and (ElapsedTime - self.f) % 1 < 0.5 then
        line(
            self.x + self.c[1] * 6 + 6, self.y + self.h - (self.c[2] - 1) * 12 - 5, 
            self.x + self.c[1] * 6 + 6, self.y + self.h - (self.c[2] - 1) * 12 - 19
        )
    end
    if keyPressed ~= "NP" and self.f then
        if keyPressed == "\n" then
            self.c[2] = self.c[2] + 1
            table.insert(self.t, self.c[2], "")
            self.c[1] = 0
        elseif keyPressed == BACKSPACE then
            self.t[self.c[2]] = 
                (self.t[self.c[2]]):sub(1, range(self.c[1] - 1, 0, 9^99)) ..
                (self.t[self.c[2]]):sub(self.c[1] + 1, -1)
            self.c[1] = self.c[1] - 1
            if self.c[1] < 0 then
                self.c[2] = (self.c[2] > 1 and self.c[2] - 1 or 1)
                self.c[1] = self.t[self.c[2]] and #self.t[self.c[2]] or 0
            end
        else
            self.t[self.c[2]] = 
                (self.t[self.c[2]]):sub(1, self.c[1]) .. keyPressed .. 
                (self.t[self.c[2]]):sub(self.c[1] + 1, -1)
            self.c[1] = self.c[1] + 1
            if #self.t[self.c[2]] >= (self.w - 12) / 6 - 1 then
                self.c[1] = 0
                self.c[2] = self.c[2] + 1
                table.insert(self.t, self.c[2], "")
            end
        end
    end
    textWrapWidth(WIDTH)
end

--Scrolling Text Edit
ui.textscroll = class()

function ui.textscroll:init(win, x, y, w, h, t, d)
    self.win = win
    self.x, self.y = x, y
    self.w, self.h = w, h
    self.t = t and {t} or {""}
    self.d = d and d or "Enter text..."
    --self.c = self.t.len()
    self.f = false
    self.e = 0
    self.scroll = 0
    self.th = 13
    
    self.c = {0, 0}
    font("Inconsolata")
    fontSize(12)
    self.fm = fontMetrics()
    self.sbegin = 0
    
    function self:text()
        return table.concat(self.t, "\n")
    end
end

function ui.textscroll:draw()
    clip(self.win.x + self.x, (HEIGHT - self.win.y - self.win.h) + self.y, self.w + 2, self.h + 2)
    fill(100)
    rrect(self.x, self.y, self.w, self.h, 6, vec3(30,30,30))
    if self.f then
        fill(240)
    else
        fill(220)
    end
    rrect(self.x + 1, self.y + 1, self.w - 2, self.h - 2, 5, vec3(10,10,10))
    
    textMode(CORNER)
    textWrapWidth(self.w - 12)
    font("Inconsolata")
    fontSize(12)
    if #self.t == 1 and self.t[1] == "" then
        fill(127)
        text(self.d, self.x + 6, self.y + self.h - 6 - 12 * #self.t)
    else
        fill(0)
        text(table.concat(self.t, "\n"), self.x + 6, self.y + self.h - 6 - 12 * #self.t - self.scroll)
    end
    
    if 
        bounds(mousex, self.x, self.x + self.w) and
        bounds(mousey, self.y, self.y + self.h)
    then 
        if CurrentTouch.state < ENDED then 
            if CurrentTouch.state == BEGAN then
                self.sbegin = ElapsedTime
                self.sx, self.sy = mousex, mousey
                self.scrolling = 1
            else
                if ElapsedTime - self.sbegin > 0.5 and not(self.scrolling == 2) then
                    showKeyboard()
                    self.f = ElapsedTime 
                    self.c[1] = math.floor((mousex - self.x) / 6) - 1
                    self.c[1] = self.c[1] >= 0 and self.c[1] or 0
                    self.c[2] = math.floor((self.y + self.h - (mousey + self.scroll) + 6) * (self.h - 6) / (12) / (self.h - 6))
                    self.c[2] = self.c[2] <= #self.t and self.c[2] or #self.t
                    self.c[2] = self.c[2] > 0 and self.c[2] or 1
                    self.c[1] = self.c[1] < #self.t[self.c[2]] and self.c[1] or #self.t[self.c[2]]
                    self.scrolling = 0
                elseif self.scrolling >= 1 and CurrentTouch.state >= BEGAN then
                    if 
                        bounds(CurrentTouch.deltaX, -1, 1) and bounds(CurrentTouch.deltaY, -1, 1) and 
                        ElapsedTime - self.sbegin < 0.25 and self.scrolling == 1 
                    then
                        self.scrolling = 0
                    elseif #self.t >= (self.h - 12) / 12 then
                        self.scrolling = 2
                        self.scroll = self.scroll + (self.sy - mousey)
                        if self.scroll < self.h - 12 - #self.t * 12 then
                            self.scroll = self.scroll - (self.sy - mousey)
                        elseif self.scroll > (#self.t) - (self.h - 6) / 12 then
                            --self.scroll = (#self.t) - (self.h - 6) / 12
                            self.scroll = self.scroll - (self.sy - mousey)
                        end
                        self.sy = mousey
                    end
                end
            end
        elseif self.scrolling == 1 then
            showKeyboard()
            self.f = ElapsedTime 
            self.c[1] = math.floor((mousex - self.x) / 6) - 1
            self.c[1] = self.c[1] >= 0 and self.c[1] or 0
            self.c[2] = math.floor((self.y + self.h - (mousey + self.scroll) + 6) * (self.h - 6) / (12 + self.fm.leading) / (self.h - 6))
            self.c[2] = self.c[2] <= #self.t and self.c[2] or #self.t
            self.c[2] = self.c[2] > 0 and self.c[2] or 1
            self.c[1] = self.c[1] < #self.t[self.c[2]] and self.c[1] or #self.t[self.c[2]]
            self.scrolling = 0
        end
    elseif CurrentTouch.state == ENDED then
        self.f = false
    end
    
    if self.f and (ElapsedTime - self.f) % 1 < 0.5 then
        line(
            self.x + self.c[1] * 6 + 6, self.y + self.h - (self.c[2] - 1) * 12 - 5 - self.scroll, 
            self.x + self.c[1] * 6 + 6, self.y + self.h - (self.c[2] - 1) * 12 - 19 - self.scroll
        )
    end
    if keyPressed ~= "NP" and self.f then
        if keyPressed == "\n" then
            self.c[2] = self.c[2] + 1
            table.insert(self.t, self.c[2], "")
            self.c[1] = 0
        elseif keyPressed == BACKSPACE then
            self.t[self.c[2]] = 
                (self.t[self.c[2]]):sub(1, range(self.c[1] - 1, 0, 9^99)) ..
                (self.t[self.c[2]]):sub(self.c[1] + 1, -1)
            self.c[1] = self.c[1] - 1
            if self.c[1] < 0 then
                if #self.t[self.c[2]] == 0 then
                    table.remove(self.t, self.c[2])
                end
                self.c[2] = (self.c[2] > 1 and self.c[2] - 1 or 1)
                self.c[1] = self.t[self.c[2]] and #self.t[self.c[2]] or 0
            end
        else
            self.t[self.c[2]] = 
                (self.t[self.c[2]]):sub(1, self.c[1]) .. keyPressed .. 
                (self.t[self.c[2]]):sub(self.c[1] + 1, -1)
            self.c[1] = self.c[1] + 1
            if #self.t[self.c[2]] >= (self.w - 12) / 6 - 1 then
                self.c[1] = 0
                self.c[2] = self.c[2] + 1
                table.insert(self.t, self.c[2], "")
            end
        end
    end
    textWrapWidth(WIDTH)
end

--# LoadWindows
local programs = "CodeOS_Programs"

local tabs = listProjectTabs(programs)

for i, v in ipairs(tabs) do
    if v ~= "Main" then
        loadstring(readProjectTab(programs .. ":" .. v))()
    end
end
--# ProgramRun
run = window(450, 200, 170, 72, "Run")
run.i = readImage("Documents:ui")

local p = run:textedit(10, 10, 150, 24, "", "Program...")

local b = run:button(10, 44, 150, 16, "Run program", 
function() 
    local s, t = pcall(listProjectTabs, p:text())
    if t then
        for i, v in ipairs(t) do
            if v ~= "Main" then
                s, err = pcall(loadstring(readProjectTab(p:text() .. ":" .. v)))
                if not s then
                    print(err)
                end
            end
        end
    end
end
)

run.main = function()
    b:draw()
    p:draw()
end
--# SetUpWindows
winsOrig, winIndexes = {}, {}
for i, v in ipairs(wins) do 
    wins[i]:optimize()
    winsOrig[i] = v 
    winIndexes[i] = i 
end
--# ccConfig
--[[
###########################################
##Codea Community Project Config Settings##
###########################################

##You can use # to comment out a line
##Use 1 for true and 0 for false


###########################################
#       Add project info below            #
#==========================================
ProjectName: CodeOS
Version: 3.9 Beta
Comments: This probably won't work right yet. It also uses bits and pieces of other people's code, if you are one of those people and are bothered by this, tell me!
Author: FLCode
##License Info: http://choosealicense.com
##Supported Licneses: MIT, GPL, Apache, NoLicense
License: NoLicense
#==========================================


###########################################
#                Settings                 #
[Settings]=================================
##Codea Community Configuration settings
##Format: Setting state

Button 0
NotifyCCUpdate 1
ResetUserOption 1
AddHeaderInfo 1
CCFOLDER alpha

[/Settings]================================



###########################################
#              Screenshots                #
[Screenshots]==============================
##Screenshots from your project.
##Format: url
##Example: http://www.dropbox.com/screenshot.jpg


[/Screenshots]=============================



###########################################
#                   Video                 #
[Video]====================================
##Link to a YouTube.com video.
##Format: url
##Example: http://www.youtube.com/videolink


[/Video]===================================



###########################################
#              Dependencies               #
[Dependencies]=============================
##Include the names of any dependencies here
##Format: Dependency
##Example: Codea Community


[/Dependencies]============================



############################################
#                   Tabs                   #
[Tabs]======================================
##Select which tabs are to be uploaded.
##Keyword 'not' excludes a tab or tabs. Keyword 'add' includes a tab or tabs.
##not * will exclude all tabs to allow for individual selection
##not *tab1 will look for any tab with tab1 on the end.
##not tab1* will look for any tab with tab1 at the beginning.
##Format: (add/not)(*)tab(*)
##Example: not Main --this will remove main.
##Example: not *tab1 --this will remove any tab with "tab1" on the end.
##Example: add Main --This will add Main back in.




[/Tabs]=====================================



#############################################
#                  Assets                   #
[Assets]=====================================
##Directory, path and url info for any assets besides the standard Codea assets.
##Format: Folder:sprite URL
##Example: Documents:sprite1 http://www.somewebsite.com/img.jpg


[/Assets]====================================
]]
