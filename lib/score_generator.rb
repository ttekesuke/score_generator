# frozen_string_literal: true

require_relative "score_generator/version"
require 'prawn'

class ScorePdfGenerator < Prawn::Document
  # score-layout
  # paper layout
  PAPER_WIDTH = 1000
  PAPER_HEIGHT = 1000
  PAPER_SIZE = [PAPER_WIDTH, PAPER_HEIGHT]
  PAPER_MARGIN = 100
  PAPER_CONTENTS_WIDTH = PAPER_HEIGHT - PAPER_MARGIN * 2
  # staff
  STAFF_LINE_HEIGHT = 1
  STAFF_SPACE_HEIGHT = 4

  # music-config
  NUMBER_OF_STAFFS = 1


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


    @height_list_of_staffs = [].fill(0, 0, NUMBER_OF_STAFFS)
    
    @cursor_position = 0

    @height_list_of_staffs.each do |_|
      set_lyric_row
      set_dynamics_row
      set_ledger_line_row_below_staff
      set_staff_row
      set_ledger_line_row_above_staff
      set_rhythm_rows
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

    def set_staff_row
      staff_height = 0
      5.times.map{|i| 0 + (1 * i)}.each do |line|
        stroke_line [0, @cursor_position + line * STAFF_SPACE_HEIGHT], [PAPER_CONTENTS_WIDTH, @cursor_position + line * STAFF_SPACE_HEIGHT] 
        staff_height += STAFF_SPACE_HEIGHT
      end
      set_clef('g')
      set_notehead(20)
      @cursor_position = staff_height
    end

    def set_ledger_line_row_above_staff
      @cursor_position += 50
    end

    def set_rhythm_rows
    end

    def set_cursor_line
      stroke_line [0, @cursor_position], [PAPER_CONTENTS_WIDTH, @cursor_position]
    end

    def set_notehead(x)
      rotate(15, origin:[x, @cursor_position]) do
        fill_ellipse [x, @cursor_position], 3, 2
      end
    end

    def set_clef(clef_type)
      font 'assets/fonts/notes.ttf'
      if clef_type == 'g'
        draw_text '&', size: 16, at: [0, @cursor_position + STAFF_SPACE_HEIGHT]
      elsif clef_type == 'f'
        draw_text '?', size: 16, at: [0, @cursor_position]
      end
    end
end

