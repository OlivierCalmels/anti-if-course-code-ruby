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
      def self.build(sell_in)
        if sell_in < 0
          Expired.new
        else
          new
        end
      end

      # Expired class
      class Expired
        def update(quality, _)
          quality.degrade
          quality.degrade
        end
      end

      def update(quality, _)
        quality.degrade
      end
    end

    # AgedBrie class
    class AgedBrie
      def self.build(sell_in)
        if sell_in < 0
          Expired.new
        else
          new
        end
      end

      # Expired Class
      class Expired
        def update(quality, _)
          quality.increase
          quality.increase
        end
      end

      def update(quality, _)
        quality.increase
      end
    end

    # BackstagePass class
    class BackstagePass
      def self.build(sell_in)
        if sell_in < 0
          Expired.new
        else
          new
        end
      end

      class Expired
        def update(quality, _)
          quality.reset
        end
      end

      def update(quality, sell_in)
        quality.increase
        if sell_in < 10
          quality.increase
        end
        if sell_in < 5
          quality.increase
        end
      end
    end
  end

  # GoodCategory class
  class GoodCategory
    def build_for(item)
      case item.name
      when 'Backstage passes to a TAFKAL80ETC concert'
        Inventory::BackstagePass.build(item.sell_in)
      when 'Aged Brie'
        Inventory::AgedBrie.build(item.sell_in)
      else
        Inventory::Generic.build(item.sell_in)
      end
    end
  end

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      next if sulfuras?(item)

      item.sell_in -= 1
      quality = Inventory::Quality.new(item.quality)
      good = GoodCategory.new.build_for(item)
      good.update(quality, item.sell_in)
      item.quality = quality.amount
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
