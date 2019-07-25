# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'rails_jwt_auth/spec_helpers'
require 'capybara/rails'
# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.include FactoryBot::Syntax::Methods

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.include RailsJwtAuth::SpecHelpers, type: :controller

  # Cuando el entorno de test carga, solo lo hace nuestra API hecha en RoR.
  # Aquí lo que hacemos es copiar los ficheros del front en el directorio public
  # y asignar el puerto 3333. De esta forma, accediendo a http://localhost:3333,
  # el navegador encuentra el fichero index.html del front.
  #
  # La variable de entorno SKIP_COMPILE nos sirve para evitar compilar el front
  # para agilizar los tests si no hemos hecho ningún cambio en los ficheros.
  unless config.files_to_run.select { |x| x.include?('features') }.empty?
    config.before :suite do
      Capybara.server_port = 3333
      unless ENV['SKIP_COMPILE'] || ENV['CI'] && File.exist?('public/application.js')
        command = "API_HOST='http://#{Capybara.server_host}:3333' " \
        "WS_HOST='ws://#{Capybara.server_host}:3333/cable' npm --prefix ./client run test"
        `#{command}`
      end
    end
  end

  # Esta es la ruta de partida para los tests de front.
  # Aquí vemos la primera referencia al type que vamos a usar, :feature
  config.before :each, type: :feature do
    visit '/#/'
  end

  # Con los dos siguientes config, preparamos los tests para que guarden una captura del navegador
  # cuando fallen. Esto es de mucha ayuda a la hora de hacer debug.

  # Limpiamos el directorio de las capturas antes de empezar
  config.before :suite do
    FileUtils.rm_rf(Dir[Rails.root.join('tmp', 'errors')])
  end

  # Aquí está la lógica que guarda la captura al fallar un test.
  # Las capturas se crean dentro del directorio tmp/errors con el nombre y la línea
  # del test que falla.
  config.after do |example|
    if example.metadata[:js] && example.exception
      path = File.expand_path(File.join('tmp/errors'))
      Dir.mkdir(path) unless Dir.exist?(path)
      screenshot = "#{example.file_path.gsub(/[\.\/]/, '-')}-#{example.metadata[:line_number]}.png"
      page.save_screenshot File.join(path, screenshot)
    end
  end

  # Y por último configuramos Capybara para usar Selenium con Google Chrome.
  # Creamos dos drivers: uno para usar chrome en modo headless y otro para que se ejecute en
  # primer plano.

  config.before do |example|
    next unless example.metadata[:capybara_feature]

    Capybara.current_driver = example.metadata[:driver] || :chrome_headless
  end

  # Configure Capybara
  Capybara.register_driver :chrome_headless do |app|
    Capybara::Selenium::Driver.new(
      app, browser: :chrome,
           options: Selenium::WebDriver::Chrome::Options.new(
             args: %w[headless no-sandbox disable-gpu window-size=1920,1080]
           )
    )
  end

  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  Capybara.javascript_driver = :chrome_headless
  Capybara.server = :webrick
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

Dir['spec/support/**/*.rb'].each { |f| require "./#{f}" }
