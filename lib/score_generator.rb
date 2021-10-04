# frozen_string_literal: true

require_relative "score_generator/version"
require 'prawn'
require "./lib/rhythm_generator"

class ScorePdfGenerator < Prawn::Document
  # score layout
  # paper layout
  PAPER_WIDTH = 1000
  PAPER_HEIGHT = 1000
  PAPER_SIZE = [PAPER_WIDTH, PAPER_HEIGHT]
  PAPER_MARGIN = 100
  PAPER_CONTENTS_WIDTH = PAPER_WIDTH - PAPER_MARGIN * 2
  
  # staff layout
  STAFF_LINE_HEIGHT = 1
  STAFF_SPACE_HEIGHT = 4
  CLEF_WIDTH = 10
  CLEF_RIGHT_MARGIN = 0
  CLEF_AREA_WIRDH = CLEF_WIDTH + CLEF_RIGHT_MARGIN
  INSTRUMENT_FONT_SIZE = 10
  INSTRUMENT_NAME_RIGHT_MARGIN = 5
  KEY_SIGNATURE_RIGHT_MARGIN = 5
  NUMBER_TEXT_WIDTH = 5
  METER = [1, 8]
  METER_RIGHT_MARGINN = 5

  # note
  NOTE_WIDTH = 5


  # music-config
  INSTRUMENT_LIST = ['piano']


  def initialize    
    super(
      page_size: PAPER_SIZE,
      top_margin: PAPER_MARGIN,
      bottom_margin: PAPER_MARGIN,
      left_margin: PAPER_MARGIN,
      right_margin: PAPER_MARGIN
    )

    font 'assets/fonts/ipaexm.ttf'
    stroke_axis

    rhythm_generator = RhythmGenerator.new
    @rhythm_divisions = rhythm_generator.generate_random_rhythm_divisions(INSTRUMENT_LIST)

    @rhythm_from_to_points = rhythm_generator.generate_random_rhythm_from_to_points(@rhythm_divisions)

    @instrument_name_area_width = width_of(INSTRUMENT_LIST.max_by{|instrument|instrument.size}, :size => INSTRUMENT_FONT_SIZE) + INSTRUMENT_NAME_RIGHT_MARGIN
    
    @cursor_position = 0

    @rhythm_divisions.each do |rhythm_division|
      set_lyric_row
      set_dynamics_row
      set_ledger_line_row_below_staff
      set_staff_row(rhythm_division)
      set_ledger_line_row_above_staff
      set_rhythm_guide_rows(@rhythm_divisions)
      # set_cursor_line
    end   
  end

  private
    def set_lyric_row
    end

    def set_dynamics_row
    end

    def set_ledger_line_row_below_staff
      @cursor_position += 10
    end

    def set_staff_row(rhythm_division)

      staff_height = 0
      5.times.map{|i| 0 + (1 * i)}.each do |line|
        self.line_width = 0.5
        stroke_line [@instrument_name_area_width, @cursor_position + line * STAFF_SPACE_HEIGHT], [PAPER_CONTENTS_WIDTH, @cursor_position + line * STAFF_SPACE_HEIGHT] 
        staff_height += STAFF_SPACE_HEIGHT
      end

      set_instrument_name(rhythm_division[:instrument_name])
      set_clef('g')
      key_signature_area_width = set_key_signature('c-major') + KEY_SIGNATURE_RIGHT_MARGIN
      meter_area_width = set_meter(METER, @instrument_name_area_width + CLEF_AREA_WIRDH + key_signature_area_width) + METER_RIGHT_MARGINN
      @note_area_width = PAPER_CONTENTS_WIDTH - @instrument_name_area_width - CLEF_AREA_WIRDH - key_signature_area_width - meter_area_width
      # set_notehead(PAPER_CONTENTS_WIDTH - @note_area_width + NOTE_WIDTH)
      @cursor_position = staff_height
    end

    def set_ledger_line_row_above_staff
      @cursor_position += 50
    end

    def set_rhythm_guide_rows(set_rhythm_guide_rows)
      set_rhythm_guide_rows.each do |instrument|
        instrument[:rhythm_division].each do |rhythm_guide_row|
          rhythm_guide_row.each do |rhythm|
            base_number_of_flag = calc_number_of_flags(rhythm[0])
            p base_number_of_flag



          end

        end

      end
    end

    def set_cursor_line
      stroke_line [0, @cursor_position], [PAPER_CONTENTS_WIDTH, @cursor_position]
    end

    def set_notehead(x)
      rotate(17, origin:[x, @cursor_position]) do
        fill_ellipse [x, @cursor_position], 3, 2
      end
    end

    def set_instrument_name(instrument_name)
      draw_text instrument_name, size: INSTRUMENT_FONT_SIZE, at: [0, @cursor_position + STAFF_SPACE_HEIGHT]
    end

    def set_clef(clef_type)
      font 'assets/fonts/notes.ttf'
      if clef_type == 'g'
        draw_text '&', size: 16, at: [@instrument_name_area_width, @cursor_position + STAFF_SPACE_HEIGHT]
      elsif clef_type == 'f'
        draw_text '?', size: 16, at: [@instrument_name_area_width, @cursor_position]
      end
    end

    def set_key_signature(key_type)
      0
    end

    def set_meter(meter, x)
      font 'assets/fonts/notes.ttf'
      draw_text meter[0], size: 16, at: [x, @cursor_position + STAFF_SPACE_HEIGHT * 3]
      draw_text meter[1], size: 16, at: [x, @cursor_position + STAFF_SPACE_HEIGHT]
      meter.max_by{|number|number.to_s.size} * NUMBER_TEXT_WIDTH
    end


    def calc_number_of_flags(rhythm)
      base_ratio = Rational(rhythm[:r][0], rhythm[:d] * rhythm[:r][1])

      pow = 3
      number_of_flags = 1

      while base_ratio < Rational(1, 2**(pow + number_of_flags))
        number_of_flags += 1
      end
      number_of_flags
    end

end

