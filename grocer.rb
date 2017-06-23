require "pry"
def consolidate_cart(cart)
  results = {}
  cart.each do |item|
    item.each do |key, values|

      if results[key] == nil
        results[key] = values
        results[key][:count] = 1
        #binding.pry
      else
        results[key][:count] += 1
      end
    end
  end
  results
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.has_key?(coupon[:item])
        #binding.pry
      if cart[coupon[:item]][:count] >= coupon[:num]
        count = 0

        while cart[coupon[:item]][:count] >= coupon[:num]
          cart[coupon[:item]][:count] = cart[coupon[:item]][:count] - coupon[:num]
          count +=1
        end
        #binding.pry
        cart["#{coupon[:item]} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[coupon[:item]][:clearance], :count => count}
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, info|
    info.each do |key, value|
        if key == :clearance && value == true
          #binding.pry
          info[:price] = (info[:price] * 0.8).round(1)
        end
    end
  end
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0
  cart.each do |item, info|
    total += info[:price] * info[:count]
  end
  if total > 100
    total = (total * 0.90). round(1)
  end
  total
end
