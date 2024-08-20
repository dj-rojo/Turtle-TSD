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

