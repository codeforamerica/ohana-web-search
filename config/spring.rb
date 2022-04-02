Spring.watch(
  '.ruby-version',
  '.rbenv-vars',
  'tmp/restart.txt',
  'tmp/caching-dev.txt',
  'config/application.yml',
  'config/settings.yml'
)

Spring.watch_method = :listen
