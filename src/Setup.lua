WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
PADDLE_SPEED = 200
UNMUTED = true

push = require 'lib/push'
Class = require 'lib/class'
require 'src/Ball'
require 'src/Brick'
require 'src/LevelMaker'
require 'src/Paddle'
require 'src/StateMachine'
require 'src/Util'
require 'src/states/BaseState'
require 'src/states/EnterHighScoreState'
require 'src/states/GameOverState'
require 'src/states/HighScoreState'
require 'src/states/PlayState'
require 'src/states/ServeState'
require 'src/states/StartState'
require 'src/states/VictoryState'
require 'src/Powerup'
require 'src/states/PaddleSelectState'