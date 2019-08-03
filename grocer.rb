def consolidate_cart(cart:[])
  # code here
  my_hash = {}

  cart.each do |item|
    item.each do |itemname, data|
      if my_hash[itemname] == nil
        my_hash[itemname] = data
        my_hash[itemname][:count] = 1 
      else
        my_hash[itemname][:count] += 1
      end
    end
  end
  my_hash
end

def apply_coupons(cart:[], coupons:[])
  # code here
  my_hash = {}
  if coupons == nil || coupons.empty?
    my_hash = cart
  end
  coupons.each do |coupon|
    cart.each do |itemname, data|
      if itemname == coupon[:item]
        count = data[:count] - coupon[:num]

        if count >= 0
          if my_hash["#{itemname} W/COUPON"] == nil
            my_hash["#{itemname} W/COUPON"] = {price: coupon[:cost], clearance: data[:clearance], count: 1}
          else
            couponcount = my_hash["#{itemname} W/COUPON"][:count] + 1
            my_hash["#{itemname} W/COUPON"] = {price: coupon[:cost], clearance: data[:clearance], count: couponcount}
          end
        else
          count = data[:count]
        end
        my_hash[itemname] = data
        my_hash[itemname][:count] = count
      else
        my_hash[itemname] = data
      end
    end
  end
  my_hash
end

def apply_clearance(cart:[])
  # code here
  cart.each do |itemname, data|
    if data[:clearance]
      discount = data[:price] * 0.8
      data[:price] = discount.round(2)
    end
  end
  cart
end

def checkout(cart: [], coupons: [])
  # code here
end 
  cart = consolidate_cart(cart:cart)
  cart = apply_coupons(cart:cart, coupons:coupons)
  cart = apply_clearance(cart:cart)
  total = 0
  cart.each do |itemname, data|
    total += ( data[:price] * data[:count] )
  end
  if total > 100
    puts total
    total = total - (total * 0.1 )
    #total.round(2)
  end
  total
end

