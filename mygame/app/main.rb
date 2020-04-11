def tick args
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
    initial_dialog(args)
  elsif args.state.player.in_initial_cutscene
    initial_cutscene(args)
  end
end

def initial_dialog(args)
  args.state.levels.cutscene.dialog ||= 0
  if args.state.levels.cutscene.dialog == 0
    quote(args, "- Hey, bro, tell them what you saw last night!")
  elsif args.state.levels.cutscene.dialog == 1
    quote(args, "- I don't know, Pillboi... I think I just fell asleep and dreamed of it...")
  elsif args.state.levels.cutscene.dialog == 2
    quote(args, "- C'mon, bro... It's cool all the same!")
  elsif args.state.levels.cutscene.dialog == 3
    quote(args, "...")
  elsif args.state.levels.cutscene.dialog == 4
    quote(args, "- Give me that notebook and that pencil then.")
  elsif args.state.levels.cutscene.dialog == 5
    quote(args, "It all happened like this...")
  else
    args.state.player.in_initial_cutscene = true
    args.state.player.in_inital_dialog = false
  end
end

def quote(args, quote)
  if args.state.chars_printed == quote.length
    args.outputs.labels << [1280 / 2, 780 / 2, quote, 0, 1, 255, 255, 255]
    if !args.inputs.keyboard.truthy_keys.empty?
      args.state.levels.cutscene.dialog = args.state.levels.cutscene.dialog + 1
      args.state.chars_printed = 0
    end
    return
  end
  args.state.chars_printed ||= 0
  args.state.chars_printed = args.state.chars_printed + 1
  args.outputs.labels << [1280 / 2, 780 / 2, quote.slice(0, args.state.chars_printed), 0, 1, 255, 255, 255]
end

def initial_cutscene(args)
  args.outputs.solids << [0, 0, 1280, 720, 0, 0, 0]
end

$gtk.reset