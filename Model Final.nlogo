extensions [table csv]

turtles-own
[
  age
  sex
  gravid
  mature
  gravid-counter
]

to create_world
  clear-all
  reset-ticks
  ask patches
  [
    set pcolor 88
  ]
end

to create_population
  create-turtles initial_population
  [
    set xcor random-xcor
    set ycor random-ycor
    set shape "turtle"
    set gravid FALSE
    set age 40 ;random age_max

    ifelse random-float 1 < initial_female_ratio
    [
      set sex "female"
    ]
    [
      set sex "male"
    ]

    ifelse age < maturity_age
    [
      set mature FALSE
      set color green
      set size 0.5
    ]
    [
      set mature true
      ifelse sex = "female"
      [
        set color orange
      ]
      [
        set color violet
      ]
    ]
  ]
end


to female_cycle
  ask turtles with [gravid = TRUE]
  [
    ifelse gravid-counter = 3
    [
      set gravid-counter 0
      set gravid FALSE
      set color orange
    ]
    [
      set gravid-counter gravid-counter + 1
    ]
  ]
end


to get_older
  set age age + 1
  ;set gravid FALSE   ; ---> bc in this version gravidity lasts for two years

  if age = maturity_age ; = statt > bzw. >=
  [
    set mature TRUE
    set size 1
    ifelse sex = "female"
    [
      set color orange
    ]
    [
      set color violet
    ]
  ]
end

to move
  rt random-float 360 forward 1
end


to die_naturally
  ;if mature = FALSE and random-float 1 < juvenile_mortality [die]
  if mature = TRUE  and random-float 1 < adult_mortality [die]
end

to die_of_roadkill
  if sex = "female" AND mature = TRUE AND random-float 1 < roadkill_mortality [die]
end

to mate
  let females turtles with [sex = "female"]
  ask turtles with [sex = "male" AND mature = TRUE]
  [
    ask up-to-n-of max_mates females in-radius 5
    [
      let hatch-number (chance_to_hatch *(random-normal average_clutch_size clutch_size_std))
      ;hatch_prob (chance_to_hatch * (random-normal average_clutch_size clutch_size_std))
      if mature = TRUE and gravid = FALSE
      [
        repeat hatch-number
        [
          if random-float 1 < chance_to_reach_maturity
          [
            hatch 1
            [
              set size 0.5
              set xcor random-xcor
              set ycor random-ycor
              set color green
              set age 0
              set mature FALSE
              ifelse random-float 1 < new_female_ratio
              [
                set sex "female"
              ]
              [
                set sex "male"
              ]
            ]
          ]
        ]
        set gravid TRUE
        set color black
        set gravid-counter 1
      ]
    ]
  ]
end



to respect_carrying_capacity
  let current_adult_population count turtles with [mature = TRUE]
  if current_adult_population > 0
  [
    let chance_to_die ((current_adult_population - carrying_capacity) / current_adult_population )
    if random-float 1 < chance_to_die
    [
      die
    ]
  ]
end

to setup
  create_world
  create_population
end

to go
  ask turtles [get_older]
  ask turtles [move]
  if roadkill = TRUE
  [
      ask turtles [die_of_roadkill]
  ]
  female_cycle
  mate
  ask turtles [respect_carrying_capacity]
  ask turtles [die_naturally]
  tick
end
@#$#@#$#@
GRAPHICS-WINDOW
638
19
1075
457
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

INPUTBOX
9
12
164
72
initial_population
200.0
1
0
Number

BUTTON
208
37
272
70
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
191
126
363
159
initial_female_ratio
initial_female_ratio
0
1
0.5
0.1
1
NIL
HORIZONTAL

PLOT
394
35
594
185
Turtle Counter
time
#
0.0
150.0
0.0
100.0
true
true
"" ""
PENS
"turtles" 1.0 0 -16777216 true "" "plot count turtles with [mature = TRUE]"
"females" 1.0 0 -955883 true "" "plot count turtles with [sex = \"female\" and mature = TRUE]"
"males" 1.0 0 -10141563 true "" "plot count turtles with [sex = \"male\" and mature = TRUE]"

BUTTON
277
38
356
71
Go once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
209
74
272
107
Go 
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
9
75
164
135
carrying_capacity
300.0
1
0
Number

SLIDER
192
164
364
197
new_female_ratio
new_female_ratio
0
1
0.8
0.01
1
NIL
HORIZONTAL

INPUTBOX
8
270
163
330
chance_to_reach_maturity
0.002
1
0
Number

SLIDER
195
244
367
277
adult_mortality
adult_mortality
0
1
0.08
0.01
1
NIL
HORIZONTAL

INPUTBOX
8
203
163
263
age_max
60.0
1
0
Number

INPUTBOX
7
334
162
394
average_clutch_size
575.0
1
0
Number

INPUTBOX
8
398
163
458
clutch_size_std
140.0
1
0
Number

INPUTBOX
9
139
164
199
maturity_age
35.0
1
0
Number

MONITOR
394
196
472
241
adult males
count turtles with [sex = \"male\" and mature = TRUE]
17
1
11

MONITOR
486
196
575
241
adult females
count turtles with [sex = \"female\" AND mature = TRUE]
17
1
11

MONITOR
394
250
495
295
total population
count turtles
17
1
11

PLOT
197
359
507
509
Turtle counter (incl. young)
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"turtles incl young" 1.0 0 -16777216 true "" "plot count turtles"
"females incl young" 1.0 0 -955883 true "" "plot count turtles with [sex = \"female\"]"
"males incl young" 1.0 0 -8630108 true "" "plot count turtles with [sex = \"male\"]"

INPUTBOX
9
465
164
525
max_mates
5.0
1
0
Number

SLIDER
194
204
366
237
juvenile_mortality
juvenile_mortality
0
100
0.0
1
1
NIL
HORIZONTAL

INPUTBOX
199
283
354
343
chance_to_hatch
0.44
1
0
Number

SWITCH
396
320
499
353
roadkill
roadkill
1
1
-1000

SLIDER
519
476
691
509
roadkill_mortality
roadkill_mortality
0
1
0.03
0.01
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

Chance to reach maturity calculated from Mazaris-Modell -> einzelne Wahrscheinlichkeiten aufmultipliziert!  

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="Testlauf" repetitions="1000" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <exitCondition>not any? turtles</exitCondition>
    <metric>count turtles</metric>
    <metric>count turtles with [sex = "male"]</metric>
    <metric>count turtles with [sex = "female"]</metric>
    <enumeratedValueSet variable="maturity_age">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average_clutch_size">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roadkill_mortality">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="juvenile_mortality">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult_mortality">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial_female_ratio">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="age_max">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="clutch_size_std">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial_population">
      <value value="2000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="carrying_capacity">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance_to_hatch">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new_female_ratio">
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance_to_reach_maturity">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Experiment 24.01." repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="600"/>
    <metric>count turtles with [sex = "female"]</metric>
    <metric>count turtles with [sex = "male"]</metric>
    <metric>count turtles with [sex = "female" and mature = true ]</metric>
    <metric>count turtles with [sex = "male" and mature = true]</metric>
    <enumeratedValueSet variable="average_clutch_size">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maturity_age">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="juvenile_mortality">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roadkill_mortality">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult_mortality">
      <value value="0.06"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial_female_ratio">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max_mates">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="age_max">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="clutch_size_std">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial_population">
      <value value="2000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="carrying_capacity">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new_female_ratio">
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance_to_hatch">
      <value value="0.1"/>
    </enumeratedValueSet>
    <steppedValueSet variable="random-seed" first="1" step="1" last="1000"/>
  </experiment>
  <experiment name="Experiment_22_02_4_mates_ab_50" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="600"/>
    <metric>count turtles with [sex = "female"]</metric>
    <metric>count turtles with [sex = "male"]</metric>
    <metric>count turtles with [sex = "female" and mature = true]</metric>
    <metric>count turtles with [sex = "male" and mature = true]</metric>
    <enumeratedValueSet variable="average_clutch_size">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maturity_age">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="juvenile_mortality">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult_mortality">
      <value value="0.06"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial_female_ratio">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max_mates">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="age_max">
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="clutch_size_std">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial_population">
      <value value="2000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="carrying_capacity">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new_female_ratio">
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance_to_hatch">
      <value value="0.01"/>
    </enumeratedValueSet>
    <steppedValueSet variable="random-seed" first="1" step="1" last="1000"/>
  </experiment>
  <experiment name="experiment 3" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="600"/>
    <metric>count turtles with [sex = "female"]</metric>
    <metric>count turtles with [sex = "male"]</metric>
    <metric>count turtles with [sex = "female" and mature = true]</metric>
    <metric>count turtles with [sex = "male" and mature = true]</metric>
    <enumeratedValueSet variable="average_clutch_size">
      <value value="575"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maturity_age">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="juvenile_mortality">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult_mortality">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial_female_ratio">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max_mates">
      <value value="4"/>
      <value value="5"/>
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="age_max">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="clutch_size_std">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial_population">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="carrying_capacity">
      <value value="300"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance_to_reach_maturity">
      <value value="0.002"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance_to_hatch">
      <value value="0.44"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new_female_ratio">
      <value value="0.86"/>
      <value value="0.87"/>
      <value value="0.88"/>
      <value value="0.89"/>
      <value value="0.91"/>
      <value value="0.92"/>
      <value value="0.93"/>
      <value value="0.94"/>
      <value value="0.96"/>
      <value value="0.97"/>
      <value value="0.98"/>
      <value value="0.99"/>
    </enumeratedValueSet>
    <steppedValueSet variable="random-seed" first="1" step="1" last="1000"/>
  </experiment>
  <experiment name="experiment 81-84" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="600"/>
    <metric>count turtles with [sex = "female"]</metric>
    <metric>count turtles with [sex = "male"]</metric>
    <metric>count turtles with [sex = "female" and mature = true]</metric>
    <metric>count turtles with [sex = "male" and mature = true]</metric>
    <enumeratedValueSet variable="average_clutch_size">
      <value value="575"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maturity_age">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="juvenile_mortality">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult_mortality">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial_female_ratio">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max_mates">
      <value value="4"/>
      <value value="5"/>
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="age_max">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="clutch_size_std">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial_population">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="carrying_capacity">
      <value value="300"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance_to_reach_maturity">
      <value value="0.002"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance_to_hatch">
      <value value="0.44"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new_female_ratio">
      <value value="0.81"/>
      <value value="0.82"/>
      <value value="0.83"/>
      <value value="0.84"/>
    </enumeratedValueSet>
    <steppedValueSet variable="random-seed" first="1" step="1" last="1000"/>
  </experiment>
  <experiment name="adult mortality increase" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="600"/>
    <metric>count turtles with [sex = "female"]</metric>
    <metric>count turtles with [sex = "male"]</metric>
    <metric>count turtles with [sex = "female" and mature = true]</metric>
    <metric>count turtles with [sex = "male" and mature = true]</metric>
    <enumeratedValueSet variable="average_clutch_size">
      <value value="575"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maturity_age">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="juvenile_mortality">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult_mortality">
      <value value="0.06"/>
      <value value="0.07"/>
      <value value="0.08"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial_female_ratio">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max_mates">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="age_max">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="clutch_size_std">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial_population">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="carrying_capacity">
      <value value="300"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance_to_reach_maturity">
      <value value="0.002"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance_to_hatch">
      <value value="0.44"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new_female_ratio">
      <value value="0.8"/>
    </enumeratedValueSet>
    <steppedValueSet variable="random-seed" first="1" step="1" last="1000"/>
  </experiment>
  <experiment name="experiment male bias" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="600"/>
    <metric>count turtles with [sex = "female"]</metric>
    <metric>count turtles with [sex = "male"]</metric>
    <metric>count turtles with [sex = "female" and mature = true]</metric>
    <metric>count turtles with [sex = "male" and mature = true]</metric>
    <enumeratedValueSet variable="average_clutch_size">
      <value value="575"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maturity_age">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="juvenile_mortality">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult_mortality">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial_female_ratio">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max_mates">
      <value value="4"/>
      <value value="5"/>
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="age_max">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="clutch_size_std">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial_population">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="carrying_capacity">
      <value value="300"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance_to_reach_maturity">
      <value value="0.002"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance_to_hatch">
      <value value="0.44"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new_female_ratio">
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
    </enumeratedValueSet>
    <steppedValueSet variable="random-seed" first="1" step="1" last="1000"/>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
