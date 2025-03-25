# Credit: Zøzo

require 'fileutils'

file_paths = [
  'Data/Text/Dialogs/120000.csv',
  'Data/configs/z_tera_max_config.json',
  'graphics/interface/battle/button_zmove.png',
  'graphics/interface/battle/button_zmove_activated.png',
  'graphics/interface/battle/button_dynamax.png',
  'graphics/interface/battle/button_dynamax_activated.png',
  'graphics/interface/gigantamax_icon.png'
]

file_paths.each do |file|
  if File.exist?(file)
    puts "Overwriting #{file}"
    File.delete(file)
  else
    puts "Overwriting not necessary for #{file}"
  end
end
