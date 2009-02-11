Jello::Mould.new do |paste|
  `echo "Jello did its thing!" | growlnotify "Jello"`
  paste
end
