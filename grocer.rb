def consolidate_cart(cart: [])

  consolCart = {}

  cart.each do |foodHash|
    foodHash.each do |food, foodData|
      consolCartData = consolCart[food]
      if consolCartData == nil 
        consolCartData = {}
        consolCart[food] = foodData
        consolCart[food][:count] = 1
      else
        consolCart[food][:count] += 1
      end
    end
  end
  consolCart
end

def apply_single_coupon(cart, coupon)

  coupItem = coupon[:item]
  
  if cart.keys.include?(coupItem) && cart[coupItem][:count] >= coupon[:num]
    cart[coupItem][:count] = cart[coupItem][:count] - coupon[:num]
    cart["#{coupItem} W/COUPON"] ||= {}
    cart["#{coupItem} W/COUPON"][:price] = coupon[:cost]
    cart["#{coupItem} W/COUPON"][:clearance] = cart[coupItem][:clearance]
    cart["#{coupItem} W/COUPON"][:count] ||= 0
    cart["#{coupItem} W/COUPON"][:count] += 1
  end
end

def apply_coupons(cart: [], coupons: [])
  coupons.each do |couponHash|
    apply_single_coupon(cart, couponHash)
  end
  cart
end


def apply_clearance(cart:[])
  cart.each do |item, itemHash|
    if itemHash[:clearance] == true
      itemHash[:price] = (itemHash[:price] * 0.80).round(2)
    end
  end
end

def checkout(cart: [], coupons: [])
  consolCart = consolidate_cart(cart: cart)
  appliedCoupons = apply_coupons(cart: consolCart, coupons: coupons)
  appliedClearance = apply_clearance(cart: appliedCoupons)
  
  total = 0
  appliedClearance.each do |item, itemHash|
    total += (itemHash[:count] * itemHash[:price])
  end
  
  if total > 100
    total = total * 0.90
  end
  
  total.round(2)
end
