require 'ruby_learner/sequential_check'

class BeginnerCheck < SequentialCheck
  def action(sec, par)
    puts "section_#{sec}/part_#{par}"
    seq_dir = "#{@gem_dir}/contents/questions/beginner_check/section_#{sec}/part_#{par}"
    rubocop_rspec_check = RubocopRspecCheck.new(@local_dir, @gem_dir)
    rubocop_rspec_check.action(mode_dir: seq_dir, is_copy: true)
    write_final_history(sec, par)
  end

  def get_final_history
  final_history = ''
  File.open("#{@data_dir}/final_history_beginner.txt") do |f|
    final_history = f.gets
  end
  final_sec = final_history.match(/(.*)\-/)[1].to_i
  final_par = final_history.match(/\-(.*)/)[1].to_i
  return final_sec, final_par
end

def get_next_question(final_sec, final_par)
  # 条件書いていく
  # if final_sec == 1 final_par == 3 etc... 
  if final_par == 3
    next_sec = final_sec + 1
    next_sec = 1 if next_sec >= 12
    return next_sec, 1
  else
    return final_sec, final_par+1
  end
end
end
