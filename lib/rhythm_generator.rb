class RhythmGenerator 
  def generate_random_rhythm_divisions(instrument_list)
    [
      {
        instrument_name: instrument_list[0],
        rhythm_division: 
        [
          [#row
            [#rhythm
              {d: 1, r:[1,8]}
            ]
          ],
          [
            [
              {d:1, r:[1,40]},
              {d:4, r:[1,10]}
            ]
          ],
          [
            [
              {d:2, r:[1,100]},
              {d:3, r:[3,200]}
            ], 
            [
              {d:1, r:[1,70]},
              {d:4, r:[2,35]},
              {d:2, r:[1,35]}
            ]
          ],
          [
            [
              {d:1, r:[1,300]},
              {d:2, r:[1,150]}
            ], 
            [
              {d:4, r:[3,250]},
              {d:1, r:[3,1000]}
            ], 
            [
              {d:2, r:[1,175]},
              {d:2, r:[1,175]},
              {d:1, r:[1,350]}
            ], 
            [
              {d:1, r:[1,210]},
              {d:5, r:[2,42]}
            ], 
            [
              {d:1, r:[1,140]},
              {d:3, r:[3,140]}
            ]
          ]
        ]
      }
    ]
  end

  def generate_random_rhythm_from_to_points(rhythm_divisions)
    return [
      [
        [0,0,0,0]
      ],
      [
        [1,0,0,0], [1,0,1,1]
      ],
      [
        [2,0,0,0], [2,0,1,1], [2,1,0,0], [2,1,1,1], [2,1,2,2]
      ],
    ]
  end
end