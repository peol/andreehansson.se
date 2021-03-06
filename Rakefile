require 'yaml'

ENV['JEKYLL_ENV'] = "production"
CONFIG = YAML.load_file("_config.yml")

def which(cmd)
  exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
    exts.each { |ext|
      exe = "#{path}/#{cmd}#{ext}"
      return exe if File.executable? exe
    }
  end
  return nil
end

task :default => [:all]

task :build do
  print "Building website... "
  if (not which("jekyll"))
    puts "failed. - jekyll executable not found."
  else
    system "jekyll > /dev/null 2>&1"
  puts "done."
  end
end

task :generatecss do
  print "Generating stylesheets... "
  if (not which("compass"))
    puts "failed. - compass executable not found."
  else
    system "compass clean -q assets/"
    system "compass compile -q assets/"
    puts "done."
  end
end

task :compressassets do
  print "Compressing assets... "
  if (not which("jammit"))
    puts "failed. - jammit executable not found."
  else
    system "jammit -o _site/assets -c _assets.yml"
    puts "done."
  end
end

task :optimizepngs do
  print "Optimizing PNGs... "
  if (not which("optipng"))
    puts "failed. - optipng executable not found."
  else
    system "optipng -quiet -o7 _site/assets/img/*.png"
    puts "done."
  end
end

task :deploy do
  print "Deploying to remote server... "
  if (not which("rsync"))
    puts "failed. - rsync executable not found."
  elsif (CONFIG['rsync_params'] == "nil")
    puts "failed. - no rsync settings."
  else
    system "rsync #{CONFIG['rsync_params']}"
    puts "done."
  end
end

task :all do
  Rake::Task["build"].invoke
  Rake::Task["generatecss"].invoke
  Rake::Task["compressassets"].invoke
  #Rake::Task["optimizepngs"].invoke
  Rake::Task["deploy"].invoke
end
