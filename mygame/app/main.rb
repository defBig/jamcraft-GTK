def tick args
  args.state.level ||= 2
  load_level(args)
end

def load_level(args)
  if args.state.level == 0
    args.outputs.solids << [0, 0, 1280, 720, 0, 0, 0]
    args.outputs.labels << [1280 / 2, 720 / 2, "Press any key to start the game...", 0, 1, 255, 255, 255]
    if !args.inputs.keyboard.truthy_keys.empty?
      args.state.level =  args.state.level + 1
    end
  elsif args.state.level == 1
    args.outputs.solids << [0, 0, 1280, 720, 0, 0, 0]
    load_initial_dialog(args)
  elsif args.state.level == 2
    load_initial_cutscene(args)
  end
end

def load_initial_dialog(args)
  args.state.dialog ||= 0
  if args.state.dialog == 0
    dialog_box(args, "- Hey, bro, tell them what happened to you the other day!", 1280 / 2, 720 / 2)
  elsif args.state.dialog == 1
    dialog_box(args, "- I don't know, Pillboi... I think I just fell asleep and dreamed of it...", 1280 / 2, 720 / 2)
  elsif args.state.dialog == 2
    dialog_box(args, "- C'mon, bro... It's cool all the same!", 1280 / 2, 720 / 2)
  elsif args.state.dialog == 3
    dialog_box(args, "...", 1280 / 2, 720 / 2)
  elsif args.state.dialog == 4
    dialog_box(args, "- Ok, then.", 1280 / 2, 720 / 2)
  elsif args.state.dialog == 5
    dialog_box(args, "It all happened like this...", 1280 / 2, 720 / 2)
  else
    args.state.level =  args.state.level + 1
  end
end

def dialog_box(args, quote, x, y)
  if args.state.chars_printed == quote.length
    args.outputs.labels << [x, y, quote, 2, 1, 255, 255, 255]
    if !args.inputs.keyboard.truthy_keys.empty?
      args.state.dialog = args.state.dialog + 1
      args.state.chars_printed = 0
    end
    return
  end
  args.state.chars_printed ||= 0
  args.state.chars_printed = args.state.chars_printed + 1
  args.outputs.labels << [x, y, quote.slice(0, args.state.chars_printed), 2, 1, 255, 255, 255]
end

def load_initial_cutscene(args)
  args.state.background ||= 0
  args.state.tick_snapshot ||= args.state.tick_count
  if args.state.background == 0
    args.outputs.solids << [0, 0, 1280, 720, 0, 0, 0]
    args.outputs.sprites << args.outputs.sprites << [0, 0, 1280, 720, "sprites/sky_0.jfif", 0, args.state.tick_count - args.state.tick_snapshot]
    if args.state.tick_count - args.state.tick_snapshot == 255
      args.state.background = 1
      args.state.tick_snapshot = nil
    end
  elsif args.state.background == 1
    args.outputs.sprites << [0, 0 - (args.state.tick_count - args.state.tick_snapshot), 1280, 720, "sprites/sky_0.jfif", 0]
    args.outputs.sprites << [0, 720 - (args.state.tick_count - args.state.tick_snapshot), 1280, 720, "sprites/sky_1.jfif", 0]
    if args.state.tick_count - args.state.tick_snapshot < 240
      dialog_box(args, "It was early summer and the night was nice and warm...", 1280 / 2, 720 / 9)
      return
    elsif args.state.tick_count - args.state.tick_snapshot < 480
      dialog_box(args, "So I decided to go outside and lay in the grass...", 1280 / 2, 720 / 9)
      return
    else
      dialog_box(args, "I was only stargazing, when I saw it...", 1280 / 2, 720 / 9)
    end
    if 720 - (args.state.tick_count - args.state.tick_snapshot) == 0
      args.state.background = 2
      args.state.tick_snapshot = nil
    end
  elsif args.state.background == 2
    if args.state.tick_count - args.state.tick_snapshot < 60
      args.outputs.sprites << [0, 0, 1280, 720, "sprites/sky_2.jfif", 0]
      dialog_box(args, "A bright moving spot in the sky!", 1280 / 2, 720 / 9)
      return
    elsif args.state.tick_count - args.state.tick_snapshot < 120
      args.outputs.sprites << [0, 0, 1280, 720, "sprites/sky_3.jfif", 0]
      dialog_box(args, "A bright moving spot in the sky!", 1280 / 2, 720 / 9)
      return
    elsif args.state.tick_count - args.state.tick_snapshot < 240
      args.outputs.sprites << [0, 0, 1280, 720, "sprites/sky_2.jfif", 0]
      dialog_box(args, "A bright moving spot in the sky!", 1280 / 2, 720 / 9)
      return
    else
      args.state.background = 3
      args.state.tick_snapshot = nil
    end
  elsif args.state.background == 3
    args.state.frame ||= 4
    args.outputs.sprites << [0, 0, 1280, 720, "sprites/sky_#{args.state.frame}.jfif", 0]
    if args.state.frame < 7
      dialog_box(args, "It started getting closer and closer...", 1280 / 2, 720 / 9)
    else
      dialog_box(args, "Until...", 1280 / 2, 720 / 9)
    end
    if ((args.state.tick_count - args.state.tick_snapshot) % 60) == 1
      args.state.frame = args.state.frame + 1
    end
    if args.state.frame == 9
      args.state.background = 4
      args.state.tick_snapshot = nil
    end
  else
    exit
  end
end

$gtk.reset
