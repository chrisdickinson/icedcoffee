root: exports ? this;
icedcoffee : root.icedcoffee ? {};

class Stack
    constructor: () ->
        @elements: []
        @counter: 0 
        @subcounter: 0 
        self: this
        $('.slide').each(() ->
            elems: []
            $(this).children('div').each(() ->
                elems.push this
                $(this).hide()
            )
            self.elements.push elems
        )
        @prev: () ->
            [current, previous]: [[@counter, @subcounter], [@counter, @subcounter-1]]
            previous[0]: previous[0] - 1 if previous[1] < 0
            previous[1]: @elements[previous[0]].length - 1 if previous[1] < 0
            perform: previous[0] > 0
            if perform
                if current[0] != previous[0]
                    $(@elements[current[0]][0]).parent().fadeOut('fast', () =>
                        $(@elements[previous[0]][0]).parent().fadeIn 'fast'
                    )
                else
                    $(@elements[current[0]][previous[1]]).fadeOut 'fast'

            [@counter, @subcounter]: previous
        @next: () ->
            [current, next]: [[@counter, @subcounter], [@counter, @subcounter+1]]
            next[0]: next[0] + 1 if next[1] == @elements[next[0]].length
            next[1]: 0 if next[0] != current[0] 
            perform: @elements.length != next[0]
            if perform
                if current[0] != next[0]
                    $(@elements[current[0]][0]).parent().fadeOut('fast', () =>
                        $(@elements[next[0]][0]).parent().fadeIn 'fast'
                    )
                else
                    $(@elements[current[0]][next[1]]).fadeIn 'fast'
            [@counter, @subcounter]: next 

class Input
    constructor: () ->
        @stack = []

    next: (event) ->
        icedcoffee.stack.next()

    prev: (event) ->
        icedcoffee.stack.prev()

class BrowserInput extends Input
    constructor: () ->
        delegate: (event) =>
            event.preventDefault()
            exec: if event.shiftKey then @prev else @next
            exec()
        $(document).bind('click', delegate)
    next: () ->
        super()

    prev: () ->
        super()

class ConsoleInput extends Input
    constructor: () ->
        null

icedcoffee.init: () ->
    @stack = new Stack()
    @input = new BrowserInput()

root.icedcoffee: icedcoffee
