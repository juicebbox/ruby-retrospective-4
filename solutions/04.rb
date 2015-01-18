module UI
  class Element
    def initialize(style:nil, border:nil)
      @style = style if style
      @border = border
    end

    def add_style(style)
      @style = style unless @style
    end

    def create_border(text)
      "#{@border}#{text}#{@border}"
    end
  end

  class Label < Element
    def initialize(text:, style:nil, border:nil)
      @text = text
      super style:style, border:border
    end

    def apply_style
      @style ? @text.send(@style) : @text
    end

    def to_s
      create_border apply_style
    end
  end

  class Group < Element
    def initialize(style:nil, border:nil, &block)
      @elements = []
      instance_eval(&block)
      super style:style, border:border, &block
    end

    def label(text:, style:nil, border:nil)
      @elements << Label.new(text:text, style:style, border:border)
    end

    def horizontal(style:nil, border:nil, &block)
      @elements << HorizontalGroup.new(style:style, border:border, &block)
    end

    def vertical(style:nil, border:nil, &block)
      @elements << VerticalGroup.new(style:style, border:border, &block)
    end

    def apply_style
      @elements.each do |element|
        element.add_style @style
        element.apply_style
      end
    end
  end

  class HorizontalGroup < Group
    def to_s
      create_border @elements.each(&:apply_style).map(&:to_s).join("")
    end
  end

  class VerticalGroup < Group
    def create_border(text)
      lines = text.split("\n")
      max_length = lines.max_by(&:length).length
      lines.map { |line| super(line.ljust(max_length)) }.join("\n")
    end

    def to_s
      create_border @elements.each(&:apply_style).map(&:to_s).join("\n")
    end
  end

  class TextScreen
    def self.draw(&block)
      HorizontalGroup.new(&block)
    end
  end
end