require "./lib/score_generator"

pdf = ScorePdfGenerator.new
IO.write('as_written.pdf', pdf.render)