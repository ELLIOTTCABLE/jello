Jello::Mould.new do |paste|
  `echo 'Jello just operated on [#{paste.gsub "'", "'\\''" }]' | growlnotify "Jello"`
  paste
end
