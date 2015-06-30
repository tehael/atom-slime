{CompositeDisposable} = require 'atom'
{TextEditorView, View} = require 'atom-space-pen-views'

module.exports =
class REPLView extends View
  swank: null
  @content: ->
    @div tabIndex: -1, class: 'panel atom-slime-repl panel-bottom', =>
      @div class: 'atom-slime-repl-output', =>
        @pre class: "terminal", outlet: "output"
      @div class: 'atom-slime-repl-input', =>
        @subview 'inputText', new TextEditorView(mini: true, placeholderText: 'input your command here')

  initialize: ->
    atom.commands.add @inputText.element,
      'core:confirm': =>
        if @swank
          input = @inputText.getModel().getText()
          @swank.eval input, 'COMMON-LISP-USER'
          @writePrompt(input)
          @inputText.getModel().setText('')

  setSwank: (@swank) ->

  scrollToBottom: ->
    @output.scrollTop 10000000


  writePrompt: (text) ->
    @output.append "<span class=\"repl-prompt\">Pike&gt;</span> #{text}<br/>"
    @scrollToBottom()

  writeSuccess: (text) ->
    @output.append "<span class=\"repl-success\">#{text}</span>"
    @scrollToBottom()





  attach: ->
    @panel = atom.workspace.addBottomPanel(item: this, priority: 20)