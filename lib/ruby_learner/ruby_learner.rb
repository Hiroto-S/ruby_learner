require 'fileutils'
require 'thor'
require 'open3'
require 'ruby_learner/version'
require 'ruby_learner/common'
require 'ruby_learner/sequential_check'
require 'ruby_learner/beginner_check'
require 'ruby_learner/sequential_check_manual'
require 'ruby_learner/restore'
require 'ruby_learner/copspec'

module RubyLearner
  # ruby_learner CLI main class
  class CLI < Thor
    def initialize(*args)
      super
      @local_dir = "#{ENV['HOME']}/.ruby_learner"
      @workshop_dir = "#{@local_dir}/workshop"
      @restore_dir = "#{@local_dir}/restore"
      @data_dir = "#{@local_dir}/.data"
      @gem_dir = File.expand_path("../../../", __FILE__)
      Common.allocate.init_mk_files(gem_dir: @gem_dir, local_dir: @local_dir)
    end

    desc '-v', 'show program version'
    map "-v" => "version"
    def version
      puts RubyLearner::VERSION
    end

    desc "emacs_key", 'check emacs key-bindings'
    option :image, aliases: :i, type: :boolean
    def emacs_key(*args)
      if options[:image]
        system("open #{@data_dir}/emacs_help.pdf")
      else
        system("cat #{@data_dir}/emacs_help.org")
      end
    end

    desc 'pair_popup [time]','popup_per_time'
    map "-p" => "pair_popup"
    def pair_popup(*args)
      if args[0].to_i == nil || args[0].to_i == 0
        puts "your input is #{args[0]}. not exchange time."
        return
      end
      time = args[0].to_i
      file = File.expand_path("../pair_timer.rb", __FILE__)
      system("ruby #{file} #{time} &")
    end

    desc 'copspec [file_path]','check rspec and rubocop'
    map "-c" => "copspec"
    option :sequential_check, aliases: :s, type: :boolean
    def copspec(*args)
      begin
        if options[:sequential_check]
          CopSpec.copspec("#{@workshop_dir}/lib/workplace.rb")
        else
          CopSpec.copspec(args[0])
        end
      rescue => error
        puts "Error.message: #{error.message}"
      end
    end

    desc 'sequential_check [section:1~11] [part:1~3]','learning drill'
    map "-s" => "sequential_check"
    option :workshop, aliases: :w, typw: :boolean
    option :manual, aliases: :m, type: :boolean
    option :copspec, aliases: :c, type: :boolean
    option :next, aliases: :n, type: :boolean
    option :drill, aliases: :d, type: :boolean
    option :last, aliases: :l, type: :boolean
    def sequential_check(*args)
      begin
        mode = File.read("#{@data_dir}/sequential_mode.txt").chomp
        puts "active mode: #{mode}"
        sequential_check = nil
        if mode == 'nomal'
          sequential_check = SequentialCheck.new(@gem_dir, @local_dir)
        else
          sequential_check = SequentialCheckManual.new(@gem_dir, @local_dir)
        end
        if options[:drill]
          sequential_check.drill_contents
        elsif options[:next]
          sequential_check.next_action
        elsif options[:last]
          sequential_check.last_re_action
        elsif options[:manual]
          sequential_check.change_mode
          mode = File.read("#{@data_dir}/sequential_mode.txt").chomp
          puts "active mode changed: #{mode}"
        elsif options[:copspec]
          CopSpec.copspec("#{@workshop_dir}/lib/workplace.rb")
        elsif options[:workshop]
          puts "#{@data_dir}/chdir_workshop.sh"
          Dir.chdir "#{@workshop_dir}"
          exec 'fish'
        else
          sequential_check.action(args[0], args[1])
        end
      rescue => error
        puts "Error.message: #{error.message}"
        sequential_check.instruct_modes
      end
    end

    desc 'beginner_check [section:1~11] [part:1~3]','learning drill'
    map "-b" => "beginner_check"
    option :next, aliases: :n, type: :boolean
    option :drill, aliases: :d, type: :boolean
    option :last, aliases: :l, type: :boolean
    def beginner_check(*args)
      begin
        beginner_check = nil
        beginner_check = BeginnerCheck.new(@gem_dir, @local_dir)

        if options[:drill]
          beginner_check.drill_contents
        elsif options[:next]
          beginner_check.next_action
        elsif options[:last]
          beginner_check.last_re_action
        else
          beginner_check.action(args[0], args[1])
        end
      rescue => error
        puts "Error.message: #{error.message}"
        beginner_check.instruct_modes
      end
    end


    desc 'restore','check your restore'
    map "-r" => "restore"
    option :refresh, aliases: :r, type: :boolean
    option :copspec, aliases: :c, type: :boolean
    def restore(*args)
      restore = Restore.new
      if options[:refresh]
        system("rm -rf #{@restore_dir}")
        system("mkdir #{@restore_dir}")
      elsif args.empty? == true
        restore.output
      else
        restore.open(args[0].to_i)
      end
    end

    desc 'install_emacs','install emacs in your mac'
    def install_emacs
      file_path = "#{@data_dir}/install_emacs.sh"
      system("sh #{file_path}")
    end

    desc 'theme [black or white]',"change ruby_learner's theme"
    def theme(*args)
      args[0].chomp
      if args[0] == 'black' || args[0] == 'white'
        Common.allocate.change_theme(color: args[0], datas_dir: @data_dir)
      else
        puts "you can change the theme_color, only black or white."
      end
    end
  end
end
