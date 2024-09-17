# frozen_string_literal: true

Reline::Face.config(:completion_dialog) do |conf|
  conf.define :default, foreground: :white, background: :black
  conf.define :enhanced, foreground: :black, background: :white
  conf.define :scrollbar, foreground: :white, background: :black
end

if defined? Rails
  root_component = IRB::Color.colorize(File.basename(Dir.pwd), %i[YELLOW])
  env_color = Rails.env.production? ? :RED : :GREEN
  env_component = IRB::Color.colorize("[#{Rails.env}]", [env_color, :BOLD, :REVERSE])

  prompt = "#{root_component} #{env_component}"

  IRB.conf[:PROMPT] ||= {}
  IRB.conf[:PROMPT][:RAILS] = {
    PROMPT_I: "#{prompt}%l %03n > ",
    PROMPT_S: "#{prompt} %03n * ",
    PROMPT_C: "#{prompt} %03n ? ",
    RETURN: "=> %s\n"
  }

  IRB.conf[:PROMPT_MODE] = :RAILS
end
