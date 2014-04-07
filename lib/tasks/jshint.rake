# Load JSHint when jshintrb gem is available
begin
  require "jshintrb/jshinttask"
  Jshintrb::JshintTask.new :jshint do |t|
    t.pattern = "app/assets/javascripts/**/*.js"
    #t.options = :defaults
    # Custom options are below, uncomment the line
    # above for the default set of options.
    t.options = {
      :bitwise => true,
      :curly => false,
      :eqeqeq => true,
      :forin => true,
      :immed => true,
      :indent => 2,
      :latedef => true,
      :newcap => true,
      :noarg => true,
      :noempty => true,
      :nonew => true,
      :plusplus => false,
      :regexp => true,
      :undef => true,
      :strict => true,
      :trailing => true,
      :sub => true,
      :browser => true,
      :devel => true,
      :expr => true,
      :predef => {
        "requirejs" => false,
        "require" => false,
        "define" => false,
        "Modernizr" => false,
        "selectorSupported" => false,
        "google" => false
      }
    }
  end
rescue LoadError
end