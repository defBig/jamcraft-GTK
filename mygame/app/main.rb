def tick args
  debug(args)
  if args.state.player.in_initial_screen.nil?
    args.state.player.in_initial_screen = true
  end
  if args.state.player.in_initial_screen
    args.outputs.solids << [0, 0, 1280, 720, 0, 0, 0]
    args.outputs.labels << [1280 / 2, 720 / 2, "Press any key to start the game...", 0, 1, 255, 255, 255]
    if !args.inputs.keyboard.truthy_keys.empty?
      args.state.player.in_inital_dialog = true
      args.state.player.in_initial_screen = false
    end
  end
  if args.state.player.in_inital_dialog
    args.outputs.solids << [0, 0, 1280, 720, 0, 0, 0]
    load_initial_dialog(args)
  elsif args.state.player.in_initial_cutscene
    initial_cutscene(args)
  end
end

def debug(args)
  args.state.player.in_inital_dialog = false
  args.state.player.in_initial_screen = false
  args.state.player.in_initial_cutscene = true
end

def load_initial_dialog(args)
  args.state.levels.initial_dialog.dialog ||= 0
  if args.state.levels.initial_dialog.dialog == 0
    quote(args, "- Hey, bro, tell them what happened to you the other day!", 1280 / 2, 720 / 2)
  elsif args.state.levels.initial_dialog.dialog == 1
    quote(args, "- I don't know, Pillboi... I think I just fell asleep and dreamed of it...", 1280 / 2, 720 / 2)
  elsif args.state.levels.initial_dialog.dialog == 2
    quote(args, "- C'mon, bro... It's cool all the same!", 1280 / 2, 720 / 2)
  elsif args.state.levels.initial_dialog.dialog == 3
    quote(args, "...", 1280 / 2, 720 / 2)
  elsif args.state.levels.initial_dialog.dialog == 4
    quote(args, "- Ok, then.", 1280 / 2, 720 / 2)
  elsif args.state.levels.initial_dialog.dialog == 5
    quote(args, "It all happened like this...", 1280 / 2, 720 / 2)
  else
    args.state.player.in_initial_cutscene = true
    args.state.player.in_inital_dialog = false
  end
end

def quote(args, quote, x, y)
  if args.state.chars_printed == quote.length
    args.outputs.labels << [x, y, quote, 0, 1, 255, 255, 255]
    if !args.inputs.keyboard.truthy_keys.empty?
      args.state.levels.initial_dialog.dialog = args.state.levels.initial_dialog.dialog + 1
      args.state.chars_printed = 0
    end
    return
  end
  args.state.chars_printed ||= 0
  args.state.chars_printed = args.state.chars_printed + 1
  args.outputs.labels << [x, y, quote.slice(0, args.state.chars_printed), 2, 1, 255, 255, 255]
end

def initial_cutscene(args)
  args.state.levels.cutscene.background ||= 0
  args.state.ticks_snapshot ||= args.state.tick_count
  if args.state.levels.cutscene.background == 0
    args.outputs.sprites << args.outputs.sprites << [0, 0, 1280, 720, "sprites/sky_0.jfif", 0, (args.state.tick_count - args.state.ticks_snapshot) + 50]
    if ((args.state.tick_count - args.state.ticks_snapshot) + 50) == 255
      args.state.levels.cutscene.background = 1
      args.state.ticks_snapshot = nil
    end
  elsif args.state.levels.cutscene.background == 1
    args.outputs.sprites << [0, 0 - (args.state.tick_count - args.state.ticks_snapshot), 1280, 720, "sprites/sky_0.jfif", 0]
    args.outputs.sprites << [0, 720 - (args.state.tick_count - args.state.ticks_snapshot), 1280, 720, "sprites/sky_1.jfif", 0]
    if args.state.tick_count - args.state.ticks_snapshot < 240
      quote(args, "It was early summer and the night was nice and warm...", 1280 / 2, 720 / 9)
      return
    elsif args.state.tick_count - args.state.ticks_snapshot < 480
      quote(args, "So I decided to go outside and lay in the grass...", 1280 / 2, 720 / 9)
      return
    else
      quote(args, "I was just stargazing, when I saw it...", 1280 / 2, 720 / 9)
    end
    if 720 - (args.state.tick_count - args.state.ticks_snapshot) == 0
      args.state.levels.cutscene.background = 2
      args.state.ticks_snapshot = nil
    end
  elsif args.state.levels.cutscene.background == 2
    if args.state.tick_count - args.state.ticks_snapshot < 60
      args.outputs.sprites << [0, 0, 1280, 720, "sprites/sky_2.jfif", 0]
      quote(args, "A bright moving spot in the sky!", 1280 / 2, 720 / 9)
      return
    elsif args.state.tick_count - args.state.ticks_snapshot < 120
      args.outputs.sprites << [0, 0, 1280, 720, "sprites/sky_3.jfif", 0]
      quote(args, "A bright moving spot in the sky!", 1280 / 2, 720 / 9)
      return
    elsif args.state.tick_count - args.state.ticks_snapshot < 180
      args.outputs.sprites << [0, 0, 1280, 720, "sprites/sky_2.jfif", 0]
      quote(args, "A bright moving spot in the sky!", 1280 / 2, 720 / 9)
      return
    else
      args.state.levels.cutscene.background = 3
      args.state.ticks_snapshot = nil
    end
  elsif args.state.levels.cutscene.background == 3
    args.state.levels.cutscene.frame ||= 4
    args.outputs.sprites << [0, 0, 1280, 720, "sprites/sky_#{args.state.levels.cutscene.frame}.jfif", 0]
    quote(args, "It would keep getting closer and closer...", 1280 / 2, 720 / 9)
    if ((args.state.tick_count - args.state.ticks_snapshot) % 60) == 0
      args.state.levels.cutscene.frame = args.state.levels.cutscene.frame + 1
    end
    if args.state.levels.cutscene.frame == 9
      args.state.levels.cutscene.background = 4
      args.state.ticks_snapshot = nil
    end
  else
    exit
  end
end

$gtk.reset