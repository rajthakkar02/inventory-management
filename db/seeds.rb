# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Seeding database..."

# Create Super Admin account
superadmin = User.find_or_create_by!(email: "superadmin@shop.com") do |u|
  u.name = "Super Admin"
  u.password = "superadmin123"
  u.password_confirmation = "superadmin123"
  u.role = "superadmin"
  u.active = true
end
puts "✅ Super Admin account created: #{superadmin.email} (password: superadmin123)"

# Create Admin account
admin = User.find_or_create_by!(email: "admin@shop.com") do |u|
  u.name = "Shop Admin"
  u.password = "admin123"
  u.password_confirmation = "admin123"
  u.role = "admin"
  u.active = true
end
puts "✅ Admin account created: #{admin.email} (password: admin123)"

# Create a sample staff account
staff = User.find_or_create_by!(email: "staff@shop.com") do |u|
  u.name = "Staff Member"
  u.password = "staff123"
  u.password_confirmation = "staff123"
  u.role = "staff"
  u.active = true
end
puts "✅ Staff account created: #{staff.email} (password: staff123)"

# Sample products for testing
puts "\n📦 Creating sample products..."

products_data = [
  { name: "iPhone 15 Pro Max", category: "mobile", brand: "Apple", model_number: "A2849", color: "Natural Titanium", storage: "256GB", purchase_price: 135000, selling_price: 159900, quantity: 5 },
  { name: "Galaxy S24 Ultra", category: "mobile", brand: "Samsung", model_number: "SM-S928B", color: "Titanium Gray", storage: "256GB", purchase_price: 115000, selling_price: 134999, quantity: 3 },
  { name: "OnePlus 12", category: "mobile", brand: "OnePlus", model_number: "CPH2583", color: "Silky Black", storage: "256GB", purchase_price: 55000, selling_price: 64999, quantity: 8 },
  { name: "Redmi Note 13 Pro+", category: "mobile", brand: "Xiaomi", model_number: "2312DRA50I", color: "Midnight Black", storage: "256GB", purchase_price: 25000, selling_price: 31999, quantity: 12 },
  { name: "Pixel 8 Pro", category: "mobile", brand: "Google", model_number: "G1MNW", color: "Obsidian", storage: "128GB", purchase_price: 85000, selling_price: 106999, quantity: 2 },
  { name: "Vivo V30 Pro", category: "mobile", brand: "Vivo", model_number: "V2318", color: "Peacock Green", storage: "256GB", purchase_price: 30000, selling_price: 39999, quantity: 6 },
  { name: "Realme GT 5 Pro", category: "mobile", brand: "Realme", model_number: "RMX3888", color: "Moon White", storage: "128GB", purchase_price: 28000, selling_price: 34999, quantity: 4 },
  { name: "20W USB-C Charger", category: "accessory", brand: "Apple", accessory_type: "charger", purchase_price: 1200, selling_price: 1900, quantity: 25 },
  { name: "Galaxy Buds2 Pro", category: "accessory", brand: "Samsung", accessory_type: "earphone", purchase_price: 8000, selling_price: 12999, quantity: 10 },
  { name: "Clear Case iPhone 15", category: "accessory", brand: "Apple", accessory_type: "case", purchase_price: 200, selling_price: 599, quantity: 30 },
  { name: "Tempered Glass S24 Ultra", category: "accessory", brand: "Generic", accessory_type: "screen_guard", purchase_price: 50, selling_price: 299, quantity: 50 },
  { name: "USB-C to Lightning Cable 1m", category: "accessory", brand: "Apple", accessory_type: "cable", purchase_price: 500, selling_price: 1900, quantity: 15 },
  { name: "Mi Power Bank 20000mAh", category: "accessory", brand: "Xiaomi", accessory_type: "power_bank", purchase_price: 1200, selling_price: 1799, quantity: 8 },
  { name: "JBL Go 3 Speaker", category: "accessory", brand: "JBL", accessory_type: "speaker", purchase_price: 2500, selling_price: 3999, quantity: 5 },
  { name: "Type-C Fast Charger 65W", category: "accessory", brand: "Anker", accessory_type: "charger", purchase_price: 1500, selling_price: 2499, quantity: 20 },
]

products_data.each do |data|
  product = Product.find_or_create_by!(name: data[:name], brand: data[:brand]) do |p|
    p.assign_attributes(data)
  end
  puts "  📱 #{product.display_name} — ₹#{product.selling_price.to_i} (#{product.quantity} in stock)"
end

puts "\n🎉 Seeding complete!"
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "Login with:"
puts "  Super Admin: superadmin@shop.com / superadmin123"
puts "  Admin:       admin@shop.com / admin123"
puts "  Staff:       staff@shop.com / staff123"
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
