# frozen_string_literal:true

module Inventory
  # Generic class
  class Generic
    attr_reader :quality, :sell_in

    def initialize(quality, sell_in)
      @quality, @sell_in = quality, sell_in
    end

    def update
      if @quality > 0
        @quality = @quality - 1
      end
      @sell_in = @sell_in - 1
      if @sell_in < 0
        if @quality > 0
          @quality = @quality - 1
        end
      end
    end
  end

  # AgedBrie class
  class AgedBrie
    attr_reader :quality, :sell_in

    def initialize(quality, sell_in)
      @quality, @sell_in = quality, sell_in
    end

    def update
      if @quality < 50
        @quality = @quality + 1
      end
      @sell_in = @sell_in - 1
      if @sell_in < 0
        if @quality < 50
          @quality = @quality + 1
        end
      end
    end
  end

  # BackstagePass class
  class BackstagePass
    attr_reader :quality, :sell_in

    def initialize(quality, sell_in)
      @quality, @sell_in = quality, sell_in
    end

    def update
      @quality = @quality + 1
      if @quality < 50
        if @sell_in < 11
          if @quality < 50
            @quality = @quality + 1
          end
        end
        if @sell_in < 6
          if @quality < 50
            @quality = @quality + 1
          end
        end
      end
      @sell_in = @sell_in - 1
      if @sell_in < 0
      @quality = @quality - @quality
      end
    end
  end

  # Sulfuras class
  class Sulfuras
    attr_reader :quality, :sell_in

    def initialize(quality, sell_in)
      @quality, @sell_in = quality, sell_in
    end

    def update
    end
  end
end

# GildedRose class
class GildedRose

  # GoodCategory class
  class GoodCategory
    def build_for(item)
      if sulfuras?(item)
        Inventory::Sulfuras.new(item.quality, item.sell_in)
      elsif generic?(item)
        Inventory::Generic.new(item.quality, item.sell_in)
      elsif aged_brie?(item)
        Inventory::AgedBrie.new(item.quality, item.sell_in)
      elsif backstage_pass?(item)
        Inventory::BackstagePass.new(item.quality, item.sell_in)
      end
    end

    private

    def generic?(item)
      !(sulfuras?(item) or backstage_pass?(item) or aged_brie?(item))
    end

    def sulfuras?(item)
      item.name == 'Sulfuras, Hand of Ragnaros'
    end

    def backstage_pass?(item)
      item.name == 'Backstage passes to a TAFKAL80ETC concert'
    end

    def aged_brie?(item)
      item.name == 'Aged Brie'
    end

  end

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      good = GoodCategory.new.build_for(item)
      good.update
      item.quality = good.quality
      item.sell_in = good.sell_in
    end
  end
end

# Item class
class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
