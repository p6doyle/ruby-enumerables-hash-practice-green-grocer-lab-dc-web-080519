require "pry"
def consolidate_cart(cart) # if you don't iterate through the item
  consolidated_cart = {}
  cart.each do |item|
    item_name = item.keys.first
    if consolidated_cart[item_name]
      consolidated_cart[item_name][:count] += 1
    else
      consolidated_cart[item_name] = {
        price: item[item_name][:price],
        clearance: item[item_name][:clearance],
        count: 1
      }
    end
  end
  consolidated_cart
end

def consolidate_cart(cart) # if you iterate through the item
  consolidated_cart = {}
  cart.each do |item|
    item.each do |name, details|
      if consolidated_cart[name]
        consolidated_cart[name][:count] += 1
      else
        consolidated_cart[name] = details
        consolidated_cart[name][:count] = 1
      end
    end
  end
  consolidated_cart
end


def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item_name = coupon[:item]
    if cart[item_name] && cart[item_name][:count] >= coupon[:num]
      # this method will pass without second half of the condition above but will cause checkout method to fail later
      # basically, you need to check that the uncouponed items *left* in the cart is more than the original num of couponed items,
      # so that you're not ultimately couponing more items than you have coupons for
      # you decrement the number of uncouponed items, but never decrement the number of coupons, so you need to
      # account for this, or you'll apply more coupons than you have, essentially
      # failure occurs when there are 3 beers, but only 2 coupons for them
      if cart["#{item_name} W/COUPON"]
        cart["#{item_name} W/COUPON"][:count] += coupon[:num] #update count of couponed items
      else
        cart["#{item_name} W/COUPON"] = {
          price: coupon[:cost] / coupon[:num],
          clearance: cart[item_name][:clearance],
          count: coupon[:num]
        }
      end
      cart[item_name][:count] -= coupon[:num] # update count of un-couponed items
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item_name, values|
    if values[:clearance]
      values[:price] = (values[:price] * 0.8).round(2)
    end
  end
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)

  total = 0
  final_cart.each do |item_name, details|
    total += details[:price] * details[:count]
  end
  total > 100 ? total * 0.9 : total
end