# CSS
require 'css/app'
require 'famous/core/famous.css'

# Polyfills
require 'famous-polyfills/functionPrototypeBind'
require 'famous-polyfills/classList'
require 'famous-polyfills/requestAnimationFrame'

# Famous
Engine = require 'famous/core/Engine'

# Views
AppView = require 'views/AppView'
FpsMeter = require 'widgets/FpsMeter'

# Create the main context
mainContext = Engine.createContext()

# Set perspective for 3D effects
# Lower values make effects more pronounced and extreme
mainContext.setPerspective 2000

mainContext.add new AppView
mainContext.add new FpsMeter

