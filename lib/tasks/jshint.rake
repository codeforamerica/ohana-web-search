# Load JSHint when jshintrb gem is available
begin
  require "jshintrb/jshinttask"
  Jshintrb::JshintTask.new :jshint do |t|
    t.pattern = 'app/assets/javascripts/**/*.js*'
    # Custom options following in this file, uncomment the line below for the
    # default set of options.
    # t.options = :defaults
    #
    # All Enforcing options are included in the custom options below.
    # with the exception of freeze and nonbsp as the gem in use doesn't
    # support them.
    # See http://www.jshint.com/docs/options/ for documentation of JSHint
    # options, including additional Relaxing options and Environments options.
    t.options = {
      bitwise:        false,
      camelcase:      false,
      curly:          false,
      eqeqeq:         true,
      es3:            true,
      forin:          true,
      immed:          true,
      indent:         2,
      latedef:        true,
      newcap:         true,
      noarg:          true,
      noempty:        true,
      nonew:          true,
      plusplus:       false,
      quotmark:       true,
      undef:          true,
      unused:         true,
      strict:         true,
      maxparams:      5,
      maxdepth:       5,
      maxstatements:  25,
      maxcomplexity:  10,
      maxlen:         80,

      browser:        true,
      devel:          true,
      predef: {
        requirejs:    false,
        require:      false,
        define:       false,
        Modernizr:    false,
        google:       false
      }
    }
  end
rescue LoadError
end