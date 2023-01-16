# frozen_string_literal:true

# GildedRose class
class GildedRose
  module Inventory
    # Quality class
    class Quality
      attr_reader :amount

      def initialize(amount)
        @amount = amount
      end

      def degrade
        @amount -= 1 if amount > 0
      end

      def increase
        @amount += 1 if amount < 50
      end

      def reset
        @amount = 0
      end
    end

    # Generic class
    class Generic
      attr_reader :sell_in

      def initialize(quality, sell_in)
        @quality = Quality.new(quality)
        @sell_in = sell_in
      end

      def quality
        @quality.amount
      end

      def update
        @quality.degrade
        @sell_in = sell_in - 1
        @quality.degrade if sell_in < 0
      end
    end

    # AgedBrie class
    class AgedBrie
      attr_reader :sell_in

      def initialize(quality, sell_in)
        @quality = Quality.new(quality)
        @sell_in = sell_in
      end

      def quality
        @quality.amount
      end

      def update
        @quality.increase
        @sell_in = sell_in - 1
        @quality.increase if sell_in < 0
      end
    end

    # BackstagePass class
    class BackstagePass
      attr_reader :sell_in

      def initialize(quality, sell_in)
        @quality = Quality.new(quality)
        @sell_in = sell_in
      end

      def quality
        @quality.amount
      end

      def update
        @quality.increase
        @quality.increase if sell_in < 11
        @quality.increase if sell_in < 6
        @sell_in = sell_in - 1
        @quality.reset if sell_in < 0
      end
    end
  end

  # GoodCategory class
  class GoodCategory
    def build_for(item)
      case item.name
      when 'Backstage passes to a TAFKAL80ETC concert'
        Inventory::BackstagePass.new(item.quality, item.sell_in)
      when 'Aged Brie'
        Inventory::AgedBrie.new(item.quality, item.sell_in)
      else
        Inventory::Generic.new(item.quality, item.sell_in)
      end
    end
  end

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      next if sulfuras?(item)

      good = GoodCategory.new.build_for(item)
      good.update
      item.quality = good.quality
      item.sell_in = good.sell_in
    end
  end

  private

  def sulfuras?(item)
    item.name.eql?('Sulfuras, Hand of Ragnaros')
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

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
